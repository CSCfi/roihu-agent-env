#!/bin/bash

set -e

TARGET_CONTAINER="opencode"

# Parses if we are on roihu-cpu or roihu-gpu.
# TODO: Make this portable.
NODE_TYPE=$( hostname | cut -d "-" -f 2 )

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR
apptainer build images/${TARGET_CONTAINER}-${NODE_TYPE}.sif apptainer/${TARGET_CONTAINER}.def