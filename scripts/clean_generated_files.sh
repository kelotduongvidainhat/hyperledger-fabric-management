#!/bin/bash

# Exit on first error
set -e

REPO_ROOT=$(dirname "$0")/..
NETWORK_DIR="${REPO_ROOT}/network"

echo "Stopping containers..."
if [ -f "${NETWORK_DIR}/docker-compose.yaml" ]; then
    docker compose -f "${NETWORK_DIR}/docker-compose.yaml" down -v --remove-orphans
fi

echo "Cleaning generated files..."

# Clean crypto-config
if [ -d "${NETWORK_DIR}/crypto-config" ]; then
    echo "Removing crypto-config..."
    rm -rf "${NETWORK_DIR}/crypto-config"
fi

# Clean channel-artifacts
if [ -d "${NETWORK_DIR}/channel-artifacts" ]; then
    echo "Removing channel-artifacts..."
    rm -rf "${NETWORK_DIR}/channel-artifacts"
fi

# Clean generated core.yaml if it exists
if [ -f "${NETWORK_DIR}/core.yaml" ]; then
    echo "Removing core.yaml..."
    rm -f "${NETWORK_DIR}/core.yaml"
fi

# Clean logs
rm -f "${NETWORK_DIR}/*.txt"
rm -f "${REPO_ROOT}/scripts/*.txt"

echo "Cleanup completed."
