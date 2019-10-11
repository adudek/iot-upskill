module "aws_iot_thing_group-my_group_1" {
  source = "./modules/aws_iot_thing_group"

  aws_profile = var.aws_profile
  aws_region  = var.aws_region
  name        = "my-group-1"
}

module "aws_iot_things_thing_group_assignment-something_somethinggroup" {
  source = "./modules/aws_iot_things_thing_group_assignment"

  aws_profile      = var.aws_profile
  aws_region       = var.aws_region
  thing_group_name = module.aws_iot_thing_group-my_group_1.name
  things           = [
    aws_iot_thing.something.name,
    aws_iot_thing.anything.name
  ]
}

resource "aws_iot_policy_attachment" "somethinggroup_pubsuball" {
  policy = aws_iot_policy.pubsuball.name
  target = module.aws_iot_thing_group-my_group_1.arn
}

output "thing_group" {
  value = module.aws_iot_thing_group-my_group_1.arn
}
