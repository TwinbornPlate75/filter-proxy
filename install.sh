#!/bin/bash

set -e

INSTALL_DIR="/opt/filter-proxy"
SYSTEMD_DIR="/etc/systemd/system"

echo "Installing filter-proxy to $INSTALL_DIR..."

sudo mkdir -p "$INSTALL_DIR"

cp server.py "$INSTALL_DIR/"
cp config.json.example "$INSTALL_DIR/config.json.example"

if [ -f "config.json" ]; then
    cp config.json "$INSTALL_DIR/"
fi

SERVICE_CONTENT="[Unit]
Description=Filter Proxy Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/python3 $INSTALL_DIR/server.py
Restart=on-failure
RestartSec=5
Environment=PYTHONPATH=$INSTALL_DIR

[Install]
WantedBy=multi-user.target
"

echo "$SERVICE_CONTENT" | sudo tee "$SYSTEMD_DIR/filter-proxy.service" > /dev/null

sudo systemctl daemon-reload
sudo systemctl enable filter-proxy

echo "Installation complete!"
echo "Start with: sudo systemctl start filter-proxy"
echo "Config file: $INSTALL_DIR/config.json"
