# The default provider configuration; resources that begin with `aws_` will use
# it as the default, and it can be referenced as `aws`.
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  region     = "us-east-1"
}


# Additional provider configuration for west coast region; resources can
# reference this as `aws.us-west-1`.
# Further read: https://www.terraform.io/docs/language/providers/configuration.html
provider "aws" {
  access_key = "ACCESS_KEY"
  secret_key = "SECRET_KEY"
  alias      = "us-west-1"
  region     = "us-west-1"
}

resource "aws_instance" "us_west_example" {
  provider      = aws.us-west-1
  ami           = "ami-07585467"
  instance_type = "t2.micro"
}

resource "aws_instance" "us_east_example" {
  ami           = "ami-66506c1c"
  instance_type = "t2.micro"
}