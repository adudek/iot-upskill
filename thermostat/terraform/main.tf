provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "shell" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_iot_partition = "aws:iot:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
}

data "template_file" "thing_type_list" {
  count = length(values(var.things))

  template = "${values(var.things).*.type[count.index]}"
}
