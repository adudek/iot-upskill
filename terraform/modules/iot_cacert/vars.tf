# profile used by module aws cli
variable "aws_profile" {
  type = "string"
}

# region used by module aws cli
variable "aws_region" {
  type = "string"
}

# set CA certificate active state
variable "active" {
  default = 1
}

# set CA certificate device certificate autoregistration
variable "allow_autoregistration" {
  default = 1
}

variable "certificate_information" {
  default = "/CN=throwaway IoT CA/emailAddress=em@il"
}

# root CA
variable "caroot_pem" {
  default = ""
}

variable "caroot_key" {
  default = ""
}

# CA certificate
variable "cacert_pem" {
  default = ""
}

variable "cacert_key" {
  default = ""
}
