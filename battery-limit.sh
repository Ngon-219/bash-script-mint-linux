#!/bin/bash

# Đường dẫn conservation_mode
CM_PATH="/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"

if [[ ! -f "$CM_PATH" ]]; then
  echo "Không tìm thấy conservation_mode ở $CM_PATH"
  exit 1
fi

case "$1" in
  on|enable|60)
    echo 1 | sudo tee "$CM_PATH"
    echo "✅ Conservation mode BẬT (pin sẽ dừng sạc ở ~60%)"
    ;;
  off|disable|100)
    echo 0 | sudo tee "$CM_PATH"
    echo "✅ Conservation mode TẮT (pin sẽ sạc đầy 100%)"
    ;;
  status)
    val=$(cat "$CM_PATH")
    if [[ "$val" == "1" ]]; then
      echo "🔋 Conservation mode: ON (~60%)"
    else
      echo "🔋 Conservation mode: OFF (100%)"
    fi
    ;;
  *)
    echo "Cách dùng:"
    echo "  $0 on|enable|60    → giới hạn sạc khoảng 60%"
    echo "  $0 off|disable|100 → sạc đầy 100%"
    echo "  $0 status          → kiểm tra trạng thái"
    exit 1
    ;;
esac
