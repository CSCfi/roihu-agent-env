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
`spack info <users software>`. Ask the user if they need a specific version or variants.
If not, go with defaults.
- The corresponding core environments and the application environments (built on top of the core environments) for Spack v2026_03 are in directories 
`/appl/soft/spack/core/v2026_03/$( arch )` and 
`/appl/soft/spack/apps/v2026_03/$( arch )`
- Run `ls /appl/soft/spack/core/v2026_03/$( arch )/` to see the environment options. Ask the user to choose one.
- Save the environment name into a variable `upstream`, e.g. `upstream=gc152_ec`.
- Ask the user where they want to save the environment. Suggest `$PWD/environments/my_${upstream}` as the default.
- Create env into the requested location with `mkdir -p <env_path> && spack env create -d <env_path>`.
- Activate the environment with `spack env activate -p environments/my_${upstream}`
-  Next, we set up the environment configuration:
```bash
spack config add upstreams:${upstream}:install_tree:/appl/soft/spack/core/v2026_03/$( arch )/${upstream}/install_dir
spack config add config:install_tree:root:$PWD/my_${upstream}-install
spack config add config:source_cache:source-cache
spack config add 'config:install_tree:projections:all:"{name}-{version}-{hash:7}"'
```
- Then add the software to the environment and concretize it.
```bash
spack add <users software>
spack concretize
```
- At this point, look at the concretized specs. If the specs container either large or performance critical packages 
which were not explicitly requested, check if they would be available from the upstream environment and add them to the 
environment explicitly. Check packages in the upstream env with `spack -E -c 'upstreams:${upstream}:install_tree:/appl/soft/spack/core/v2026_03/x86_64/gcc152_ec/install_dir' find -l`.
- If the environment needed changes, reconcretize it with `spack concretize -f`.
- After the concretized specs look good, present them to the user for review. You **must** do this, and **do not** procceed 
to installation step without user approval.
- If the user approves the concretized spec, install the environment with `spack install`.
- Now the software should be installed. Instruct the user they need run the Spack setup 
commands from the beginning, as well as `spack env activate my_${upstream}`, to use the 
software outside of this container.