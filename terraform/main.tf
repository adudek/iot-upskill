provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "shell" {}

module "cacert" {
  source = "./modules/iot_cacert"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  active = 1
  allow_autoregistration = 1
}

module "device_cert" {
  source = "./modules/iot_owncert"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  status = "INACTIVE"
  caroot_key = "${module.cacert.cert.caroot_key}"
  caroot_pem = "${module.cacert.cert.caroot_pem}"
}

data "aws_iam_policy_document" "pubsuball" {
  statement {
    effect = "Allow"
    actions = [ "iot:*" ]
    resources = [ "*" ]
  }
}

resource "aws_iot_policy" "pubsuball" {
  name = "pubsuball"
  policy = "${data.aws_iam_policy_document.pubsuball.json}"
}

output "cacert" {
  value = "${module.cacert.cert}"
}
