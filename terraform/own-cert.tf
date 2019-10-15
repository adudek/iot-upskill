module "aws_iot_own_caroot_certificate" {
  source = "./modules/aws_iot_own_caroot_certificate"

  aws_profile = "${var.aws_profile}"
  aws_region = "${var.aws_region}"
  active = 1
  allow_autoregistration = 0
}

module "aws_iot_own_device_certificate" {
  source = "./modules/aws_iot_own_device_certificate"

  aws_profile = var.aws_profile
  aws_region = var.aws_region
  status = "ACTIVE"
  caroot_key = module.aws_iot_own_caroot_certificate.key
  caroot_pem = module.aws_iot_own_caroot_certificate.pem
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
  policy = data.aws_iam_policy_document.pubsuball.json
}

resource "aws_iot_policy_attachment" "device_certificate_pubsuball" {
  policy = aws_iot_policy.pubsuball.name
  target = module.aws_iot_own_device_certificate.arn
}
