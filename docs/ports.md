# Port Allocation Guide

This document defines the port mapping for the Hyperledger Fabric network and associated applications.

## Hyperledger Fabric Network
These ports are defined in `network/docker-compose.yaml`.

| Component | Container Name | Port | Description |
|-----------|----------------|------|-------------|
| **Orderer** | `orderer.example.com` | `7050` | Orderer service port |
| **Fabric CA** | `ca.org1.example.com` | `7054` | CA Server port |
| **Peer 0** | `peer0.org1.example.com` | `7051` | Peer gRPC/Events |
| **Peer 1** | `peer1.org1.example.com` | `8051` | Peer gRPC/Events |
| **Peer 2** | `peer2.org1.example.com` | `9051` | Peer gRPC/Events |

> **Note**: Chaincode listen ports are configured internally as `7052`, `8052`, and `9052` but are typically not exposed to the host machine unless needed for chaincode debugging.

## Application Layer (Future)
Proposed ports for the application components to be developed.

| Component | Default Port | Description |
|-----------|--------------|-------------|
| **PostgreSQL** | `5432` | Primary Database |
| **API Gateway** | `4000` | Interface between App and Fabric Network |
| **Backend API** | `4200` | General business logic and management API |
| **Frontend** | `3000` | Web Application (React/Next.js/Vite) |

## Tools & Monitoring (Optional)
| Component | Default Port | Description |
|-----------|--------------|-------------|
| **CouchDB** | `5984` | If Side-DB is enabled (Per Peer: 5984, 6984, 7984) |
| **Explorer** | `8080` | Hyperledger Explorer (if deployed) |
