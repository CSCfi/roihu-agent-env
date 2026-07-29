from jobmon_sdk.jobs import JobList
import pandas as pd
import os

api = "http://10.252.1.57:9543"
# JobList is scoped to the user
jl = JobList(api_address=api, user=os.environ["USER"])

df = jl.job_df
df = df[:3]
df_reduced = df.loc[: , ["jobidraw", "partition", "host", 'mem_avg', 'mem_max', 'mem_alloc',
                          'cpu_avg_busy','gpu_avg_load', 'gpu_avg_mem_load'
]]
# Print the last three jobs efficiency data.
print(df.to_string())
