
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Unacknowledged Messages Alert
---

This incident type occurs when the ratio of unacknowledged to acknowledged messages in a RabbitMQ queue is higher than usual. This may indicate a problem in the message pipeline and requires investigation to ensure that messages are being processed properly. It is often accompanied by a query alert monitor triggered by a specific metric threshold.

### Parameters
```shell
# Environment Variables

export RABBITMQ_HOSTNAME="PLACEHOLDER"

export NEW_MEMORY_IN_KB="PLACEHOLDER"

export TOTAL_MEMORY_IN_KB="PLACEHOLDER"

export RABBITMQ_MEMORY_IN_KB="PLACEHOLDER"

export RABBITMQ_PASSWORD="PLACEHOLDER"

export QUEUE_NAME="PLACEHOLDER"

export RABBITMQ_USERNAME="PLACEHOLDER"
```

## Debug

### 1. Check RabbitMQ status
```shell
systemctl status rabbitmq-server
```

### 2. Check RabbitMQ logs for errors
```shell
journalctl -u rabbitmq-server -f
```

### 3. Check RabbitMQ queue metrics
```shell
rabbitmqctl list_queues name messages_ready messages_unacknowledged
```

### 4. Check for network issues or latency
```shell
ping ${RABBITMQ_HOSTNAME}
```

### 5. Check for disk space issues on RabbitMQ server
```shell
df -h
```

### 6. Check for CPU and memory usage on RabbitMQ server
```shell
top
```

### 7. Check for any process that may be blocking RabbitMQ
```shell
sudo netstat -ltnp | grep 5672
```

### 8. Check for any RabbitMQ plugins that may be causing issues
```shell
rabbitmq-plugins list
```

### 9. Check RabbitMQ configuration files for errors
```shell
sudo rabbitmqctl eval 'application:ensure_all_started(rabbit).' && sudo rabbitmqctl eval 'rabbit_config_checks:run().'
```

### 10. Check for any network configurations that may be causing issues
```shell
sudo rabbitmqctl report | grep listeners
```

## Repair

### Increase the resources allocated to RabbitMQ, such as increasing server memory or CPU, to improve its processing capacity.
```shell


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


```

### Check the RabbitMQ configuration settings to ensure that the message queue is properly configured and optimized for the volume of messages being processed.
```shell


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


```