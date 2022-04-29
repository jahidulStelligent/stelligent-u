#!/bin/bash
cd /tmp
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb
touch /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
printf "{\n  \"agent\": {\n    \"metrics_collection_interval\": 60,\n    \"run_as_user\": \"cwagent\"\n  },\n  \"metrics\": {\n    \"append_dimensions\": {\n        \"InstanceId\": \"${aws:InstanceId}\"\n    },\n    \"metrics_collected\": {\n      \"disk\": {\n        \"measurement\": [\n          \"used_percent\"\n        ],\n        \"metrics_collection_interval\": 60,\n        \"resources\": [\n          \"/\"\n        ]\n      }\n    }\n  }\n}\n" >> /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
systemctl restart amazon-cloudwatch-agent

#dpkg -i -E ./amazon-cloudwatch-agent.deb
#sudo wget https://s3.us-east-1.amazonaws.com/amazoncloudwatch-agent-us-east-1/ubuntu/arm64/latest/amazon-cloudwatch-agent.deb
# To know if the cloudwatch agent state
# sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a stop
# Take new configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json