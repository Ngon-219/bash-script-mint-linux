#!/bin/bash
# wine-stop.sh
# Dừng toàn bộ tiến trình liên quan đến Wine

echo "Shutting down Wine..."

# Cách chuẩn: dùng wineserver
wineserver -k

# Kill các tiến trình liên quan (mỗi cái một lần pkill)
for proc in wine wineserver explorer.exe services.exe winedevice.exe; do
    pkill -9 -f "$proc" 2>/dev/null
done

echo "Wine shut down."

