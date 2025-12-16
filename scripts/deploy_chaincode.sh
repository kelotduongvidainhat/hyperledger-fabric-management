#!/bin/bash

# Environment variables
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export FABRIC_CFG_PATH=/etc/hyperledger/fabric/

CHANNEL_NAME="mychannel"
CC_NAME="basic"
CC_SRC_PATH="/opt/gopath/src/github.com/chaincode/asset-transfer"
CC_VERSION="1.0"
CC_SEQUENCE="1"


setGlobals() {
  PEER=$1
  if [ $PEER -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=peer0.org1.example.com:7051
  elif [ $PEER -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=peer1.org1.example.com:8051
  elif [ $PEER -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    export CORE_PEER_ADDRESS=peer2.org1.example.com:9051
  fi
}

packageChaincode() {
  echo "Packaging chaincode..."
  setGlobals 0
  peer lifecycle chaincode package ${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang golang --label ${CC_NAME}_${CC_VERSION} >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Chaincode packaging failed"
    exit 1
  fi
  echo "Chaincode packaged"
}

installChaincode() {
  PEER=$1
  echo "Installing chaincode on peer${PEER}..."
  setGlobals $PEER
  peer lifecycle chaincode install ${CC_NAME}.tar.gz >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Chaincode installation on peer${PEER} failed"
    exit 1
  fi
  echo "Chaincode installed on peer${PEER}"
}

approveForMyOrg() {
  echo "Approving chaincode definition..."
  setGlobals 0
  # Get package ID
  PACKAGE_ID=$(peer lifecycle chaincode queryinstalled | grep ${CC_NAME}_${CC_VERSION} | awk '{print $3}' | sed 's/,//')
  echo "Package ID: ${PACKAGE_ID}"

  peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --package-id ${PACKAGE_ID} --sequence ${CC_SEQUENCE} --init-required >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Chaincode approval failed"
    exit 1
  fi
  echo "Chaincode approved"
}

checkCommitReadiness() {
  echo "Checking commit readiness..."
  setGlobals 0
  peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME --name ${CC_NAME} --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --output json --init-required >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Commit readiness check failed"
    exit 1
  fi
  echo "Commit readiness check passed"
}

commitChaincodeDefinition() {
  echo "Committing chaincode definition..."
  setGlobals 0
  peer lifecycle chaincode commit -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name ${CC_NAME} --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --version ${CC_VERSION} --sequence ${CC_SEQUENCE} --init-required >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Chaincode commit failed"
    exit 1
  fi
  echo "Chaincode committed"
}

initChaincode() {
  echo "Initializing chaincode..."
  setGlobals 0
  peer chaincode invoke -o orderer.example.com:7050 --ordererTLSHostnameOverride orderer.example.com --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} --peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles $PEER0_ORG1_CA --isInit -c '{"function":"InitLedger","Args":[]}' >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Chaincode initialization failed"
    exit 1
  fi
  echo "Chaincode initialized"
}

## Run Lifecycle
packageChaincode
installChaincode 0
installChaincode 1
installChaincode 2
approveForMyOrg
checkCommitReadiness
commitChaincodeDefinition
initChaincode

echo "Chaincode deployment completed successfully"
exit 0
