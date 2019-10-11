locals {
  outdir = "out"
}

resource "local_file" "certificate_key" {
  content     = module.aws_iot_own_device_certificate.key
  filename    = "${local.outdir}/certificate.key"
}

resource "local_file" "certificate_pem" {
  content     = module.aws_iot_own_device_certificate.pem
  filename    = "${local.outdir}/certificate.pem"
}
