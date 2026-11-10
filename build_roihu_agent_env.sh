#!/bin/bash

set -euo pipefail
set -x

#
# Parse arguments. Currently unused
#
#positional_args=() # Unused for now. Keeping the logic for the future
#while [[ $# -gt 0 ]]; do
#  case $1 in
#    -*|--*)
#      echo "Unknown option $1"
#      exit 1
#      ;;
#    *)
#      positional_args+=("$1") # save positional arg
#      shift # past argument
#      ;;
#  esac
#done
#set -- "${positional_args[@]}" # restore positional parameters


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
    MODULE_DIR="/appl/modulefiles/manual/general/$( arch )/roihu-agent-env"
    sed "s/__AGENT_IMAGE_NAME__/${image_name}/" ${MODULE_DIR}/module_template \
        > ${MODULE_DIR}/${image_version}.lua

    # Set the new module as default
    rm -f ${MODULE_DIR}/default
    ln -s $( realpath ${MODULE_DIR}/${image_version}.lua ) \
        ${MODULE_DIR}/default
}


# Parses if we are on roihu-cpu or roihu-gpu.
node_arch=$( arch )
if [[ $node_arch == "aarch64" ]]; then
    socket_bridge_file="socket-bridge-aarch64"
    base_image_commit="sha256:e37af8973775b7eadc963370a0028f5f7762e4e48deb7e96b2cc7d6f81f9c71c"
    base_image="satama.csc.fi/r_installation_spack/core-gpu-deps@${base_image_commit}"
elif [[ $node_arch == "x86_64" ]]; then
    socket_bridge_file="socket-bridge-x86_64"
    base_image_commit="sha256:96b63b2796e0cd8131cd0b8052684e9514f41fdedd73297b1fe74214b22401be"
    base_image="satama.csc.fi/r_installation_spack/core-cpu-deps@${base_image_commit}"
else
    echo "Parsing of the processor architecture failed"
    exit 1
fi


# Build socket bridge binary
# Only needs to be done once.
# cd socket-bridge
# CGO_ENABLED=0 go build -o socket-bridge .
# cd ..


if [ ! -d "/appl/soft/manual/general/$( arch )/roihu-agent-env/job-monitoring-sdk" ]; then
  echo "job-monitoring-sdk does not exist."
  exit 1
fi

if [ ! "$( ls -A /appl/soft/manual/general/$( arch )/roihu-agent-env/bin/slurm-mcp/v1 )" ]; then
  echo "slurm-mcp binary does not exist."
  exit 1
fi

mkdir -p images


# Build the container
container_name=${container}-${node_arch}-${agent_env_version}.sif
apptainer build --fakeroot --writable-tmpfs --force \
    --build-arg "IMAGE_COMMIT=$( git show --pretty='format:%h' -s HEAD )" \
    --build-arg "BASE_IMAGE_COMMIT=$base_image_commit" \
    --build-arg "OPENCODE_VERSION=$opencode_version" \
    --build-arg "CLAUDE_VERSION=$claude_version" \
    --build-arg "CODEX_VERSION=$codex_version" \
    --build-arg "BOOTSTRAP=docker" \
    --build-arg "BASE_IMAGE=$base_image" \
    --build-arg "SOCKET_BRIDGE_FILE=$socket_bridge_file" \
    images/$container_name apptainer/${container}.def

# Generate modulefile
create_agent_env_module $container_name $agent_env_version

# Fix permissions
chgrp -R project_2001659 images
chgrp -R project_2001659 bin
cd $old_dir
