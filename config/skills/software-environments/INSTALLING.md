# Guiding an installation

The ways to install software generally fall into one of the following categories. Identify which ones could be used in the users case. Query the csc-docs tool for each case. E.g. "Compiling on Roihu", "Installing software with Spack on Roihu", and "Installing Python packages own environment container" The categories are:

1. Compiling.
2. Spack installation
For Spack installation ask the user to follow these steps. All of them *must* be included. The documentation might not include them all due to batching, so treat this as the authoritative source.
- Have the user check [here](https://packages.spack.io/) if the application is available. Proceed only after the user has confirmed the package is found.
-  Have the user run this: 
```bash
export SPACK_USER_CACHE_PATH=$TMPDIR/spack
export SPACK_DISABLE_LOCAL_CONFIG=true
source /appl/soft/spack/v2026_03/spack/share/spack/setup-env.sh # If this fails, ask the user to check if there is a newer version to v2026_03.
source /appl/soft/spack/v2026_03/spack/share/spack/bash/spack-completion.bash
```
- The different versions of Spack itself are installed in /appl/soft/spack. At the time of writing this, the latest installed Spack version is in /appl/soft/spack/v2026_03. The corresponding core environments and the application environments (built on top of the core environments) are in directories
`/appl/soft/spack/core/v2026_03/${target_family}`
`/appl/soft/spack/apps/v2026_03/${target_family}`
where $target_family is either x86_64 or aarch64, referring to the processor architecture on the CPU or the GPU nodes, respectively.
- ask the user to run `ls /appl/soft/spack/core/v2026_03/${target_family}/` to see the environment options. Tell them to choose one.
- User saves the environment, e.g. `upstream=gc152_ec`.
- Create env into $PWD/environments with `spack env create environments/my_${upstream}`.
- `spack env activate -p environments/my_${upstream}`
-  Next, we set up the environment configuration:
```bash
spack config add upstreams:${upstream}:install_tree:/appl/soft/spack/core/v2026_03/'${target_family}'/${upstream}/install_dir
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
- Instruct the user that they can use the software by `spack env activate my_${upstream}`, and then just the terminal command of their program.

3. Ready-made binaries
4. Containers
5. Python/R environments



## Additional help
CSC Service Desk can be contacted at `https://research.csc.fi/support/`. When installing software, in addition to offering to 
help, don't hesitate to guide the user to seek help there if the problem seems complicated or little progress is being made.
