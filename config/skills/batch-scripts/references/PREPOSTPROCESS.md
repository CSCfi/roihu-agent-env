# Pre- and Post-Processing

1. If the main job is large, ask the user if the pre- or post-processing steps are able to utilize paralell computing. If not, it makes sense to split them into separate chained batch jobs. The non-paralellized jobs should be run on smaller resources than the main job.
2. Write the separate batch scripts. You can chain them by defining `--dependency=afterok:<slurm-jobid>` where the ID is the previous step.