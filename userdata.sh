#!/bin/sh
instance_id=$(/usr/bin/curl --silent http://169.254.169.254/latest/meta-data/instance-id)
while true; do echo "HTTP/1.1 200 OK\n\n AWS EC2 instance_id = $instance_id" | nc -l -p 80; done