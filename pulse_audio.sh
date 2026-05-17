#!/bin/bash
set -e

echo "=== Gỡ bỏ PipeWire và WirePlumber ==="
sudo apt purge -y pipewire* wireplumber

echo "=== Cài đặt PulseAudio và module Bluetooth ==="
sudo apt install -y pulseaudio pulseaudio-module-bluetooth pulseaudio-utils pavucontrol

echo "=== Vô hiệu hóa PipeWire service nếu còn sót ==="
systemctl --user disable --now pipewire.service pipewire.socket pipewire-pulse.service pipewire-pulse.socket wireplumber.service || true

echo "=== Bật PulseAudio ==="
systemctl --user enable pulseaudio.service pulseaudio.socket
systemctl --user start pulseaudio.service pulseaudio.socket

echo "=== Xong! ==="
echo "Giờ bạn hãy restart máy rồi thử kết nối lại tai nghe/chuột Bluetooth."
