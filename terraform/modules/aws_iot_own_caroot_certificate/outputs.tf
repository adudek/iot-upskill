output "certificate_data" {
  value = "${shell_script.ca_root.output}"
}
