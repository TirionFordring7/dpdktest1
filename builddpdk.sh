#!/bin/bash
set -e
echo "Настройка Meson..."
cd dpdk-24.07
meson setup build
cd build 
ninja 
meson install 
sudo ldconfig