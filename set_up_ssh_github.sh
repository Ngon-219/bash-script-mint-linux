#!/bin/bash

# 1️⃣ Xóa tất cả SSH key cũ
echo "Xóa tất cả SSH key cũ..."
rm -rf ~/.ssh/*
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# 2️⃣ Tạo SSH key cá nhân
echo "Tạo SSH key cá nhân..."
ssh-keygen -t ed25519 -C "vucongngon219@gmail.com" -f ~/.ssh/id_ed25519 -N ""

# 3️⃣ Tạo SSH key công ty
echo "Tạo SSH key công ty..."
ssh-keygen -t ed25519 -C "ngon.vu@sotatek.com" -f ~/.ssh/id_ed25519_company -N ""

# 4️⃣ Khởi động ssh-agent và add key
echo "Khởi động ssh-agent và add key..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519_company

# 5️⃣ Tạo file config
echo "Tạo file ~/.ssh/config..."
cat > ~/.ssh/config <<EOL
# Cá nhân
Host github.com-personal
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519

# Công ty
Host github.com-work
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_company
EOL
chmod 600 ~/.ssh/config

# 6️⃣ Hiển thị public key để thêm vào GitHub
echo "Public key cá nhân (thêm vào GitHub cá nhân):"
cat ~/.ssh/id_ed25519.pub
echo ""
echo "Public key công ty (thêm vào GitHub công ty):"
cat ~/.ssh/id_ed25519_company.pub

# 7️⃣ Test kết nối
echo ""
echo "Test SSH GitHub cá nhân:"
ssh -T git@github.com-personal
echo ""
echo "Test SSH GitHub công ty:"
ssh -T git@github.com-work

