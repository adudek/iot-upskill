
data "aws_iam_policy_document" "thing_pubsub" {
  for_each = var.things

  statement {
    effect    = "Allow"
    actions   = [
      "iot:Publish",
      "iot:Connect"
    ]
    resources = [
      "${replace(aws_iot_thing.customer_thing[each.key].arn, "/:thing/.*/", "")}:client/&{iot:Connection.Thing.ThingName}",
      "${replace(aws_iot_thing.customer_thing[each.key].arn, "/:thing/.*/", "")}:topic/&{iot:Connection.Thing.ThingName}",
    ]
  }
}

resource "aws_iot_policy" "thing_pubsub" {
  for_each = var.things

  name   = "client-${each.key}-pubsub"
  policy = data.aws_iam_policy_document.thing_pubsub[each.key].json
}

resource "aws_iot_policy_attachment" "device_certificate_pubsuball" {
  for_each = aws_iot_certificate.aws_cert

  policy = "client-${each.key}-pubsub"
  target = each.value.arn
}
