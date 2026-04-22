#!/bin/sh

config_file="/usr/share/nginx/html/env-config.js"

echo "window._env_ = {" > $config_file

env | grep "^VITE_" | while read -r line; do
  key=$(echo "$line" | cut -d '=' -f 1)
  value=$(echo "$line" | cut -d '=' -f 2-)
  
  echo "  $key: \"$value\"," >> $config_file
done

echo "}" >> $config_file

echo "Successfully created env-config.js"