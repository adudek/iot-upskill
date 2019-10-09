/*
This module is released by PGS Software under LGPLv2.
All content remains the copyright of PGS Software © 2019
For more information on PGS Software, please visit www.pgs-soft.com
*/

data "external" "cacert" {
  program = [ "bash", "-eux", "${var.src}/external/ca-cert-gen.sh" ]
  query = {
    createCerts             = "${var.create_certs != 0 ? "create" : "nocreate"}"
    cacertConf              = "${var.cacert_configuration}"
    cacertPem               = "${var.cacert_pem}"
    cacertKey               = "${var.cacert_key}"
    carootPem               = "${var.caroot_pem}"
    carootKey               = "${var.caroot_key}"
    active                  = "${var.active != 0 ? "ACTIVE" : "INACTIVE"}"
    certificate_information = "${var.certificate_information}"
    autoregistration        = "${var.allow_autoregistration != 0 ? "ENABLE" : "DISABLE"}"
    awsRegion               = "${var.aws_region}"
    awsProfile              = "${var.aws_profile}"
  }
}
