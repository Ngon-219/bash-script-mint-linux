#!/bin/bash

# Append the variables to ~/.bashrc using a Here-Doc
cat << 'EOF' >> ~/.bashrc


export ANTHROPIC_AUTH_TOKEN="sk-bf-your-virtual-key-here"
export ANTHROPIC_BASE_URL="https://bifrost.sotatek.works/anthropic"
export ANTHROPIC_MODEL="fridayaix/claude-opus-4-7"
export ANTHROPIC_DEFAULT_OPUS_MODEL="fridayaix/claude-opus-4-6"
export ANTHROPIC_DEFAULT_SONNET_MODEL="fridayaix/claude-sonnet-4-6"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="fridayaix/claude-haiku-4-5-20251001"
EOF


source ~/.bashrc


echo "Setup complete. Current active variables:"
echo "Token: $ANTHROPIC_AUTH_TOKEN"
echo "Base URL: $ANTHROPIC_BASE_URL"
echo "Opus Model: $ANTHROPIC_DEFAULT_OPUS_MODEL"
