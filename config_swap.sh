#!/bin/bash

set -e

echo "turn off swapfile"
sudo swapoff /swapfile

echo "create new swap file with 32Gb"
sudo fallocate -l 32G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=4096 status=progress

echo "change mode file"
sudo chmod 600 /swapfile

echo "convert to swap file"
sudo mkswap /swapfile

echo "turn on swap"
sudo swapon /swapfile

echo "done check using: swapon --show"

