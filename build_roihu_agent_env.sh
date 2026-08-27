#!/bin/bash

set -euo pipefail
set -x

agent_env_version=$( date +'%y.%m.%d' )
container="roihu-agent-env"

#
# Versions to install. Change this as necessary.
#
# Opencode options: <version>, "latest"
# Claude options: <version>, "latest", "stable"
# Codex options: <version>, "latest"
#
opencode_version="latest"
claude_version="stable"
codex_version="latest"


script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
old_dir=$(pwd)
cd $script_dir


create_agent_env_module () {
    # Create a module file from template.
    #
    # Currently only designed for roihu-agent-env, and only replaces 
    # __AGENT_IMAGE_NAME__ with the actual name.
    #
    # Usage:
    # create_agent_env_module IMAGE_NAME IMAGE_VERSION
    #

    image_name="$1"
    image_version="$2"

    arch=$( arch )
    if [[ $arch == "aarch64" ]]; then
        node_type="gpu"
    elif [[ $arch == "x86_64" ]]; then
        node_type="cpu"
    else
        echo "Parsing of the processor architecture failed"
        exit 1
    fi
    MODULE_DIR="/appl/modulefiles/manual/general/${arch}/.roihu-agent-env"
    sed "s/__AGENT_IMAGE_NAME__/${image_name}/" modulefiles/roihu/${node_type}/module_template \
        > ${MODULE_DIR}/${image_version}.lua

    # Set the new module as default
    rm -f ${MODULE_DIR}/default
    ln -s $( realpath ${MODULE_DIR}/${image_version}.lua ) \
        ${MODULE_DIR}/default
}


# Parses if we are on roihu-cpu or roihu-gpu.
node_arch=$( arch )
if [[ $node_arch == "aarch64" ]]; then
    base_image="satama.csc.fi/r_installation_spack/core-gpu-gcc-14.3.0-cuda-12.9.1@sha256:96f99061fb4d21360dc89c5d1269397f85a6ad86f09479f08e07ed27b7c98311"
    socket_bridge_file="socket-bridge-aarch64"
elif [[ $node_arch == "x86_64" ]]; then
    base_image="satama.csc.fi/r_installation_spack/core-cpu-gcc-15.2.0@sha256:e64b470bce6bd9786d4c4f195bdb0f7827bb441c6075d0824fd5842a3aca6fe5"
    socket_bridge_file="socket-bridge-x86_64"
else
    echo "Parsing of the processor architecture failed"
    exit 1
fi


# Build socket bridge binary
# Only needs to be done once.
# cd socket-bridge
# CGO_ENABLED=0 go build -o socket-bridge .
# cd ..


mkdir -p images


# Update the job-monitoring-sdk:
rm -rf job-monitoring-sdk
git clone --depth 1 -b main ssh://git@gitlab.ci.csc.fi:10022/compen/job-monitoring/job-monitoring-sdk.git || { echo "git clone failed. Make sure you are on roihu-install node."; exit 1; }


# Build the container
container_name=${container}-${node_arch}-${agent_env_version}.sif
apptainer build --fakeroot --fix-perms --writable-tmpfs --force \
    --build-arg "OPENCODE_VERSION=$opencode_version" \
    --build-arg "CLAUDE_VERSION=$claude_version" \
    --build-arg "CODEX_VERSION=$codex_version" \
    --build-arg "BASE_IMAGE=$base_image" \
    --build-arg "SOCKET_BRIDGE_FILE=$socket_bridge_file" \
    images/$container_name apptainer/${container}.def

# Generate modulefile
create_agent_env_module $container_name $agent_env_version

# Fix permissions
chgrp -R project_2001659 images
chgrp -R project_2001659 bin
cd $old_dir
