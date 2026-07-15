---
name: batch-scripts
description: Assist user with creating and optimizing batch job scripts. Use when user asks you to create or assist with their slurm batch job script.
---

# Batch Script Helper

Use the documentation at `/opt/docs`, the information in this skill, and the real cluster config and partition information from the Slurm MCP if unsure.
If the user is asking for help with a past job, fetch the batch script using the Slurm MCP server.

## Key Directives & Best Practices

### 1. Mandatory Fields
Every script MUST include:
- `#SBATCH --account=<project>`: Mandatory for billing.
- `#SBATCH --partition=<partition>`: Must match the resource requirement.
- A move command at the end to move output data to a shared disk if $TMPDIR was used.

### 2. Partition Resources
Find information about the various partitions in either [CPU-PARTITIONS.md](./CPU-PARTITIONS.md) or [GPU-PARTITIONS.md][./GPU-PARTITIONS.md].

### 3. Performance & Optimization
Use $TMPDIR for I/O intensive tasks. 20GiB quota on small, 600GiB on full nodes, and 150GiB on GPU nodes.
For complex tasks, see the full documentation at `/opt/docs/computing/running/creating-job-scripts-roihu/` for details.

## Interaction Workflow
1. **Gather Requirements:** Ask for the project ID, expected runtime, software/modules needed, and whether the job is uses GPUs.
2. **Draft Script:** Provide a complete, ready-to-use Bash script with clear comments explaining the resource choices.
3. **Review & Optimize:** Suggest improvements based on the user's specific application (e.g., recommending local storage if they mention many small files).
