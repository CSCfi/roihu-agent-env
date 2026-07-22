---
name: job-efficiency
description: Report a past job's resource efficiency. CPU/GPU utilization and memory allocated vs used. Use this instead of seff. Use when the user asks how efficient a job was, whether they over- or under-requested resources, what a job actually used, or wants to review recent jobs.
---

# Job Efficiency

To get the last 3 jobs the user has ran, use this [script](./scripts/list_jobs.py). It takes no inputs.
To get data on a specific job, use this [script](./scripts/seff_single_job.py), with the Job ID as input. If the user doesn't give a job ID, or gives vague definitions (e.g. my job last week) use the slurm_job_history or slurm_my_jobs tools to find what job is meant.
