# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Launch Template
resource "aws_launch_template" "main" {
  name_prefix   = "${var.project_name}-${var.environment}-"
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  vpc_security_group_ids = var.security_group_ids

  monitoring {
    enabled = var.enable_monitoring
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  user_data = base64encode(var.user_data != "" ? var.user_data : local.default_user_data)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-instance"
      Environment = var.environment
      Project     = var.project_name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Default user data script
locals {
  default_user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    
    # Create a simple web page
    cat > /var/www/html/index.html << 'HTML'
    <!DOCTYPE html>
    <html>
    <head>
        <title>${var.project_name} - ${var.environment}</title>
    </head>
    <body>
        <h1>Welcome to ${var.project_name}</h1>
        <p>Environment: ${var.environment}</p>
        <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
        <p>Availability Zone: $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
    </body>
    </html>
HTML
    
    # Replace instance metadata in HTML
    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
    sed -i "s/\$(curl -s http:\/\/169.254.169.254\/latest\/meta-data\/instance-id)/$INSTANCE_ID/g" /var/www/html/index.html
    sed -i "s/\$(curl -s http:\/\/169.254.169.254\/latest\/meta-data\/placement\/availability-zone)/$AZ/g" /var/www/html/index.html
    
    systemctl restart httpd
  EOF
}

# EC2 Instances
resource "aws_instance" "main" {
  count = var.instance_count

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  subnet_id = var.subnet_ids[count.index % length(var.subnet_ids)]

  tags = {
    Name        = "${var.project_name}-${var.environment}-instance-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
    Index       = count.index + 1
  }
}

# Elastic IPs for instances (optional)
resource "aws_eip" "main" {
  count = var.instance_count

  instance = aws_instance.main[count.index].id
  domain   = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-eip-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
  }

  depends_on = [aws_instance.main]
}
