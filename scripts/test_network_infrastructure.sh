#!/bin/bash
set -e

echo "=== STARTING NETWORK INFRASTRUCTURE TEST ==="
echo "This script will:"
echo "1. Generate all cryptographic material and network artifacts"
echo "2. Start the Fabric network (Peers, Orderer, CA)"
echo "3. Create a channel 'mychannel'"
echo "4. Join all peers to the channel"
echo "5. Update anchor peers"

# Make sure scripts are executable
chmod +x scripts/start_network.sh
chmod +x scripts/create_channel.sh

# 1 & 2. Start Network (Crypto + Docker)
./scripts/start_network.sh

# 3, 4, 5. Create Channel and Join Peers
# We execute this inside the CLI container because it has all the MSP config paths set up for internal network access
echo "Execing into CLI container to create and join channel..."
docker exec cli ./scripts/create_channel.sh

echo "=== NETWORK INFRASTRUCTURE TEST COMPLETE ==="
echo "If you see 'Network execution completed successfully' above, the infrastructure is working."
