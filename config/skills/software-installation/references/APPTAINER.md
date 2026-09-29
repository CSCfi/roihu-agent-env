# Best Practices for Building Apptainer Containers on Roihu

## Overview
This document provides step‑by‑step instructions for building Apptainer (formerly Singularity) containers that run reliably on Roihu. It covers:
- Choosing the correct architecture (CPU vs GPU)
- Selecting the base image
- Configuring temporary and cache directories to avoid quota issues
- Using `--fakeroot` and `--sandbox` when appropriate
- Cleaning up caches and temporary files
- Example build definition files

[!IMPORTANT]
You cannot build the container yourself because `--fakeroot` does not work inside your container.
After creating the `.def` file, give user the build command and ask them to run it.

## Prerequisites
1. **Identify the target partition** – CPU nodes are x86_64, GPU nodes are aarch64 (Arm‑based Grace). 
If you are currently on the wrong login node, request the user to start a new session on the correct one.
2. **Know your project name** – you will need it for cache paths (`/scratch/<project>/...`). 
Ask the user if it is not clear from current directory's path. 

If you are running on the login node, suggest the user starts a new interactive session on a compute node.
```bash
# CPU side
sinteractive --cores 4 --time 0:30:00 -A <project>

# GPU side (example)
sinteractive --gpu --cores 4 --time 0:30:00 -A <project>
```
You can't start these session yourself, so you need to ask the user.

## Set temporary and cache directories
Roihu sets `$TMPDIR` to a local SSD on each node (≈80 GB on login nodes, potentially much larger on compute nodes). **Never use Lustre (`/projappl`, `/scratch`) as the temporary directory.**
```bash
# Ensure the build uses the local disk for temporary files
export TMPDIR=$(mktemp -d)
```

### Cache directory
The default cache (`$HOME/.apptainer`) has a 15 GiB quota that is quickly exhausted. Redirect the cache to a scratch location or to `$TMPDIR`:
```bash
# Persistent cache for the duration of the project (counts towards scratch quota)
export APPTAINER_CACHEDIR=/scratch/<project>/$USER/.apptainer

# Or, for a single‑run build that disappears with the job
export APPTAINER_CACHEDIR=$TMPDIR
```
Clean the cache when needed:
```bash
apptainer cache clean
```

## Select a base image

Roihu uses Rhel 9, so using a base image with similar OS simplifies things.
Example of a good minimal option is `rockylinux/rockylinux:9-ubi`.
Pay attention to the OS of the used base image, and use appropriate package manager for each OS.

### Official Roihu base images
Roihu provides base images that contain copies of the Spack software stack. 
These can provide significantly easier base to work with for complicated containers (MPI containers for example), 
but they take up a lot of space, so prioritize more minimal base images for simple containers.

Base images are stored in CSC’s OCI registry `satama.csc.fi`. Choose the image that matches the target architecture and desired software stack.

Search CSC documentation for "Roihu base images" to see an up to date list of these containers.

## Write a build definition (`.def`) file
Example for a simple CPU‑only container:
```def
Bootstrap: docker
From: rockylinux/rockylinux:9-ubi

%post
    # Install additional packages here, e.g.:
    # Make sure to use -y flags or equivalents for noninteractive installation.
    dnf -y install wget curl
    dnf -y clean all

    # install software required by user. Prefer installing to locations like /opt, and avoid user specific directories.
    ...

%runscript
    exec "$@"
```
Save as `container.def`.

## Build the container
```bash
# Ensure cache points at $TMPDIR for this run
export APPTAINER_CACHEDIR=$TMPDIR

# Bind the local TMPDIR to /tmp inside the build to avoid /tmp size limits
apptainer build --fakeroot --bind "$TMPDIR:/tmp" my_container.sif container.def
```
**Important flags**:
- `--fakeroot` – enables unprivileged builds on login nodes.
- `--bind "$TMPDIR:/tmp"` – makes the container see a spacious `/tmp`.

## Optional: Use a sandbox for incremental installations
If you face errors when building the container, build a writable sandbox for easier iteration.
Install everything you need, then convert to a .sif image:
```bash
apptainer build --fakeroot --sandbox $TMPDIR/sandbox container.def
# Enter the sandbox. --contain and --cleanenv help with avoiding unreproducible influence from the environment outside the container.
apptainer shell --fakeroot --writable --cleanenv --contain --bind="$TMPDIR:/tmp"
# When satisfied, freeze to .sif
apptainer build my_container.sif $TMPDIR/sandbox
```
Sandboxes contain a massive amount of small files, so it is **critical** that all sandboxes are built in `$TMPDIR` to avoid overloading Lustre.
Convert the sandbox to a .sif file before copying it to a Lustre partition.

### Possible pitfalls
Using `--contain` flag means `$HOME` inside the container is a temporary in-memory directory.
Do not install anything in `$HOME`, and prefer directories like `/opt`. (This is the best practice with containers anyway.)

## Run the container
```bash
# CPU container
apptainer run my_container.sif <command>

# GPU container (requires --nv)
apptainer run --nv my_gpu_container.sif <command>
```

## FAQ
- **Can I build a GPU container on a CPU node?** No – the architectures differ. Build on a GPU login node or in a GPU interactive job.
- **Do I need root privileges?** No. Use `--fakeroot` with Apptainer inside the Roihu environment.
- **What if I hit the 15 GiB home quota?** Always set `APPTAINER_CACHEDIR` to a scratch path or `$TMPDIR` before building.

---