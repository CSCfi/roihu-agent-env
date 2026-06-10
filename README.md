# Roihu Agent Environment

This is a port of LUMI AI Factory Agent Environment to Roihu. See original repository for details: https://github.com/lumi-ai-factory/laifs-agent-env/tree/main

## Contents

- An Apptainer definition file for installing [OpenCode](https://opencode.ai/docs) inside a container.
- A module file and wrapper script for defining which directories to mount inside the container.
- An `AGENTS.md` file containing basic instructions for the agent about working on LUMI.
- An `opencode.json` config file for making the `AGENTS.md` file and the
  [LUMI AIF MCP server](https://github.com/lumi-ai-factory/laifs-mcp-server)
  discoverable to the agent.

## Usage

```bash
# Load environment module
module load Local-LAIF lumi-aif-agents

# Start agent
opencode
```
