# Daily Log - Session 2

## Current Status
- **Network**: Up and running (Orderer, 3 Peers, CA, CLI).
- **Channel**: `mychannel` created, all 3 peers joined, anchor peers updated.
- **Documentation**: Updated `README.md` with Project Structure.
- **Scripts**: Created `clean_generated_files.sh` and `setup.sh`.

## Issues Encountered
### Chaincode Deployment Failure
- **Error**: `write unix @->/var/run/docker.sock: write: broken pipe` during `peer lifecycle chaincode install`.
- **Cause**: The Peer container fails to communicate with the host Docker daemon during the chaincode build process (likely during `go mod download` or image build).
- **Attempts**:
    1.  Vendoring `go mod vendor` -> Failed (same error).
    2.  Removing `vendor` folder -> Failed.
    3.  Restarting network -> Failed.
    4.  Cleaning artifacts -> Failed.

## Plan
1.  **Modify Docker Compose**: Add `GOPROXY=https://proxy.golang.org` to Peer environments to ensure stable dependency fetching during build.
2.  **Retry Deployment**: Clean and redeploy.
