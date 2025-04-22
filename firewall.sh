#!/bin/bash

# List of ports
PORTS=(22 123 139 445 514 631)

echo "Adding UFW rules for TCP and UDP on ports: ${PORTS[*]}"

# Add rules
for port in "${PORTS[@]}"; do
    sudo ufw allow ${port}/tcp
    sudo ufw allow ${port}/udp
done

# Enable and reload UFW
echo "Enabling and reloading UFW..."
sudo ufw enable
sudo ufw reload

echo "UFW configuration complete."
