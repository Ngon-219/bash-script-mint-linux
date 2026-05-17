#!/bin/bash
echo "Stopping Docker service..."
sudo systemctl stop docker
sudo systemctl stop docker.socket
echo "🛑 Docker stopped!"

