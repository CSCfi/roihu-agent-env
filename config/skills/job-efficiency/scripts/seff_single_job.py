from jobmon_sdk.metrics import JobMetrics
import pandas as pd
import sys

# Source - https://stackoverflow.com/a/49361727
# Posted by Pietro Battiston, modified by community. See post 'Timeline' for change history
# Retrieved 2026-08-05, License - CC BY-SA 4.0

def format_bytes(size):
    # missing values come back from the api as None / NaN
    if size is None or pd.isna(size):
        return "n/a"
    # 2**10 = 1024
    power = 2**10
    n = 0
    power_labels = {0 : '', 1: 'k', 2: 'M', 3: 'G', 4: 'T'}
    while size > power and n < max(power_labels):
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

    # the summary endpoint returns nothing for jobs the monitoring never
    # sampled (very short jobs) or whose metrics the retention policy dropped.
    # an empty payload gives a frame with no columns at all, so bail out here
    # rather than dying on a KeyError below
    if df.empty:
        print("No resource statistics recorded for this job.")
        print("Very short jobs may finish before the monitoring samples them,")
        print("and older jobs may have had their metrics dropped by the")
        print("database retention policy.")
        return 0

    for col in ("mem_alloc", "mem_avg", "mem_max"):
        if col in df.columns:
            df[col] = df[col].map(format_bytes)
    df = df.drop(columns=["gpu_avg_power", "gpu_energy"], errors="ignore")

    print(df.to_string())
    return 0

if __name__ == "__main__":
    sys.exit(main())
