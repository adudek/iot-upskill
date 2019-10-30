locals {
  outdir = "work/device_certs"
}

resource "aws_iot_certificate" "aws_cert" {
  for_each = var.things

  active = true
}

resource "local_file" "aws_certificate_key" {
  for_each = aws_iot_certificate.aws_cert

  content  = each.value.private_key
  filename = "${local.outdir}/${each.key}/certificate.key"
}

resource "local_file" "aws_certificate_pem" {
  for_each = aws_iot_certificate.aws_cert

  content  = each.value.certificate_pem
  filename = "${local.outdir}/${each.key}/certificate.pem"
}

resource "aws_iot_policy_attachment" "device_certificate_pubsub" {
  for_each = aws_iot_certificate.aws_cert

  policy = aws_iot_policy.client_topic_pubsub.id
  target = each.value.arn
}
