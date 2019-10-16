# profile used by module aws cli
variable "aws_profile" {
  type = "string"
}

# region used by module aws cli
variable "aws_region" {
  type = "string"
}

variable "name" {
  type = "string"
}

variable "parent_group_name" {
  default = ""
}
