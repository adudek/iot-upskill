variable "region" {
  default = "eu-central-1"
}

provider "aws" {
  region  = "${var.region}"
}

resource "aws_iot_thing" "something" {
  name = "something"

  attributes = {
    some = "thing"
  }
}

resource "aws_iot_certificate" "unsigned" {
  active = true
}

resource "aws_iot_thing_principal_attachment" "something_cert" {
  principal = "${aws_iot_certificate.unsigned.arn}"
  thing     = "${aws_iot_thing.something.name}"
}
