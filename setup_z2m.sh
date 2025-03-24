#!/bin/bash
set -e

# Display IP before starting
IP=$(hostname -I | awk '{print $1}')
echo "========================================"
echo " Raspberry Pi IP: $IP"
echo " You'll access Zigbee2MQTT via this IP"
echo "========================================"

# Install dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git make g++ gcc mosquitto mosquitto-clients

# Install Node.js 20.x and npm
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install pnpm globally
sudo npm install -g pnpm

# Create directory and set permissions
sudo mkdir -p /opt/zigbee2mqtt
sudo chown -R $(whoami):$(whoami) /opt/zigbee2mqtt

# Clone Zigbee2MQTT
git clone https://github.com/Koenkk/zigbee2mqtt.git /opt/zigbee2mqtt

# Install dependencies
cd /opt/zigbee2mqtt
pnpm install

# Create default configuration
cat <<EOT > /opt/zigbee2mqtt/data/configuration.yaml
homeassistant: false
permit_join: true
mqtt:
  base_topic: zigbee2mqtt
  server: mqtt://localhost:1883
serial:
  port: /dev/ttyUSB0
  adapter: zstack
frontend:
  port: 8080
  host: 0.0.0.0
advanced:
  network_key: GENERATE
EOT

# Create systemd service
sudo tee /etc/systemd/system/zigbee2mqtt.service > /dev/null <<EOT
[Unit]
Description=Zigbee2MQTT
After=network.target

[Service]
ExecStart=/usr/bin/pnpm start
WorkingDirectory=/opt/zigbee2mqtt
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$(whoami)

[Install]
WantedBy=multi-user.target
EOT

# Enable services
sudo systemctl daemon-reload
sudo systemctl enable zigbee2mqtt
sudo systemctl start zigbee2mqtt
sudo systemctl enable mosquitto
sudo systemctl start mosquitto

# Fix permissions
sudo usermod -aG dialout $(whoami)

echo "========================================"
echo " Setup complete!"
echo " Access the Zigbee2MQTT web interface:"
echo " http://$IP:8080"
echo "========================================"

# Reminder to reboot
echo "You should reboot your Raspberry Pi to ensure all changes take effect:"
echo "sudo reboot"