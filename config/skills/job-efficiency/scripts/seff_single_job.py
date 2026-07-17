from jobmon_sdk.jobs import JobMetrics
import pandas as pd
import os
import sys

def main():
    args = sys.argv
    jobid = 0
    if len(args) > 1:
        try:
            jobid = int(args[1].rstrip())
        except:
            print(f"Invalid JobID: {args[1]}")
            return 1
    api = "http://10.252.1.57:9543"
    jm = JobMetrics(jobid, api)

    df = jm.sum_stats()
    # For all jobs print:
    columns_to_print = ["jobidraw", "partition", "host", "mem_avg", "mem_max",
                    "mem_alloc"]
    # Only print gpu data for gpu partitions
    if "gpu" in df["partition"]:
        columns_to_print.append("gpu_avg_load")
        columns_to_print.append("gpu_avg_mem_load")
    else: 
        # Only print cpu data for cpu partitions.
        columns_to_print.append("cpus_avg_busy")

    df = df.loc[:, columns_to_print]
    print(df.to_string())

if __name__ == "__main__":
    main()