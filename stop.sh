#!/bin/bash

# Exit on first error, print all commands.
set -ev

# Shut down the Docker containers that might be currently running.
COMPOSE_PROJECT_NAME=peersolo docker-compose -f docker-compose.yml stop
COMPOSE_PROJECT_NAME=peersolo docker-compose -f docker-compose.yml down

# remove the local state
rm -f ~/.hfc-key-store/*

# remove chaincode docker images
docker rmi -f $(docker images dev-* -q)

# Your system is now clean
