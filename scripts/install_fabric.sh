#!/bin/bash
set -e

# Versions
FABRIC_VERSION="2.5.9"
CA_VERSION="1.5.12"

echo "Installing Hyperledger Fabric v${FABRIC_VERSION} and Fabric CA v${CA_VERSION}..."

# Download the install script
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh

# Run the install script
# We only need binaries and docker images. We don't need the samples (which are huge and cluttered).
./install-fabric.sh --fabric-version ${FABRIC_VERSION} --ca-version ${CA_VERSION} binary docker

echo "Cleaning up..."
rm install-fabric.sh

echo "Verifying installation..."
if [ -d "bin" ]; then
    export PATH=$PWD/bin:$PATH
    peer version
    orderer version
    fabric-ca-client version
else
    echo "Error: bin directory not found!"
    exit 1
fi

echo "Fabric installation complete."
