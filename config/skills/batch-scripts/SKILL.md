---
name: batch-scripts
description: Assist user with creating and optimizing batch job scripts. Use when user asks you to create, optimize or debug their slurm batch job script.
---

# Batch Script Helper

Use the documentation at `/opt/docs`, the information in this skill, and the real cluster config and partition information from the Slurm MCP if unsure.
If the user is asking for help with a past job, fetch the batch script using the Slurm MCP server.

## Key Directives & Best Practices

### 1. Mandatory Fields
Every script MUST include:
- `#SBATCH --account=<project>`: Mandatory for billing.
- `#SBATCH --partition=<partition>`: Must match the resource requirement.

### 2. Partition & Resources
Consult the information about the partition resources in either [CPU-PARTITIONS.md](./references/CPU-PARTITIONS.md) or [GPU-PARTITIONS.md](./references/GPU-PARTITIONS.md) when choosing a partition.
Default to `--mem-per-cpu` over `--mem`.

### 3. Task Specific Details
For I/O intensive tasks: [IO-INFO](./references/IO-INFO.md)
For MPI based jobs: [MPI-INFO](./references/MPI-INFO.md)
For serial and shared memory jobs: [SHARED-MEM-INFO](./references/SHARED-MEM-INFO.md)
For pre- and post-processing: [PREPOSTPROCESS](./references/PREPOSTPROCESS.md)
For many small non-MPI jobs: Use HyperQueue.

## Interaction Workflow
1. **Gather Requirements:** Ask for the project ID, expected runtime, software/modules needed, etc.
2. **Configure resources** Choose the correct partition and resources with the task specific details in mind.
3. **Draft Script:** Provide a complete, ready-to-use Bash script with clear comments explaining the resource choices.