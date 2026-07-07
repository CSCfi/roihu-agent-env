# Roihu Agent Environment

This is a port of LUMI AI Factory Agent Environment to Roihu. See original repository for details: https://github.com/lumi-ai-factory/laifs-agent-env/tree/main

## Contents

- Apptainer definition files for installing [OpenCode](https://opencode.ai/docs) and [Goose](https://goose-docs.ai/) inside a container.
- Script `build_containers.sh` for building the images on Roihu.
- Module files and wrapper scripts for defining which directories to mount inside the container.
- An `AGENTS.md` file for Roihu adapted from the LAIFS one.
- An `opencode.json` adds the Slurm MCP-server and configuration for [Aitta](https://aitta.csc.fi) use.

## Usage

```bash
# In Roihu:
cd /projappl/project_2001659/ansoneli/roihu-agent-env
# Load environment module
ml use modulefiles/roihu/<cpu or gpu>
ml opencode
# or
ml goose

# Start agent
opencode
# or
goose
```
NB: If you use the Opencode Zen provider (the default), all of your data will be used for training.

If you want to use Opencode with inference via Aitta, you should get your API key from [here](https://aitta-auth.csc.fi/myToken), and save it to the $AITTA_KEY env variable before you start the agent.
```bash
export AITTA_KEY=<YOUR_KEY_HERE>
```