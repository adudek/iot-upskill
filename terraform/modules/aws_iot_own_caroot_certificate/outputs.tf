output "id" {
  value = "${shell_script.ca_root.output.id}"
}

output "arn" {
  value = "${shell_script.ca_root.output.arn}"
}

output "key" {
  value = "${shell_script.ca_root.output.key}"
}

output "pem" {
  value = "${shell_script.ca_root.output.pem}"
}

output "status" {
  value = "${shell_script.ca_root.output.status}"
}

output "auto_registration_status" {
  value = "${shell_script.ca_root.output.auto_registration_status}"
}
