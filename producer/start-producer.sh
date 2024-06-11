#!/bin/bash

# set image and container names
IMAGE_NAME="kafka-producer"
CONTAINER_NAME="kafka-producer-container"

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

if [[ "$FORCE_REBUILD" = true ]]; then
    echo "Force Rebuild option has been set"
fi

if [[ "$FORCE_RESTART" = true ]]; then
    echo "Force Restart option has been set"
fi

# Check if the Docker image already exists
if [[ "$(docker images -q $IMAGE_NAME 2> /dev/null)" == "" ]]; then
    echo "Docker image does not exist, building it..."
    docker build -t $IMAGE_NAME .
elif [[ "$FORCE_REBUILD" = true ]]; then
    echo "Docker image already exists, but force rebuild is requested. Removing and building it again..."
    # Stop the existing container, if any
    if [[ "$(docker ps -q -f name=$CONTAINER_NAME 2> /dev/null)" != "" ]]; then
        docker stop $CONTAINER_NAME
    fi
    # Remove the existing container, if any
    if [[ "$(docker ps -qa -f name=$CONTAINER_NAME 2> /dev/null)" != "" ]]; then
        docker rm $CONTAINER_NAME
    fi
    # Remove the existing image
    docker rmi $IMAGE_NAME
    docker build -t $IMAGE_NAME .
else
    echo "Docker image already exists. Skipping build."
fi
# Check if there already is a container with the same name, and in case delete it
if [[ "$(docker ps -qa -f name=$CONTAINER_NAME 2> /dev/null)" != "" ]]; then 
    echo "A container is already present with the same name..deleting it"
    docker rm $CONTAINER_NAME
fi
# Check if the container is already running or force restart is requested
if [[ "$(docker ps -q -f name=$CONTAINER_NAME 2> /dev/null)" == "" ]]; then 
    echo "Container is not running. Starting it..."
    docker run -d --name $CONTAINER_NAME $IMAGE_NAME
elif [[ "$FORCE_RESTART" = true ]]; then  
    echo "Force restart is requested. Going to restart it..."
    docker restart $CONTAINER_NAME
else 
    echo "Container is already running..."
fi
