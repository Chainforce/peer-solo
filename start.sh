#!/bin/bash

# exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

export COMPOSE_PROJECT_NAME=peersolo

COMPOSE_PROJECT_NAME=peersolo docker-compose -f docker-compose.yml down

COMPOSE_PROJECT_NAME=peersolo docker-compose -f docker-compose.yml up -d orderer.solo.com peer0.org1.solo.com cli

# wait for Fabric network to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
echo "Waiting "${FABRIC_START_TIMEOUT}" seconds for network to start then create 'mychannel'"
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.solo.com/msp" peer0.org1.solo.com peer channel create -o orderer.solo.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
# Join peer0.org1.solo.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.solo.com/msp" peer0.org1.solo.com peer channel join -b mychannel.block

# deploy chaincode here if necessary; otherwise use the cli container to deploy and run
echo "Deploying chaincode_example02..."
docker exec cli peer chaincode install -n mycc -v 1.0 -p github.com/example02/
docker exec cli peer chaincode instantiate -o orderer.solo.com:7050 -C mychannel -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'
# to enter cli container: docker start cli && docker exec -it cli bash