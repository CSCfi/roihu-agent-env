#!/bin/bash

set -e

TARGET_CONTAINERS=("opencode" "goose")
TARGET_VERSIONS=("1.17.0" "1.37.0")


# Parses if we are on roihu-cpu or roihu-gpu.
# TODO: Make this portable.
NODE_TYPE=$( hostname | cut -d "-" -f 2 )

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

# Build socket bridge binary
# cd socket-bridge
# CGO_ENABLED=0 go build -o socket-bridge .
# cd ..

# # Clone and build Slurm MCP-server
# rm -rf slurm-mcp
# git clone --depth 1 --branch main https://gitlab.ci.csc.fi/compen/hpc-environment/slurm-mcp.git
# cd slurm-mcp
# CGO_ENABLED=0 go build -o ../slurm-mcp-bin
# cd ..
# rm -rf slurm-mcp

mkdir -p images

# Loop over list length
for (( i=0; i<${#TARGET_CONTAINERS[@]}; i++ )); do
    CONTAINER=${TARGET_CONTAINERS[i]}
    VERSION=${TARGET_VERSIONS[i]}
    apptainer build --fakeroot --fix-perms --writable-tmpfs --force --build-arg "APP_VERSION=$VERSION" \
        images/${CONTAINER}-${NODE_TYPE}-${VERSION}.sif apptainer/${CONTAINER}.def
done