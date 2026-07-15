# MPI Based Jobs
When running jobs on a partial node, set the number of MPI tasks with:
```bash
#SBATCH --partition=small
#SBATCH --ntasks=<number_of_mpi_tasks>
```
When running on full nodes (medium and large partitions), it is recommended to not use --ntasks option, but instead set --nodes, --ntasks-per-node, and --cpus-per-task instead:
```bash
#SBATCH --partition=medium
#SBATCH --nodes=<number_of_full_nodes>
#SBATCH --ntasks-per-node=384 --cpus-per-task=1  # The product should be 384
```
