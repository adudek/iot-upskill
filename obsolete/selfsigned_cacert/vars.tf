# profile used by module aws cli
variable "aws_profile" {
  type = "string"
}

# region used by module aws cli
variable "aws_region" {
  type = "string"
}

# do not create ad-hoc selfsigned certificates if none are found (throw error)
variable "create_certs" {
  default = 1
}

# ssl configuration file path
variable "cacert_configuration" {
  type = "string"
}

# root CA certificate path
variable "caroot_pem" {
  type = "string"
}

variable "caroot_key" {
  type = "string"
}

# local CA certificate path
# must be signed by root CA certificate
variable "cacert_pem" {
  type = "string"
}

variable "cacert_key" {
  type = "string"
}

# same as module source (required for shell scripts relative paths)
variable "src" {
  default = "."
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
  default = "/CN=IoT CA/emailAddress=em@il"
}
