variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "eu-central-1"
}

variable "things" {
  type = map(object({
    type           = string
    customer_email = string
    customer_name  = string
    tags           = map(string)
  }))
}
