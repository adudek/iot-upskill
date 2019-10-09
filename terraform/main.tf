provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

provider "shell" {}

module "cacert" {
  source = "./modules/aws_iot_own_caroot_certificate"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  active = 1
  allow_autoregistration = 0
}

module "device_cert" {
  source = "./modules/aws_iot_own_device_certificate"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  status = "ACTIVE"
  caroot_key = "${module.cacert.certificate_data.key}"
  caroot_pem = "${module.cacert.certificate_data.pem}"
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

output "device_cert" {
  value = "${module.device_cert.certificate_data}"
}

output "cacert" {
  value = "${module.cacert.certificate_data}"
}
