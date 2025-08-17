# Implicit dependency (Terraform detects automatically)
resource "aws_instance" "web" {
  subnet_id = aws_subnet.public.id  # Depends on subnet
}

# Explicit dependency
resource "aws_instance" "web" {
  # ... other configuration ...
  
  depends_on = [
    aws_internet_gateway.main,
    aws_route_table_association.public
  ]
}
