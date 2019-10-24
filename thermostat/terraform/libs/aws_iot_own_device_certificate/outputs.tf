output "id" {
  value = shell_script.device_certificate.output.id
}

output "arn" {
  value = shell_script.device_certificate.output.arn
}

output "private_key" {
  value = shell_script.device_certificate.output.key
}

output "certificate_pem" {
  value = shell_script.device_certificate.output.pem
}

output "status" {
  value = shell_script.device_certificate.output.status
}

output "ca_certificate_id" {
  value = shell_script.device_certificate.output.ca_certificate_id
}
