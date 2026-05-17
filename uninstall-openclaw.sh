#!/bin/bash

echo "=========================================="
echo "BẮT ĐẦU GỠ CÀI ĐẶT TOÀN BỘ OPENCLAW"
echo "=========================================="

# 1. Gỡ cài đặt qua NPM (Yêu cầu sudo để xóa package global)
echo "[1/4] Đang gỡ cài đặt các package npm global (openclaw, clawdbot, moltbot)..."
if command -v npm &> /dev/null; then
    sudo npm uninstall -g openclaw clawdbot moltbot 2>/dev/null
    echo "✓ Đã gỡ npm packages."
else
    echo "⚠ Không tìm thấy lệnh npm, bỏ qua bước này."
fi

# 2. Xóa Systemd Service (Chạy ngầm)
echo "[2/4] Đang dừng và xóa Systemd service..."
sudo systemctl stop openclaw 2>/dev/null
sudo systemctl disable openclaw 2>/dev/null
if [ -f /etc/systemd/system/openclaw.service ]; then
    sudo rm -f /etc/systemd/system/openclaw.service
    sudo systemctl daemon-reload
    echo "✓ Đã xóa service."
else
    echo "✓ Không tìm thấy service, bỏ qua."
fi

# 3. Xóa dữ liệu và cấu hình trong thư mục Home của user hiện tại
echo "[3/4] Đang dọn dẹp dữ liệu và cấu hình ở thư mục Home..."
rm -rf ~/.openclaw ~/.clawdbot ~/.moltbot
echo "✓ Đã xóa các thư mục ẩn (.openclaw, .clawdbot, .moltbot)."

# 4. Dọn dẹp Docker (Nếu có cài Docker)
echo "[4/4] Đang kiểm tra và dọn dẹp Docker..."
if command -v docker &> /dev/null; then
    # Tìm và xóa container có tên image chứa "openclaw"
    containers=$(docker ps -a | grep -i openclaw | awk '{print $1}')
    if [ ! -z "$containers" ]; then
        echo "Phát hiện container OpenClaw. Đang dừng và xóa..."
        sudo docker stop $containers 2>/dev/null
        sudo docker rm $containers 2>/dev/null
    fi
    
    # Tìm và xóa image chứa "openclaw"
    images=$(docker images | grep -i openclaw | awk '{print $3}')
    if [ ! -z "$images" ]; then
        echo "Phát hiện image OpenClaw. Đang xóa..."
        sudo docker rmi -f $images 2>/dev/null
    fi
    echo "✓ Đã dọn dẹp Docker."
else
    echo "✓ Không tìm thấy Docker trên máy, bỏ qua."
fi

echo "=========================================="
echo "HOÀN TẤT! Đã gỡ bỏ sạch sẽ OpenClaw khỏi hệ thống."
echo "=========================================="
