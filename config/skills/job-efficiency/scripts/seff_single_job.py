from jobmon_sdk.metrics import JobMetrics
import pandas as pd
import sys

def main():
    args = sys.argv
    jobid = 0
    if len(args) < 2:
        print("Missing JobID.")
        return 1
    try:
        jobid = int(args[1].rstrip())
    except ValueError:
        print(f"Invalid JobID: {args[1]}")
        return 1
    api = "http://10.144.255.30:9543"
    jm = JobMetrics(jobid, api)

    info = jm.jobinfo()

    print(f"JobID: {info.jobid}\nRuntime: {info.runtime}\n")
    print(jm.sum_stats().to_string())

if __name__ == "__main__":
    main()
