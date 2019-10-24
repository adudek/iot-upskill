provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "shell" {}

data "aws_partition" "current" {}
