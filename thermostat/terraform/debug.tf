output "things" {
  value = var.things
}

output "regio" {
  value = data.aws_region.current.endpoint
}
