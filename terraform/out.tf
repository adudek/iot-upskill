locals {
  outdir = "out"
}

resource "local_file" "certificate_key" {
  content     = module.aws_iot_own_device_certificate.private_key
  filename    = "${local.outdir}/certificate.key"
}

resource "local_file" "certificate_pem" {
  content     = module.aws_iot_own_device_certificate.certificate_pem
  filename    = "${local.outdir}/certificate.pem"
}

resource "local_file" "aws_certificate_key" {
  content     = aws_iot_certificate.aws_cert.private_key
  filename    = "${local.outdir}/aws_certificate.key"
}

resource "local_file" "aws_certificate_pem" {
  content     = aws_iot_certificate.aws_cert.certificate_pem
  filename    = "${local.outdir}/aws_certificate.pem"
}
