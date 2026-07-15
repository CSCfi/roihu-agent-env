# GPU Partitions 
| Partition   | Max walltime | Nodes | Max GPUs | Memory          | Notes                          |
|-------------|--------------|-------|----------|-----------------|--------------------------------|
| `gputest`   | 15 min       | 1–2   | 4/node   | 217 GiB/GPU     | validation runs only           |
| `gpumedium` | 36 h         | 1     | 4/job    | 217 GiB/GPU     | single-node GPU jobs           |
| `gpularge`  | 36 h         | 1–10  | 4/node   | 217 GiB/GPU     | multi-node; scalability test required |
Roihu has Nvidia GH200 superchips.
Request GPUs with `#SBATCH --gres=gpu:gh200:<1–4>`