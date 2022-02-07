#!/bin/bash
set -x
./kafka.sh deploy		# Deploy the kafka server, takes a while to be ready.
oc apply -f cl.yaml -f clf.yaml	# Configure logging.
./kafka.sh consumer		# Show log events in the kafka consumer.
# Ignore line: If you don't see a command prompt, try pressing enter.
# After a pause (up to 30s) you should see log records appearing.
