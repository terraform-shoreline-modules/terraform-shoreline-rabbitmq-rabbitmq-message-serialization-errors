resource "shoreline_notebook" "rabbitmq_message_serialization_errors" {
  name       = "rabbitmq_message_serialization_errors"
  data       = file("${path.module}/data/rabbitmq_message_serialization_errors.json")
  depends_on = [shoreline_action.invoke_add_message_versioning]
}

resource "shoreline_file" "add_message_versioning" {
  name             = "add_message_versioning"
  input_file       = "${path.module}/data/add_message_versioning.sh"
  md5              = filemd5("${path.module}/data/add_message_versioning.sh")
  description      = "Consider implementing message versioning, so that older versions of messages can still be processed correctly even if the serialization format changes. This can help prevent data corruption caused by incompatible message formats."
  destination_path = "/tmp/add_message_versioning.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_add_message_versioning" {
  name        = "invoke_add_message_versioning"
  description = "Consider implementing message versioning, so that older versions of messages can still be processed correctly even if the serialization format changes. This can help prevent data corruption caused by incompatible message formats."
  command     = "`chmod +x /tmp/add_message_versioning.sh && /tmp/add_message_versioning.sh`"
  params      = ["RABBITMQ_CONFIG_FILE"]
  file_deps   = ["add_message_versioning"]
  enabled     = true
  depends_on  = [shoreline_file.add_message_versioning]
}

