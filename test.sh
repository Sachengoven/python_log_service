#!/bin/bash

apiendpoint="https://yg16l85e37.execute-api.us-east-1.amazonaws.com/prod"
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": '$(date +%s)',
    "severity": "info",
    "message": "This is a test log message from curl"
  }' \
  "$apiendpoint/addlog"
echo ""
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": '$(date +%s)',
    "severity": "info",
    "message": "This is a test log message from curl"
  }' \
  "$apiendpoint/addlog"
echo ""
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": '$(date +%s)',
    "severity": "info",
    "message": "This is a test log message from curl"
  }' \
  "$apiendpoint/addlog"
echo ""
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "timestamp": '$(date +%s)',
    "severity": "info",
    "message": "This is a test log message from curl"
  }' \
  "$apiendpoint/addlog"
echo ""
curl -X GET "$apiendpoint/getlogs"
