resource "aws_iot_thing" "anything" {
  lifecycle {
    create_before_destroy = true
  }

  name = "anything"

  attributes = {
    any = "thing"
  }
}

resource "aws_iot_thing" "something" {
  name = "something"

  attributes = {
    some = "thing"
  }
}

resource "aws_iot_thing_principal_attachment" "something_pubsuball" {
  principal = module.aws_iot_own_device_certificate.arn
  thing     = aws_iot_thing.something.name
}
