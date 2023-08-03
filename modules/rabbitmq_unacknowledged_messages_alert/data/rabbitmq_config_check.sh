

#!/bin/bash



# Set the RabbitMQ connection parameters

RABBITMQ_HOST=${RABBITMQ_HOST}

RABBITMQ_PORT=5672

RABBITMQ_USERNAME=${RABBITMQ_USERNAME}

RABBITMQ_PASSWORD=${RABBITMQ_PASSWORD}



# Check the RabbitMQ configuration settings

rabbitmqctl status

rabbitmqctl list_queues

rabbitmqctl list_exchanges

rabbitmqctl list_bindings



# Check the RabbitMQ configuration parameters for the message queue

rabbitmqctl list_queue ${QUEUE_NAME}

rabbitmqctl list_queue_bindings ${QUEUE_NAME}



# Check the RabbitMQ configuration parameters for all queues

rabbitmqctl list_queues name messages_ready messages_unacknowledged