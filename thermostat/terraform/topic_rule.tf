resource "aws_iot_topic_rule" "filter_thermostat_measurements" {

  name        = "filter_thermostat_measurements"
  enabled     = true
  sql         = "SELECT * FROM 'thermostat' WHERE 1=1"
  sql_version = "2015-10-08"
}
