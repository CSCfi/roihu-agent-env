#!/bin/bash

set -euo pipefail

TARGET_CONTAINERS=("opencode" "goose")
TARGET_VERSIONS=("1.17.0" "1.37.0")


# Parses if we are on roihu-cpu or roihu-gpu.
# TODO: Make this portable.
NODE_TYPE=$( hostname | cut -d "-" -f 2 )
if [[ $NODE_TYPE == "gpu" ]]; then
    BASE_IMAGE="satama.csc.fi/r_installation_spack/core-gpu-gcc-14.3.0-cuda-12.9.1@sha256:96f99061fb4d21360dc89c5d1269397f85a6ad86f09479f08e07ed27b7c98311"
else
    BASE_IMAGE="satama.csc.fi/r_installation_spack/core-cpu-gcc-15.2.0@sha256:e64b470bce6bd9786d4c4f195bdb0f7827bb441c6075d0824fd5842a3aca6fe5"
fi

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
OLD_DIR=$(pwd)
cd $SCRIPT_DIR

# Fetch the documentation subfolder from the csc-user-guide repo.
# First run does a sparse partial clone (only docs/); later runs fetch and
# reset to upstream, downloading just the changed objects.
DOCS_REPO="https://github.com/CSCfi/csc-user-guide.git"
DOCS_BRANCH="master"
DOCS_SUBFOLDER="docs"
DOCS_DIR="docs"

if [[ -d "$DOCS_DIR/.git" ]]; then
    git -C "$DOCS_DIR" fetch --depth 1 origin "$DOCS_BRANCH"
    git -C "$DOCS_DIR" reset --hard "origin/$DOCS_BRANCH"
else
    git clone --no-checkout --depth 1 --filter=blob:none --branch "$DOCS_BRANCH" \
        "$DOCS_REPO" "$DOCS_DIR"
    git -C "$DOCS_DIR" sparse-checkout set "$DOCS_SUBFOLDER"
    git -C "$DOCS_DIR" checkout
fi
# Remove all non md files and the .git directory, as that's how we check if the docs exist above.
find docs -type f -not \( -name '*.md' -o -name '.git' \) -delete

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
    apptainer build --fakeroot --fix-perms --writable-tmpfs --force --build-arg "APP_VERSION=$VERSION" --build-arg "BASE_IMAGE=$BASE_IMAGE" \
        images/${CONTAINER}-${NODE_TYPE}-${VERSION}.sif apptainer/${CONTAINER}.def
done
chgrp -R project_2001659 images
chgrp -R project_2001659 bin
cd $OLD_DIR