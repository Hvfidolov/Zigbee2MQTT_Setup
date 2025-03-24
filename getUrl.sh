# Display IP
IP=$(hostname -I | awk '{print $1}')
echo "========================================"
echo " Raspberry Pi IP: $IP"
echo " You'll access Zigbee2MQTT via this IP"
echo "========================================"