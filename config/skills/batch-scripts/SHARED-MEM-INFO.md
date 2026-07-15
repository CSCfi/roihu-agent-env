# Serial and Shared Memory Jobs

Serial and shared memory jobs need to be run within one compute node.
In thread-based jobs, the --mem option is recommended for memory reservation. This defines the amount of memory required per node.
Match the `--cpus-per-task` to the number of threads or processes the application uses.
Set `export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}`