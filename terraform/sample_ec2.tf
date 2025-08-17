resource "aws_instance" "web" {
  ami           = "ami-04f59c565deeb2199"
  instance_type = "t2.medium"
  key_name      = "doddegowdanv"
  # No security group specified = uses default
  user_data = file("${path.module}/setup.sh")
  tags = {
    Name = "ydg-hackathon-k8-machine"
  }
}