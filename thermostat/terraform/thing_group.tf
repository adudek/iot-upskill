module "ephemeral" {
  source = "./libs/aws_iot_thing_group"

  aws_profile = var.aws_profile
  aws_region  = var.aws_region
  name        = "ephemeral"
}

module "persistent" {
  source = "./libs/aws_iot_thing_group"

  aws_profile = var.aws_profile
  aws_region  = var.aws_region
  name        = "persistent"
}

resource "aws_iot_policy_attachment" "persistent" {
  policy = aws_iot_policy.dynamodb_write.id
  target = module.persistent.arn
}
