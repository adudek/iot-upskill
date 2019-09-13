data "aws_iam_policy_document" "pubsuball" {
  statement {
    effect = "Allow"
    actions = [ "iot:*" ]
    resources = [ "*" ]
  }
}

resource "aws_iot_policy" "pubsuball" {
  name = "pubsuball"
  policy = "${data.aws_iam_policy_document.pubsuball.json}"
}

resource "aws_iot_policy_attachment" "pubsuball" {
  policy = "${aws_iot_policy.pubsuball.name}"
  target = "${aws_iot_certificate.pubsuball.arn}"
}
resource "aws_iot_certificate" "pubsuball" {
  active = true
}

resource "null_resource" "cert_dir" {
  triggers = { uuid = "${uuid()}" }

  provisioner "local-exec" {
    command = "rm -rf out/cert && mkdir out && cp -a cert out/cert"
  }
}

resource "null_resource" "iot_certs" {
  depends_on = [ "null_resource.cert_dir" ]
  triggers = { uuid = "${uuid()}" }

  provisioner "local-exec" {
    command = "echo '${aws_iot_certificate.pubsuball.certificate_pem}' > out/cert/certificate.pem.crt"
  }

  provisioner "local-exec" {
    command = "echo '${aws_iot_certificate.pubsuball.public_key}' > out/cert/public.pem.key"
  }

  provisioner "local-exec" {
    command = "echo '${aws_iot_certificate.pubsuball.private_key}' > out/cert/private.pem.key"
  }
}
