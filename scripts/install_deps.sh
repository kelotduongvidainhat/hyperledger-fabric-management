#!/bin/bash
set -e

echo "Updating apt..."
sudo apt-get update

echo "Installing jq..."
sudo apt-get install -y jq

echo "Installing Go..."
sudo apt-get install -y golang-go

echo "Installing NVM..."
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
    echo "NVM already installed."
fi

# Load NVM for this session
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Installing Node.js v18..."
nvm install 18
nvm use 18
nvm alias default 18

echo "Verifying installations..."
echo "JQ: $(jq --version)"
echo "Go: $(go version)"
echo "Node: $(node --version)"
echo "NPM: $(npm --version)"

echo "Installation complete! Please restart your terminal or run 'source ~/.bashrc' to ensure nvm is available in your shell."
