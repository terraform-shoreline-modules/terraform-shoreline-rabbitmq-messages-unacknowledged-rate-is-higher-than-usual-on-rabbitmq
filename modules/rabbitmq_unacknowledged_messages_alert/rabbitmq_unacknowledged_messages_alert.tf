resource "shoreline_notebook" "rabbitmq_unacknowledged_messages_alert" {
  name       = "rabbitmq_unacknowledged_messages_alert"
  data       = file("${path.module}/data/rabbitmq_unacknowledged_messages_alert.json")
  depends_on = [shoreline_action.invoke_update_memory_allocation,shoreline_action.invoke_rabbitmq_config_check]
}

resource "shoreline_file" "update_memory_allocation" {
  name             = "update_memory_allocation"
  input_file       = "${path.module}/data/update_memory_allocation.sh"
  md5              = filemd5("${path.module}/data/update_memory_allocation.sh")
  description      = "Increase the resources allocated to RabbitMQ, such as increasing server memory or CPU, to improve its processing capacity."
  destination_path = "/agent/scripts/update_memory_allocation.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rabbitmq_config_check" {
  name             = "rabbitmq_config_check"
  input_file       = "${path.module}/data/rabbitmq_config_check.sh"
  md5              = filemd5("${path.module}/data/rabbitmq_config_check.sh")
  description      = "Check the RabbitMQ configuration settings to ensure that the message queue is properly configured and optimized for the volume of messages being processed."
  destination_path = "/agent/scripts/rabbitmq_config_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_update_memory_allocation" {
  name        = "invoke_update_memory_allocation"
  description = "Increase the resources allocated to RabbitMQ, such as increasing server memory or CPU, to improve its processing capacity."
  command     = "`chmod +x /agent/scripts/update_memory_allocation.sh && /agent/scripts/update_memory_allocation.sh`"
  params      = ["TOTAL_MEMORY_IN_KB","RABBITMQ_MEMORY_IN_KB","NEW_MEMORY_IN_KB"]
  file_deps   = ["update_memory_allocation"]
  enabled     = true
  depends_on  = [shoreline_file.update_memory_allocation]
}

resource "shoreline_action" "invoke_rabbitmq_config_check" {
  name        = "invoke_rabbitmq_config_check"
  description = "Check the RabbitMQ configuration settings to ensure that the message queue is properly configured and optimized for the volume of messages being processed."
  command     = "`chmod +x /agent/scripts/rabbitmq_config_check.sh && /agent/scripts/rabbitmq_config_check.sh`"
  params      = ["RABBITMQ_PASSWORD","QUEUE_NAME","RABBITMQ_USERNAME"]
  file_deps   = ["rabbitmq_config_check"]
  enabled     = true
  depends_on  = [shoreline_file.rabbitmq_config_check]
}

