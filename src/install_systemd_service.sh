#!/bin/sh

DIR=$(dirname "$0")
BASE_DIR=$(readlink -f $DIR)

SVC_TXT="
[Unit]
Description=M-TEC MQTT service 
After=multi-user.target

[Service]
Type=simple
User=USER
WorkingDirectory=BASE_DIR
ExecStart=BASE_DIR/python3 mtec_mqtt2
Restart=always

[Install]
WantedBy=multi-user.target
"

echo "MTECmqtt: Installing systemd service to auto-start mtec_mqtt"

if [ $(id -u) != "0" ]; then
  echo "This script required root rights. Please restart using 'sudo'"
else
  echo "$SVC_TXT" | sed "s!BASE_DIR!$BASE_DIR!g" | sed "s/USER/$SUDO_USER/g" > /tmp/mtec_mqtt2.service 
  chmod 666 /tmp/mtec_mqtt2.service
  mv /tmp/mtec_mqtt2.service /etc/systemd/system
  systemctl daemon-reload
  systemctl enable mtec_mqtt2.service
  systemctl start mtec_mqtt2.service
  echo "==> systemd service '/etc/systemd/system/mtec_mqtt2.service' installed"
fi

