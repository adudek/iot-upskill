/*
This module is released by PGS Software under LGPLv2.
All content remains the copyright of PGS Software © 2019
For more information on PGS Software, please visit www.pgs-soft.com
*/

resource "shell_script" "ca_root" {
  lifecycle_commands {
    create = "bash -eux scripts/create.sh >&3"
    read   = "cat >&3"
    update = "bash -eux scripts/update.sh >&3"
    delete = "bash -eux scripts/delete.sh #${md5(jsonencode(local.taint))}"
  }

  working_directory = "${path.module}"

  environment = {
    aws_region              = "${var.aws_region}"
    aws_profile             = "${var.aws_profile}"
    active                  = "${var.active != 0 ? "ACTIVE" : "INACTIVE"}"
    certificate_information = "${var.certificate_information}"
    allow_autoregistration  = "${var.allow_autoregistration != 0 ? "ENABLE" : "DISABLE"}"
    cacert_pem              = "${var.cacert_pem}"
    cacert_key              = "${var.cacert_key}"
    caroot_pem              = "${var.caroot_pem}"
    caroot_key              = "${var.caroot_key}"
  }
}

locals {
  taint = {
    certificate_information = "${var.certificate_information}"
    cacert_pem              = "${var.cacert_pem}"
    cacert_key              = "${var.cacert_key}"
    caroot_pem              = "${var.caroot_pem}"
    caroot_key              = "${var.caroot_key}"
  }
}
