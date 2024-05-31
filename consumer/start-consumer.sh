#!/bin/bash

# set image and container names
IMAGE_NAME="kafka-consumer"
CONTAINER_NAME="kafka-consumer-container"

FORCE_REBUILD=false
FORCE_RESTART=false

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --force-rebuild)
      FORCE_REBUILD=true
      shift # past argument
      ;;
    --force-restart)
      FORCE_RESTART=true
      shift # past argument
      ;;
    *)
      shift # past unrecognized argument
      ;;
  esac
done

# Check if the Docker image already exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" && "$FORCE_REBUILD" = true ]]; then
    echo "Building the Docker image..."
    docker build -t $IMAGE_NAME .
else
    echo "Docker image already exists. Skipping build."
fi

# Check if the container is already running or force restart is requested
if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]] && [[ "$FORCE_RESTART" = true ]]; then
      echo "Container is already running. Restarting it..."
      docker restart $CONTAINER_NAME
else if [[ "$(docker ps -q -f name=$CONTAINER_NAME)" ]]; then
    echo "Container is already running. Skipping..."
else 
    echo "Starting the container..."
fi
