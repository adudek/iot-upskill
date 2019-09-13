resource "aws_iot_thing" "something" {
  name = "something"

  attributes = {
    some = "thing"
  }
}

resource "aws_iot_thing_principal_attachment" "something_pubsuball" {
  principal = "${aws_iot_certificate.pubsuball.arn}"
  thing     = "${aws_iot_thing.something.name}"
}
