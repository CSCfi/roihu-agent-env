# Roihu Agent Environment

This is a port of LUMI AI Factory Agent Environment to Roihu. See original repository for details: https://github.com/lumi-ai-factory/laifs-agent-env/tree/main

## Contents

- Apptainer definition files for installing [OpenCode](https://opencode.ai/docs) and [Goose](https://goose-docs.ai/) inside a container.
- Script `build_containers.sh` for building the images on Roihu.
- Module files and wrapper scripts for defining which directories to mount inside the container.
- An `AGENTS.md` file for Roihu is WIP
- An `opencode.json` config file is WIP

## Usage

```bash
# Load environment module
ml use ´pwd´/modulefiles/roihu/<cpu or gpu>
ml opencode
# or
ml goose

# Start agent
opencode
# or
goose
```

Goose requires running `goose configure` when using it for the first time.