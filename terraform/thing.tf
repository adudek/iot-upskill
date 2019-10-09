resource "aws_iot_thing" "something" {
  name = "something"

  attributes = {
    some = "thing"
  }
}

resource "aws_iot_thing_principal_attachment" "something_pubsuball" {
  principal = "${module.device_cert.certificate_data.arn}"
  thing     = "${aws_iot_thing.something.name}"
}
