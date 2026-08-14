#!/bin/bash

set -euo pipefail

target_containers=("opencode" "opencode" "claude")
target_versions=("1.17.0" "1.18.1" "2.1.223")

# Parses if we are on roihu-cpu or roihu-gpu.
node_arch=$( arch )
if [[ $node_arch == "aarch64" ]]; then
    base_image="satama.csc.fi/r_installation_spack/core-gpu-gcc-14.3.0-cuda-12.9.1@sha256:96f99061fb4d21360dc89c5d1269397f85a6ad86f09479f08e07ed27b7c98311"
    socket_bridge_file="socket-bridge-gpu"
elif [[ $node_arch == "x86_64" ]]; then
    base_image="satama.csc.fi/r_installation_spack/core-cpu-gcc-15.2.0@sha256:e64b470bce6bd9786d4c4f195bdb0f7827bb441c6075d0824fd5842a3aca6fe5"
    socket_bridge_file="socket-bridge"
else
    echo "Parsing of the processor architecture failed"
    exit 1
fi

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
old_dir=$(pwd)
cd $script_dir

# Build socket bridge binary
# Only needs to be done once.
# cd socket-bridge
# CGO_ENABLED=0 go build -o socket-bridge .
# cd ..

mkdir -p images

# Update the job-monitoring-sdk:
rm -rf job-monitoring-sdk
git clone --depth 1 -b main ssh://git@gitlab.ci.csc.fi:10022/compen/job-monitoring/job-monitoring-sdk.git || { echo "git clone failed. Make sure you are on roihu-install node."; exit 1; }

# Loop over list length
for (( i=0; i<${#target_containers[@]}; i++ )); do
    container=${target_containers[i]}
    version=${target_versions[i]}
    apptainer build --fakeroot --fix-perms --writable-tmpfs --force --build-arg "APP_VERSION=$version" --build-arg "BASE_IMAGE=$base_image"\
        --build-arg "SOCKET_BRIDGE_FILE=$socket_bridge_file"\
        images/${container}-${node_arch}-${version}.sif apptainer/${container}.def
done
chgrp -R project_2001659 images
chgrp -R project_2001659 bin
cd $old_dir
