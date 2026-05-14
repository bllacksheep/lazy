#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Updating system packages ==="
sudo apt update && sudo apt upgrade -y

echo "=== Installing system dependencies ==="
sudo apt install -y unzip curl

echo "=== Setting up workspace directories ==="
mkdir -p "$HOME/dev/old"
cd "$HOME/dev"

echo "=== Installing Pulumi ==="
curl -fsSL https://get.pulumi.com | sh
# Add Pulumi to the current shell path so it works immediately
export PATH=$PATH:$HOME/.pulumi/bin

echo "=== Downloading and Installing AWS CLI v2 ==="
curl "amazonaws.com" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install --update

echo "=== Cleaning up AWS installation files ==="
mv aws awscliv2.zip old/

echo "=== Installing GitHub CLI (gh) ==="
sudo apt install -y gh

echo "=== Verifying Installations ==="
echo "AWS CLI version:" && aws --version
echo "Pulumi version:" && pulumi version
echo "GitHub CLI version:" && gh --version

echo "=== Script execution complete! ==="
echo "Please run 'source ~/.bashrc' or restart your terminal to use Pulumi."

