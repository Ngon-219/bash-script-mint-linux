#!/bin/bash
echo "Starting Docker service..."
sudo systemctl start docker
sudo systemctl start docker.socket
echo "✅ Docker started!"

