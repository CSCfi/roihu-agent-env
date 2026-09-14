from jobmon_sdk.metrics import JobMetrics
import pandas as pd
import sys

# Source - https://stackoverflow.com/a/49361727
# Posted by Pietro Battiston, modified by community. See post 'Timeline' for change history
# Retrieved 2026-08-05, License - CC BY-SA 4.0

def format_bytes(size):
    # 2**10 = 1024
    power = 2**10
    n = 0
    power_labels = {0 : '', 1: 'k', 2: 'M', 3: 'G', 4: 'T'}
    while size > power:
        size /= power
        n += 1
    return f"{size:.2f} {power_labels[n]}B"


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

    print(f"JobID: {jm.jobinfo['jobid']}\nRuntime: {jm.jobinfo['runtime']}\n")
    df = jm.sum_stats
    df["mem_alloc"] = df["mem_alloc"].map(format_bytes)
    df["mem_avg"] = df["mem_avg"].map(format_bytes)
    df["mem_max"] = df["mem_max"].map(format_bytes)
    df = df.drop(columns=["gpu_avg_power", "gpu_energy"])

    print(df.to_string())

if __name__ == "__main__":
    main()
