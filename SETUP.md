# Environment Setup Guide

This project requires the following dependencies:
- **Git**
- **Curl**
- **Docker** & **Docker Compose**
- **Go** (v1.20+)
- **Node.js** (v18+)
- **jq**
- **Hyperledger Fabric** (v2.5) & **Fabric CA** (v1.5)

## Automatic Setup
We have provided scripts to automate the installation of dependencies.

### 1. Install System Dependencies
Installs Go, Node.js, jq, and NVM.
```bash
./scripts/install_deps.sh
source ~/.bashrc
```

### 2. Install Hyperledger Fabric
Downloads Fabric binaries (peer, orderer, etc.) and Docker images.
```bash
# This is usually done manually via the official script, 
# but we can provide a helper if needed.
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh
./install-fabric.sh --fabric-version 2.5.9 --ca-version 1.5.12 binary docker
```
*Note: The project is tested with Fabric v2.5.9 and Fabric CA v1.5.12.*

## Manual Verification
After setup, verify your environment:

```bash
# System
git --version
docker --version
docker compose version
go version
jq --version
node --version
npm --version

# Fabric (ensure bin/ is in PATH)
export PATH=$PWD/bin:$PATH
peer version
orderer version
fabric-ca-client version
docker images | grep hyperledger
```
