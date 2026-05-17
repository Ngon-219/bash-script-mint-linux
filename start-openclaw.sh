#!/bin/bash

echo "Starting OpenClaw services..."

echo "Gateway initializing..."
openclaw gateway start > /dev/null 2>&1 &
GATEWAY_PID=$!
echo "Gateway is running (PID: $GATEWAY_PID)"

echo "Dashboard initializing..."
openclaw dashboard start > /dev/null 2>&1 &
DASHBOARD_PID=$!
echo "Dashboard is running (PID: $DASHBOARD_PID)"

sleep 6

echo "Open dashboard in chrome browser at: http://localhost:18789/chat?session=main"
google-chrome http://localhost:18789/chat?session=main > /dev/null 2>&1 & 

wait $GATEWAY_PID $DASHBOARD_PID