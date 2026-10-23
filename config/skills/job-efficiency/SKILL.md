---
name: job-efficiency
description: Report a past job's resource efficiency. CPU/GPU utilization and memory allocated vs used. Use this instead of seff. Use when the user asks how efficient a job was, whether they over- or under-requested resources, what a job actually used, or wants to review recent jobs.
---

# Job Efficiency

Use this [script](./scripts/seff_single_job.py), with the Job ID as input. If the user doesn't give a job ID, or gives vague definitions (e.g. my job last week) use the slurm_job_history or slurm_my_jobs tools to find what job is meant.

## Some things to watch out for
General Slurm terminology: 1 CPU = 1 logical core, not the whole physical CPU.

### Very low cpu_avg_busy
Program is likely not parallelizing correctly and only using a single core / process.
If it is supposed to be multi-threaded, check if it is enabled correctly.
If it doesn't support multi-threading, don't request more than 1 CPU per process

### GPU job with high cpu_avg_busy and lower gpu_avg_load
This usually indicates that the GPU is not being fed data fast enough by the CPU.
Adding more CPUs can fix the issue, but ensure the program can actually use multiple cores simultaneously.

