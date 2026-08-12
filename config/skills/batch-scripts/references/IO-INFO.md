# I/O Intensive applications

All nodes have fast local storage available. It can be accessed with the `$TMPDIR` environment variable.
`small` partition has 20 GiB quota, `medium`, `large` have 600 GiB, and GPU nodes have 150 GiB.
Additional fast storage can be requested with:
```bash
#SBATCH --exclusive
#SBATCH --bb="#BB_LUA SBF storagesize=<local_storage_space> path=/run/sbb/<username>"
```
**IMPORTANT** If $TMPDIR is used the data **must** be moved off of it at the end of the script, else it'll be inaccessible.
If the job created large amount of small files, put them in a tar archive first before moving to avoid causing issues for Lustre.