#!/bin/bash
set -e

# Export binaries to path
export PATH=${PWD}/../bin:${PWD}/bin:$PATH
export FABRIC_CFG_PATH=${PWD}/network

# Cleanup
echo "Cleaning up old artifacts..."
rm -rf network/crypto-config
rm -rf network/channel-artifacts
rm -rf network/genesis.block
mkdir -p network/channel-artifacts

# Generate Crypto
echo "Generating crypto material..."
cryptogen generate --config=./network/crypto-config.yaml --output=./network/crypto-config

# Generate Genesis Block
echo "Generating genesis block..."
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./network/channel-artifacts/genesis.block

# Generate Channel Tx
echo "Generating channel configuration transaction..."
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./network/channel-artifacts/channel.tx -channelID mychannel

# Generate Anchor Peers Tx
echo "Generating anchor peer update for Org1MSP..."
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./network/channel-artifacts/Org1MSPanchors.tx -channelID mychannel -asOrg Org1MSP

echo "Crypto and artifacts generated successfully."

# Start Network
echo "Starting network containers..."
docker compose -f network/docker-compose.yaml up -d

echo "Waiting for network to stabilize (10s)..."
sleep 10

echo "Network started."
