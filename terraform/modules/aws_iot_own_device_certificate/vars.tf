# profile used by module aws cli
variable "aws_profile" {
  type = "string"
}

# region used by module aws cli
variable "aws_region" {
  type = "string"
}

variable "certificate_information" {
  default = "/CN=throwaway IoT device cert/emailAddress=em@il"
}

# root CA
variable "caroot_pem" {
  default = ""
}

variable "status" {
  default = "ACTIVE"
}

variable "caroot_key" {
  default = ""
}
