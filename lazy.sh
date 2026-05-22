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
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install --update

echo "=== Cleaning up AWS installation files ==="
rm -rf aws awscliv2.zip

echo "=== Installing GitHub CLI (gh) ==="
sudo apt install -y gh

echo "=== Verifying Installations ==="
echo "AWS CLI version:" && aws --version
echo "Pulumi version:" && pulumi version
echo "GitHub CLI version:" && gh --version

echo "=== Script execution complete! ==="
echo "Please run 'source ~/.bashrc' or restart your terminal to use Pulumi."

echo "=== Installing PYENV ==="
sudo apt install -y make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
curl -fsSL https://pyenv.run | bash

cat <<EOF >> ~/.profile
export PYTHON_BUILD_CURL_OPTS="-k"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"
EOF

cat <<EOF >> ~/.bashrc
export PYTHON_BUILD_CURL_OPTS="-k"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
eval "$(pyenv virtualenv-init -)"
EOF

pyenv --version

cat <<EOF >> ~/.profile
export AWS_PROFILE=auth
export PULUMI_CONFIG_PASSPHRASE=""
export PULUMI_DIY_BACKEND_NO_LEGACY_WARNING=1
export PYTHON_BUILD_CURL_OPTS="-k"
EOF
