# CPU Partitions

| Partition          | Max walltime | Nodes | Max CPUs   | Max memory     | Notes                          |
|--------------------|--------------|-------|------------|----------------|--------------------------------|
| `test`             | 15 min       | 1–2   | 384/node   | 744 GiB/node   | validation runs only           |
| `small`            | 72 h         | 1     | 384/job    | 1500 GiB/job   | shared — request only what you need |
| `medium`           | 36 h         | 1–6   | 384/node   | 744 GiB/node   | full nodes                     |
| `large`            | 36 h         | 6–60  | 384/node   | 744 GiB/node   | full nodes; limited access     |
| `longrun`          | 10 days      | 1     | 192/job    | 1500 GiB/job   | shared; long single-node jobs  |
| `hugemem`          | 36 h         | 1     | 128/job    | 6037 GiB/job   | XL high-memory node            |
| `hugemem_longrun`  | 10 days      | 1     | 128/job    | 6037 GiB/job   | XL; long high-memory jobs      |

On full nodes, make sure the `ntasks-per-node × cpus-per-task` equal the Max CPUs of the nodes.
Do not request GPUs on CPU nodes.
Do not request full nodes on shared partitions.
Users do not have access to `large` partition by default. If the user doesn't have access and needs it,
refer to Roihu documentation for required steps for requesting access.