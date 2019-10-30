resource "aws_iot_thing_type" "customer_thing_type" {
  for_each = toset(distinct(data.template_file.thing_type_list.*.rendered))

  name = each.value
}

resource "aws_iot_thing" "customer_thing" {
  lifecycle { create_before_destroy = true }
  depends_on = [ "aws_iot_thing_type.customer_thing_type" ]
  for_each = var.things

  name = each.key
  thing_type_name = each.value.type
  attributes = each.value.tags
}

resource "aws_iot_thing_principal_attachment" "something_pubsuball" {
  for_each = aws_iot_thing.customer_thing

  principal  = aws_iot_certificate.aws_cert[each.key].arn
  thing      = each.key
}
