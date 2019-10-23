# profile used by module aws cli
variable "aws_profile" {
  type = "string"
}

# region used by module aws cli
variable "aws_region" {
  type = "string"
}

variable "things" {
  type = "list"
}

variable "thing_group_name" {
  type = "string"
}
