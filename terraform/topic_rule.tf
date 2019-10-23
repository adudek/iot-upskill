resource "aws_iot_topic_rule" "norules" {
  name        = "norules"
  description = "No Rulez"
  enabled     = true
  sql         = "SELECT * FROM 'something' WHERE 1=1"
  sql_version = "2015-10-08"

  sns {
    message_format = "RAW"
    role_arn       = aws_iam_role.sns_iot_norules_publish.arn
    target_arn     = aws_sns_topic.iot_norules.arn
  }
}

resource "aws_sns_topic" "iot_norules" {
  name = "iot-norules"
}

resource "aws_iam_role" "sns_iot_norules_publish" {
  name = "sns-iot-norules-publish"
  assume_role_policy = data.aws_iam_policy_document.sns_iot_norules_trust.json
}

resource "aws_iam_role_policy" "sns_iot_norules_publish" {
  name   = "sns-iot-norules-publish"
  role   = aws_iam_role.sns_iot_norules_publish.name
  policy = data.aws_iam_policy_document.sns_iot_norules_permissions.json
}

data "aws_iam_policy_document" "sns_iot_norules_trust" {
  statement {
    effect  = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type        = "Service"
      identifiers = [ "iot.amazonaws.com" ]
    }
  }
}

data "aws_iam_policy_document" "sns_iot_norules_permissions" {
  statement {
    effect  = "Allow"
    actions = [ "sns:Publish" ]
    resources = [ aws_sns_topic.iot_norules.arn ]
  }
}
