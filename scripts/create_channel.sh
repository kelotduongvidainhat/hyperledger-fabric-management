#!/bin/bash

CHANNEL_NAME="mychannel"
DELAY="3"
MAX_RETRY="5"
VERBOSE="false"

# Environment variables for Peer0
export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export FABRIC_CFG_PATH=/etc/hyperledger/fabric/

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

createChannel() {
  setGlobals 0
  if [ -z "$CORE_PEER_TLS_ENABLED" -o "$CORE_PEER_TLS_ENABLED" = "false" ]; then
                set -x
    peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx >&log.txt
    res=$?
                set +x
  else
    set -x
    peer channel create -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
    res=$?
    set +x
  fi
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Channel creation failed"
    exit 1
  fi
  echo "Channel '$CHANNEL_NAME' created"
}

joinChannel() {
  PEER=$1
  setGlobals $PEER
  peer channel join -b $CHANNEL_NAME.block >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Peer$PEER failed to join channel"
    exit 1
  fi
  echo "Peer$PEER joined channel '$CHANNEL_NAME'"
}

updateAnchorPeers() {
  PEER=$1
  setGlobals $PEER
  peer channel update -o orderer.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA >&log.txt
  res=$?
  cat log.txt
  if [ $res -ne 0 ]; then
    echo "Anchor peer update failed"
    exit 1
  fi
  echo "Anchor peers updated for Org1MSP on Peer$PEER"
}

## Create Channel
echo "Creating channel..."
createChannel

## Join Peers
echo "Joining peers..."
joinChannel 0
joinChannel 1
joinChannel 2

## Update Anchor Peers
echo "Updating anchor peers..."
updateAnchorPeers 0

echo "Network execution completed successfully"
exit 0
