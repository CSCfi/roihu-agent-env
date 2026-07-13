---
name: batch-scripts
description: Assist user with creating and optimizing batch scripts on Roihu. Use when user asks you to create, assist with, debug, or find problems with their batch scripts.
---

# Batch Script Helper

Using the documentation at `/opt/docs` the information in this skill, and the real cluster config and partition information from the Slurm MCP, help the user create or optimize their batch scripts for both good performance and sensible allocation sizes. 
If the user is asking for help with a past job, fetch the batch script using the Slurm MCP server.

## Roihu Hardware Context
- **CPU Nodes:** AMD Turin CPUs.
- **GPU Nodes:** Nvidia GH200 superchips (4 GPUs per node).
- **Memory:** 
  - Standard CPU nodes: ~2 GB per core.
  - High-memory nodes: 6037 GiB total, 128 cores per node.

## Key Directives & Best Practices

### 1. Mandatory Fields
Every script MUST include:
- `#SBATCH --account=<project>`: Mandatory for billing.
- `#SBATCH --partition=<partition>`: Must match the resource requirement.

2. CPU Resource Allocation

  ### 2. CPU Resource Allocation

  | Partition          | Max walltime | Nodes | Max CPUs   | Max memory     | Notes                          |
  |--------------------|--------------|-------|------------|----------------|--------------------------------|
  | `test`             | 15 min       | 1–2   | 384/node   | 744 GiB/node   | validation runs only           |
  | `small`            | 72 h         | 1     | 384/job    | 1500 GiB/job   | shared — request only what you need |
  | `medium`           | 36 h         | 1–6   | 384/node   | 744 GiB/node   | full nodes                     |
  | `large`            | 36 h         | 6–60  | 384/node   | 744 GiB/node   | full nodes; scalability test required |
  | `longrun`          | 10 days      | 1     | 192/job    | 1500 GiB/job   | shared; long single-node jobs  |
  | `hugemem`          | 36 h         | 1     | 128/job    | 6037 GiB/job   | XL high-memory node            |
  | `hugemem_longrun`  | 10 days      | 1     | 128/job    | 6037 GiB/job   | XL; long high-memory jobs      |

  - **Choose the partition from walltime + resources, not habit.** Standard (M) nodes are
    384 cores / 744 GiB (~1.9 GB per core). 
  - **Shared partitions (`small`, `longrun`):** limits are per *job*, so take a partial node.
    Use `--nodes=1` with `--cpus-per-task=X` (threaded) or `--ntasks=N` (MPI), and set
    memory with `--mem=` / `--mem-per-cpu=`.
  - **Full-node partitions (`medium`, `large`):** you're billed whole nodes, so fill them —
    keep `ntasks-per-node × cpus-per-task = 384`. Set node count with `--nodes=`.
    `large` starts at 6 nodes and requires a scalability justification.
  - **High-memory partitions (`hugemem`, `hugemem_longrun`):** Use only when the job genuinely
    needs >744 GiB. For the `hugemem_longrun` partition, keep `ntasks-per-node × cpus-per-task = 128`.
    Otherwise same as shared partitions.
  - **`test`:** <15 min validation before the real submission.

  3. GPU Resource Allocation

  ### 3. GPU Resource Allocation

  | Partition   | Max walltime | Nodes | Max GPUs | Memory          | Notes                          |
  |-------------|--------------|-------|----------|-----------------|--------------------------------|
  | `gputest`   | 15 min       | 1–2   | 4/node   | 217 GiB/GPU     | validation runs only           |
  | `gpumedium` | 36 h         | 1     | 4/job    | 217 GiB/GPU     | single-node GPU jobs           |
  | `gpularge`  | 36 h         | 1–10  | 4/node   | 217 GiB/GPU     | multi-node; scalability test required |

  - Request GPUs with `#SBATCH --gres=gpu:gh200:<1–4>`.
  - **Memory scales with GPUs: 217 GiB per reserved GPU** — request the GPU count that
    covers your memory need, not just your compute need.
  - Single-GPU/single-node → `gpumedium`; multi-node scaling → `gpularge` (needs
    justification); `gputest` for <15 min checks.
  - Match tasks to GPUs (typically one task per GPU); cores come bundled with each
    GH200, so size `--cpus-per-task` accordingly.

### 4. Performance & Optimization
- **Memory Allocation:** `--mem-per-cpu × --cpus-per-task` should equal the total memory reserved. 
   Prefer the `--mem` option for threaded tasks.
- **MPI Jobs:** Always use `srun` instead of `mpirun` or `mpiexec`.
- **Threaded Jobs:** Best practice is to set `--cpus-per-task` to the number of threads or processes the application uses. 
   Set `export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}`.
- **Local Storage:** 
  - Use `$TMPDIR` for I/O intensive tasks.
  - Remember to move data back to shared storage before the script ends.
- **Fast Local Scratch:** Use `--exclusive` and the `#SBATCH --bb` directive for network-based fast local storage.

### 5. Workflow Optimization
- **Chained Jobs:** Use `--dependency=afterok:<jobid>` to chain pre-processing, main computation, and post-processing.
- **Throughput:** For many small jobs, recommend using HyperQueue.

## Interaction Workflow
1. **Gather Requirements:** Ask for the project ID, expected runtime, software/modules needed, and whether the job is serial, MPI, or GPU-based.
2. **Draft Script:** Provide a complete, ready-to-use Bash script with clear comments explaining the resource choices.
3. **Review & Optimize:** Suggest improvements based on the user's specific application (e.g., recommending local storage if they mention many small files).
4. **Verification:** Remind the user to check their job with `seff <jobid>` after the first run.
