provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

module "cacert" {
  source = "./modules/selfsigned_cacert"
  src    = "./modules/selfsigned_cacert"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  cacert_configuration = "./modules/selfsigned_cacert/external/ca-cert.conf"
  cacert_pem = "./out/certs/ca-cert.pem"
  cacert_key = "./out/certs/ca-cert.key"
  caroot_pem = "./out/certs/ca-root.pem"
  caroot_key = "./out/certs/ca-root.key"
  create_certs = 1
  active = 1
  allow_autoregistration = 1
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
  value = "${module.cacert.cacert}"
}
