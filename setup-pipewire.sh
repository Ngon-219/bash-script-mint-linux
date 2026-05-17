#!/bin/bash
set -e

echo "=== Gỡ toàn bộ PulseAudio ==="
sudo apt purge -y pulseaudio* pulseaudio-utils pavucontrol

echo "=== Cài các package cần thiết cho PipeWire ==="
sudo apt update
sudo apt install -y pipewire pipewire-audio-client-libraries \
    pipewire-alsa pipewire-pulse pipewire-jack \
    wireplumber libspa-0.2-bluetooth

echo "=== Kích hoạt PipeWire thay thế PulseAudio ==="
systemctl --user --now enable pipewire
systemctl --user --now enable pipewire-pulse
systemctl --user --now enable wireplumber

echo "=== Vô hiệu hóa PulseAudio (nếu tự bật lại) ==="
systemctl --user --now disable pulseaudio.service || true
systemctl --user --now disable pulseaudio.socket || true

echo "=== Hoàn tất. Khởi động lại máy để áp dụng. ==="
