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
# Load environment module, use either cpu or gpu depending on your current node.
ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/<cpu or gpu>
ml opencode
# or
ml goose

# Start agent
opencode
# or
goose
```
> [!WARNING]
> If you use the Opencode Zen provider (the default), all of your data will be used for training.

To use Opencode with inference via Aitta, you should get your API key from [here](https://aitta-auth.csc.fi/myToken), and save it to the $AITTA_KEY env variable before you start the agent.
```bash
export AITTA_KEY=<YOUR_KEY_HERE>
```

If you have a different API you want to use with Opencode, you can add it by typing /connect after launching Opencode. Alternatively, you create a config at ~/.config/opencode.json or your project folder and following the [instructions](https://opencode.ai/docs/providers) by Opencode.

For Goose, you load the environment module as above, and then run goose configure. Follow the prompts, and consult the [instructions](https://goose-docs.ai/docs/getting-started/providers/#configure-provider-and-model) when unsure.