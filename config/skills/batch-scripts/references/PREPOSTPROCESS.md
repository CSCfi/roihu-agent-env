# Pre- and Post-Processing

1. If the main job is large, and if the pre- or post-processing steps are not able to utilize paralell computing to the same extent, it makes sense to split them into separate chained batch jobs. The non-paralellized jobs should be run on smaller resources than the main job.
2. Write the separate batch scripts. Chain them by defining `--dependency=afterok:<slurm-jobid>` where the ID is the previous step.