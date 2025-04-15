#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Updating package list..."
sudo apt update

echo "Installing rsyslog..."
sudo apt install -y rsyslog

echo "Installing NTP (chrony)..."
sudo apt install -y chrony

echo "Installing packages needed to join an AD domain..."
sudo apt install -y realmd sssd sssd-tools libnss-sss libpam-sss adcli samba-common-bin oddjob oddjob-mkhomedir packagekit

echo "Installing apt-offline..."
sudo apt install -y apt-offline

echo "Installing IDS (Snort)..."
sudo apt install -y snort

echo "All packages installed successfully."

# Optional: Enable and start services (uncomment if desired)
# echo "Enabling and starting rsyslog and chrony..."
# sudo systemctl enable --now rsyslog
# sudo systemctl enable --now chrony
# sudo systemctl enable --now snort

echo "Script completed."
