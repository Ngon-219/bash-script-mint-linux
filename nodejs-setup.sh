#!/bin/bash

echo "update apt"
sudo apt update

echo "install nodejs and npm"
sudo apt install nodejs npm

echo "install nodejs npm success"

node --version
echo "login node version to confirm installed"
