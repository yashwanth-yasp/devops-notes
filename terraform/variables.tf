variable "instance_type" {
  description = "The EC2 instance type to use for the web server."
  type        = string
  default     = "t2.micro" # This default value will be used if none is provided.
}