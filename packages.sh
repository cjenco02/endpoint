#!/bin/bash

# Exit on any error
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

echo "Installing Curl..."
sudo apt install curl

echo "Installing iputils..."
sudo apt install iputils*

echo "Creating local admin user 'boss'..."
# Create the user and set the password
sudo useradd -m -s /bin/bash boss
echo "boss:AdminThisServer!" | sudo chpasswd

# Add the user to the sudo group
sudo usermod -aG sudo boss

echo "User 'boss' created and added to sudo group."

echo "All packages installed and user configured successfully."
