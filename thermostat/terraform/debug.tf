resource "null_resource" "thermostat" {
  for_each = var.things

  provisioner "local-exec" {
    command = "echo 'key: ${each.key}, value: ${jsonencode(each.value)}'"
  }
}
