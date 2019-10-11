/*
This module is released by PGS Software under LGPLv2.
All content remains the copyright of PGS Software © 2019
For more information on PGS Software, please visit www.pgs-soft.com
*/

resource "shell_script" "thing_group" {
  lifecycle_commands {
    create = "bash -eux scripts/create.sh >&3"
    read   = "cat >&3"
    delete = "bash -eux scripts/delete.sh #${md5(jsonencode(local.taint))}"
  }

  working_directory = "${path.module}"

  environment = {
    aws_region              = "${var.aws_region}"
    aws_profile             = "${var.aws_profile}"
    name                    = "${var.name}"
    parent_group_name       = "${var.parent_group_name}"
  }
}

locals {
  taint = {
    name              = "${var.name}"
    parent_group_name = "${var.parent_group_name}"
  }
}
