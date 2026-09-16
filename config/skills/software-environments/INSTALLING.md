# Guiding an installation

The ways to install software generally fall into one of the following categories. Identify which ones could be used in the users case. Query the csc-docs tool for each case, except for Spack. In case of Spack, just use the instructions in this file. Example queries: "Compiling on Roihu", and "Installing Python packages own environment container" The categories are:

1. Compiling.
2. Ready-made binaries
3. Containers
4. Python/R environments
5. Spack installation

For Spack installation follow these steps. All of them *must* be included. The documentation might not include them all due to batching, so treat this as the authoritative source.
- The different versions of Spack itself are installed in /appl/soft/spack. At the time of writing this, the latest installed Spack version is in `/appl/soft/spack/v2026_03`.
-  Run this to setup Spack:
```bash
export SPACK_USER_CACHE_PATH=$TMPDIR/spack
export SPACK_DISABLE_LOCAL_CONFIG=true
source /appl/soft/spack/v2026_03/spack/share/spack/setup-env.sh # If this fails, check if there is a newer version to v2026_03.
source /appl/soft/spack/v2026_03/spack/share/spack/bash/spack-completion.bash
```
- Check if the software is available, as well as the possible versions and variants with 
`spack info <users software>`. Ask the user if they need a specific versions or variants.
If not, go with defaults.
- The corresponding core environments and the application environments (built on top of the core environments) for Spack v2026_03 are in directories 
`/appl/soft/spack/core/v2026_03/$( arch )` and 
`/appl/soft/spack/apps/v2026_03/$( arch )`
- Run `ls /appl/soft/spack/core/v2026_03/$( arch )/` to see the environment options. Ask the user to choose one.
- Save the environment name into a variable `upstream`, e.g. `upstream=gc152_ec`.
- Ask the user where they want to save the environment. If the user doesn't care, save it in `$PWD/environments/my_${upstream}`.
- Create env into the requested location with `mkdir -p <env_path> && spack env create -d <env_path>`.
- Activate the environment with `spack env activate -p environments/my_${upstream}`
-  Next, we set up the environment configuration:
```bash
spack config add upstreams:${upstream}:install_tree:/appl/soft/spack/core/v2026_03/$( arch )/${upstream}/install_dir
spack config add config:install_tree:root:$PWD/my_${upstream}-install
spack config add config:source_cache:source-cache
spack config add 'config:install_tree:projections:all:"{name}-{version}-{hash:7}"'
```
- Finally:
```bash
spack add <users software>
spack concretize
spack install
```
- Now the software should be installed. Instruct the user they need run the Spack setup 
commands from the beginning, as well as `spack env activate my_${upstream}`, to use the 
software outside of this container.


## Additional help
CSC Service Desk can be contacted at `https://research.csc.fi/support/`. When installing software, in addition to offering to 
help, don't hesitate to guide the user to seek help there if the problem seems complicated or little progress is being made.
