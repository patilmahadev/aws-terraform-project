variable "profile" {}

variable "region" {}

variable "instance-type" {}

variable "ami" {
  type = map
  default = {
    us-east-1 = "ami-0323c3dd2da7fb37d"
    us-east-2 = "ami-0f7919c33c90f5b58"
    us-west-1 = "ami-06fcc1f0bc2c8943f"
    us-west-2 = "ami-0d6621c01e8c2de2c"
  }
}
