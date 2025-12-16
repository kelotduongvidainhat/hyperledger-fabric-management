#!/bin/bash

# Exit on first error
set -e

# Versions
FABRIC_VERSION="2.5.4"
CA_VERSION="1.5.7"

echo "Checking Prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed."
    exit 1
fi
DOCKER_VER=$(docker --version)
echo "Found Docker: $DOCKER_VER"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Warning: docker-compose not found (checking 'docker compose')."
    if ! docker compose version &> /dev/null; then
         echo "Error: docker-compose or 'docker compose' in not installed."
         exit 1
    fi
fi
echo "Found Docker Compose"

# Check Go
if ! command -v go &> /dev/null; then
    echo "Error: go is not installed."
    # echo "Attempting to install Go..."
    # sudo snap install go --classic
    exit 1
fi
GO_VER=$(go version)
echo "Found Go: $GO_VER"

# Check Node
if ! command -v node &> /dev/null; then
    echo "Error: node is not installed."
    exit 1
fi
NODE_VER=$(node --version)
echo "Found Node: $NODE_VER"

echo "---------------------------------"
echo "Checking Hyperledger Fabric Images..."

# Function to pull image if missing
check_and_pull() {
    IMAGE=$1
    echo "Checking $IMAGE..."
    if [[ "$(docker images -q $IMAGE 2> /dev/null)" == "" ]]; then
        echo "Image $IMAGE not found. Pulling..."
        docker pull $IMAGE
    else
        echo "Image $IMAGE exists."
    fi
}

check_and_pull "hyperledger/fabric-tools:2.5"
check_and_pull "hyperledger/fabric-peer:2.5"
check_and_pull "hyperledger/fabric-orderer:2.5"
check_and_pull "hyperledger/fabric-ccenv:2.5"
check_and_pull "hyperledger/fabric-baseos:2.5"
check_and_pull "hyperledger/fabric-ca:1.5"

echo "---------------------------------"
echo "Setup completed successfully."
