module "measurements_logging" {
  source = "./libs/aws_iot_thing_group"

  aws_profile = var.aws_profile
  aws_region  = var.aws_region
  name        = "measurements-logging"
}

resource "aws_iot_policy_attachment" "measurements_logging" {
  policy = aws_iot_policy.client_topic_pubsub.id
  target = module.measurements_logging.arn
}

module "measurements_discard" {
  source = "./libs/aws_iot_thing_group"

  aws_profile = var.aws_profile
  aws_region  = var.aws_region
  name        = "dynamodb-discard"
}

module "default_measurments_logging" {
  source = "./libs/aws_iot_things_thing_group_assignment"

  aws_profile      = var.aws_profile
  aws_region       = var.aws_region
  thing_group_name = module.measurements_logging.name
  things           = keys(var.things)
}
