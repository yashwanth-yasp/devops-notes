# count - Create multiple similar resources
resource "aws_instance" "web" {
  count         = 3
  instance_type = "t3.micro"
  
  tags = {
    Name = "web-server-${count.index + 1}"
  }
}

# for_each - Create resources based on map or set
resource "aws_instance" "web" {
  for_each      = toset(["web1", "web2", "api"])
  instance_type = "t3.micro"
  
  tags = {
    Name = each.key
    Role = each.value
  }
}

# lifecycle - Control resource behavior
resource "aws_instance" "web" {
  instance_type = var.instance_type
  
  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes       = [tags]
  }
}
