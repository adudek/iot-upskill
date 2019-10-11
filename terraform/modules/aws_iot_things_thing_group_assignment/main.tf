/*
This module is released by PGS Software under LGPLv2.
All content remains the copyright of PGS Software © 2019
For more information on PGS Software, please visit www.pgs-soft.com
*/

resource "shell_script" "thing_group" {
  for_each = toset(var.things)

  lifecycle_commands {
    create = "bash -eux scripts/create.sh >&3"
    read   = "cat >&3"
    delete = "bash -eux scripts/delete.sh #${md5(jsonencode("asdf"))}"
  }

  working_directory = path.module

  environment = {
    aws_region       = var.aws_region
    aws_profile      = var.aws_profile
    thing_name       = each.value
    thing_group_name = var.thing_group_name
  }
}
