

#!/bin/bash



# Set variables

MEM_TOTAL=${TOTAL_MEMORY_IN_KB} # total memory of the server in KB

MEM_RABBITMQ=${RABBITMQ_MEMORY_IN_KB} # memory allocated to RabbitMQ in KB

MEM_NEW=$((MEM_TOTAL - MEM_RABBITMQ + ${NEW_MEMORY_IN_KB})) # new memory allocation in KB



# Update memory allocation

echo "Updating memory allocation for RabbitMQ..."

sed -i "s/{mem_limit, .*}/{mem_limit, $MEM_NEW}/" /etc/rabbitmq/rabbitmq.conf



# Restart RabbitMQ service

echo "Restarting RabbitMQ service..."

systemctl restart rabbitmq-server



echo "Memory allocation updated successfully."