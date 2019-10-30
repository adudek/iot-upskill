data "aws_iam_policy_document" "thing_pubsub" {

  statement {
    effect    = "Allow"
    actions   = [
      "iot:Connect",
      "iot:GetThingShadow"
    ]
    resources = [ "arn:${local.aws_iot_partition}:client/&{iot:Connection.Thing.ThingName}" ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "iot:Publish",
      "iot:Receive"
    ]
    resources = [
      "arn:${local.aws_iot_partition}:topic/&{iot:Connection.Thing.ThingName}",
      "arn:${local.aws_iot_partition}:topic/&{iot:Connection.Thing.ThingName}/*",
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [ "iot:Subscribe" ]
    resources = [ "arn:${local.aws_iot_partition}:topicfilter/*" ]
  }
}

data "aws_iam_policy_document" "dynamodb_write" {

  statement {
    effect    = "Allow"
    actions   = [ "dynamodb:none" ]
    resources = [ "arn:${local.aws_iot_partition}:*" ]
  }
}

resource "aws_iot_policy" "client_topic_pubsub" {

  name   = "client-topic-pubsub"
  policy = data.aws_iam_policy_document.thing_pubsub.json
}

resource "aws_iot_policy" "dynamodb_write" {

  name   = "dynamodb-write"
  policy = data.aws_iam_policy_document.dynamodb_write.json
}
