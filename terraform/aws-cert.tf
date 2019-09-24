resource "aws_iot_certificate" "aws_cert" {
  active = true
}

resource "aws_iot_policy_attachment" "pubsuball" {
  policy = "${aws_iot_policy.pubsuball.name}"
  target = "${aws_iot_certificate.aws_cert.arn}"
}
