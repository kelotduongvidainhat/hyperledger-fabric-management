# Network Setup Guide

This document guides you through the process of setting up the Hyperledger Fabric network for this project.

## Network Topology
- **Organization**: Org1
- **Domain**: example.com
- **Peers**: 3 Peers (peer0, peer1, peer2)
- **Orderer**: 1 Orderer (Raft consensus)
- **CA**: 1 Fabric CA Server

## Configuration Files

The network configuration is located in the `network/` directory:

1.  **`crypto-config.yaml`**: Defines the identity structure for the organization, peers, and orderers. It is used by `cryptogen` to generate certificates.
2.  **`configtx.yaml`**: Defines the channel configuration, policies, and profiles. It is used by `configtxgen` to create the genesis block.
3.  **`docker-compose.yaml`**: Defines the Docker containers for the peers, orderer, and CA.

## Step-by-Step Setup

### 1. Generate Crypto Material
Use `cryptogen` to generate the certificates and keys for the network entities based on `crypto-config.yaml`.

```bash
cryptogen generate --config=./network/crypto-config.yaml --output=./network/crypto-config
```

### 2. Generate Genesis Block
Use `configtxgen` to generate the genesis block for the system channel (if applicable) or the application channel.

```bash
export FABRIC_CFG_PATH=./network
configtxgen -profile TwoOrgsOrdererGenesis -channelID system-channel -outputBlock ./network/genesis.block
```

### 3. Start the Network
Use Docker Compose to start the containers.

```bash
docker compose -f ./network/docker-compose.yaml up -d
```

### 4. Create and Join Channel
(Instructions specific to your scripts will happen here, e.g., `scripts/create_channel.sh`)

1.  Create the channel transaction.
2.  Submit the channel create transaction.
3.  Join peers to the channel.

## Helper Scripts
We have provided helper scripts in the `scripts/` directory to automate these tasks:

*   `setup.sh`: Orchestrates the entire setup (crypto generation, network start, channel creation).
*   `clean_generated_files.sh`: Removes generated artifacts (crypto-config, blocks) and spins down containers.

## Troubleshooting
*   **Certificate Errors**: Ensure `cryptogen` ran successfully and paths in `docker-compose.yaml` match the generated keys.
*   **Port Conflicts**: Ensure ports 7051, 7054, etc., are not in use.
