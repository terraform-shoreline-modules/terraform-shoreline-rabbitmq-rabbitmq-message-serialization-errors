
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# RabbitMQ Message Serialization Errors
---

RabbitMQ Message Serialization Errors refer to a type of incident where there are issues with the serialization of messages being sent via RabbitMQ. This can lead to data corruption and errors within the system. The incident involves debugging and fixing the issue in order to ensure proper functioning of the system.

### Parameters
```shell
export QUEUE_NAME="PLACEHOLDER"

export DELIVERY_TAG="PLACEHOLDER"

export DEAD_LETTER_QUEUE_NAME="PLACEHOLDER"

export RABBITMQ_CONFIG_FILE="PLACEHOLDER"
```

## Debug

### Check if RabbitMQ is running
```shell
sudo systemctl status rabbitmq-server
```

### Check if there are any error logs related to message serialization
```shell
sudo grep -i "message serialization" /var/log/rabbitmq/*
```

### Check if the messages in the queue are corrupted
```shell
sudo rabbitmqctl list_queues name messages | awk '$2 > 0 {print $1}' | xargs -L1 sudo rabbitmqctl eval 'io:format("~s~n", [rabbit_amqqueue:contents("${QUEUE_NAME}")])'
```

### Check the message payload for a specific delivery tag
```shell
sudo rabbitmqctl eval 'io:format("~s~n", [rabbit_amqqueue:lookup("${QUEUE_NAME}", ${DELIVERY_TAG})])'
```

### Check the message payload for a specific message ID
```shell
sudo rabbitmqctl eval 'io:format("~s~n", [rabbit_amqqueue:lookup_by_id("${QUEUE_NAME}", ${<"<message_id}>")])'
```

### Check the message payload in the dead letter queue
```shell
sudo rabbitmqctl eval 'io:format("~s~n", [rabbit_amqqueue:lookup("${DEAD_LETTER_QUEUE_NAME}", ${DELIVERY_TAG})])'
```

## Repair

### Consider implementing message versioning, so that older versions of messages can still be processed correctly even if the serialization format changes. This can help prevent data corruption caused by incompatible message formats.
```shell


#!/bin/bash



# Define variables

RABBITMQ_CONFIG_FILE=${RABBITMQ_CONFIG_FILE}



# Stop RabbitMQ server

sudo service rabbitmq-server stop



# Backup existing config file

sudo cp $RABBITMQ_CONFIG_FILE $RABBITMQ_CONFIG_FILE.bak



# Add message versioning configuration to RabbitMQ config file

sudo echo "rabbitmq_versioning=true" >> $RABBITMQ_CONFIG_FILE



# Start RabbitMQ server

sudo service rabbitmq-server start



echo "Message versioning has been implemented in RabbitMQ."


```