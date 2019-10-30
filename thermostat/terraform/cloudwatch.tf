data "aws_iam_policy_document" "cloudwatch_iot_logging_trust" {

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [ "iot.amazonaws.com" ]
    }
    actions   = [ "sts:AssumeRole" ]
  }
}

data "aws_iam_policy_document" "cloudwatch_iot_logging" {

  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:PutMetricFilter",
      "logs:PutRetentionPolicy"
    ]
    resources = [ "*" ]
  }
}

resource "aws_iam_role" "cloudwatch_iot_logging" {

  name               = "cloudwatch-iot-logging"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_iot_logging_trust.json
}

resource "aws_iam_role_policy" "cloudwatch_iot_logging" {
  provisioner "local-exec" {
    command = <<EOF
        aws --profile ${var.aws_profile} --region ${var.aws_region} \
        iot set-v2-logging-options \
          --role-arn ${aws_iam_role.cloudwatch_iot_logging.arn} \
          --default-log-level DEBUG \
    EOF
  }

  name   = "cloudwatch-iot-logging"
  role   = aws_iam_role.cloudwatch_iot_logging.id
  policy = data.aws_iam_policy_document.cloudwatch_iot_logging.json
}
