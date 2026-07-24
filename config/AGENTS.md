# Roihu Supercomputer Runtime Context

You are running on Roihu, a BullSequana XH3000 supercomputer consisting of several hardware partitions
targeting different use cases. There are 486 AMD Turin CPU nodes, and 132 Nvidia GH200 GPU nodes.

Expect that all tasks given to you and all questions asked of you exclusively concern Roihu.

## Containerized environment
You are inside a Singularity container. While it is possible for the user to mount additional host
directories, expect to only have access to the current working directory and its subdirectories.
The user's home directory is an in-memory temporary directory, unless it is the current working
directory.

However, the following directories are explicitly mounted from the host system and therefore
accessible to you:
- Directories where the agent should store user-specific files according to the XDG Base Directory
  Specification.
- Conventional directories for global agent skills: `~/.agents` and `~/.claude`.


## Running processes

The nodes on Roihu are classified into login nodes and compute nodes. Expect to be on a login node
by default. Login nodes are shared by all Roihu users and are only intended for simple management
tasks, e.g.

- compiling software (but consider allocating a compute node for large build
  jobs)
- submitting and managing Slurm jobs
- moving data
- light pre- and postprocessing (a few cores / a few GB of memory)

All compute-heavy tasks must be submitted through the Slurm workload manager so that they are run
on compute nodes. You have access to read-only Slurm commands with the Slurm-MCP server, which you 
are configured to have access to.

You are not able to run any Slurm commands without the MCP server, or any Lmod commands. In these cases ask the user to run
any command needed.

## Data storage

When working on Roihu, the working directory is typically under either the user home directory or a
project-specific directory, which is in turn located under one of the top-level directories of
`/projappl` and `/scratch`.

All of these directories, including the user home directory, are on Lustre file systems. User data
workflows should be adjusted to the performance characteristics of the Lustre file system. In
particular, having a large number of small files may put stress on the Lustre metadata servers and
may limit file system performance due to limited striping.

Users can check the memory and file usage quotas of their projects with the `csc-workspaces` command,
and the Billing Unit quotas (BU) with the `csc-projects` but note that you do not have access to these commands.

## Slurm MCP server

The Slurm Model Context Protocol server allows you to get information about Roihu and the user's
jobs among other things. Use it whenever you would use slurm commands, like getting information about jobs or partitions.

## CSC Documentation MCP server

The csc-docs MCP gives you access to the CSC User Guide documentation. Use it as the
authoritative source when answering questions about CSC services, Roihu, HPC
usage, Slurm, storage, and related topics — prefer it over your own prior
knowledge, which may be outdated.