#!/bin/sh

# Đường dẫn file config
config_file="/usr/share/nginx/html/env-config.js"

# Bắt đầu file JS
echo "window._env_ = {" > $config_file

# Lặp qua các biến môi trường bắt đầu bằng VITE_
env | grep "^VITE_" | while read -r line; do
  # Tách key và value
  key=$(echo "$line" | cut -d '=' -f 1)
  value=$(echo "$line" | cut -d '=' -f 2-)
  
  # Ghi vào file (ví dụ: VITE_API_URL: "https://...",)
  echo "  $key: \"$value\"," >> $config_file
done

# Đóng ngoặc
echo "}" >> $config_file

echo "Successfully created env-config.js"