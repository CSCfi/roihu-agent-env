# Roihu Supercomputer Runtime Context

You are running on Roihu, a BullSequana XH3000 supercomputer consisting of several hardware partitions
targeting different use cases. There are 486 AMD Turin CPU nodes, and 132 Nvidia GH200 GPU nodes.

CPU and GPU halves of Roihu have different processor architectures, and binaries compiled on one side
will **not** work on the other.

Expect that all tasks given to you and all questions asked of you exclusively concern Roihu.

## Containerized environment
You are inside an Apptainer container. While it is possible for the user to mount additional host
directories, expect to only have access to the current working directory and its subdirectories.
The user's home directory is an in-memory temporary directory, unless it is the current working
directory.

However, the following directories are explicitly mounted from the host system and therefore
accessible to you:
- Directories where the agent should store user-specific files according to the XDG Base Directory
  Specification.
- Conventional directories for global agent skills: `~/.agents` and `~/.claude`.
- Directories for system-wide application modules. These are generally not available in your PATH by
  default, and need to be loaded using the Lmod module system.

Do **not** read the source code or binaries of any software under the `/appl` path.
This is the location for admin-installed software,
some of which is proprietary and has licensing that forbids disclosure to third parties (this includes you).
Better be safe than sorry, so just treat every software under `/appl` like this.
You can look at directory contents under `/appl` if necessary for debugging, just don't read any of the files

## Running processes

The nodes on Roihu are classified into login nodes and compute nodes. Expect to be on a login node
by default. Login nodes are split between CPU and GPU sides of Roihu. If you are unsure where you are
currently running. You can check it by running `hostname`. Login nodes are shared by all Roihu users and
are only intended for simple management tasks, e.g.

- compiling software (but consider allocating a compute node for large build jobs)
- submitting and managing Slurm jobs
- moving data
- light pre- and postprocessing (a few cores / a few GB of memory)

All compute-heavy tasks must be submitted through the Slurm workload manager so that they are run
on compute nodes. You have access to read-only Slurm commands with the Slurm-MCP server, which you
are configured to have access to.

You are not able to run any Slurm commands without the MCP server. In these cases use the MCP server,
or ask the user to run the commands directly if the MCP server is insufficient.

## Software environment

Most of the software on Roihu is provided via Lmod modules, and not available by default. Expect that majority
of software will not be installed in standard locations like `/usr/bin`. If you need to find software that is 
not currently in your `PATH`, **don't** search the filesystem for it. This is ineffective and stresses Lustre.
**Do** use Lmod commands like `module avail` and `module spider <modulename>` instead.

You have access to majority of software on Roihu, but not all of it will work due to the containerized
nature of the working environment. Most python environments in particular are also containerized, and will
not work properly within another container. Compiling software should work fine however, and any heavy
computation needs to be done via Slurm anyway, where this will not be an issue.

## Data storage

When working on Roihu, the working directory is typically under either the user home directory or a
project-specific directory, which is in turn located under one of the top-level directories of
`/projappl` and `/scratch`. Note that both CPU and GPU sides of Roihu share the same filesystem.

All of these directories, including the user home directory, are on Lustre file systems. Lustre is
designed for parallel io of few large files, and heavy io on large amount of small files will stress
the system, causing issues for all users. To avoid causing problems for everyone, **do not** run
recursive commands like `ls -R`, `find`, `grep -r` or similar on high level directories like `/`,
`/scratch`, `/appl` or similar. **Always** try to limit the search depth to minimum first.

Users can check the memory and file usage quotas of their projects with the `csc-workspaces` command,
and the Billing Unit quotas (BU) with the `csc-projects`, but you do not have access to these commands.

## Slurm MCP server

The Slurm Model Context Protocol server allows you to get information about Roihu and the user's
jobs among other things. Use it whenever you would use slurm commands, like getting information about jobs or partitions.

## CSC Documentation MCP server

The csc-docs MCP gives you access to the CSC User Guide documentation. Use it as the
authoritative source when answering questions about CSC services, Roihu, HPC
usage, Slurm, storage, and related topics — prefer it over your own prior
knowledge, which may be outdated.

When querying, don't form questions, but strings that could plausibly match a page.
The input 'k' controls how many results are shown, defaults to k=4 and max is k=10. If none of the results are a
good match, you can query with a bigger k.
