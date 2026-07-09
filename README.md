# Roihu Agent Environment

This is a port of LUMI AI Factory Agent Environment to Roihu. See original repository for details: https://github.com/lumi-ai-factory/laifs-agent-env/tree/main

## Contents

- Apptainer definition files for installing [OpenCode](https://opencode.ai/docs) and [Goose](https://goose-docs.ai/) inside a container.
- Script `build_containers.sh` for building the images on Roihu.
- Module files and wrapper scripts for defining which directories to mount inside the container.
- An `AGENTS.md` file for Roihu adapted from the LAIFS one.
- An `opencode.json` adds the Slurm MCP-server and configuration for [Aitta](https://aitta.csc.fi) use.

## Usage
### Workflow
1. You can use the agent in a Roihu terminal window by running the commands below.
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
2. You can use your local VSCode with VSCode's Remote-SSH extension, connect to Roihu following the [instructions](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh), and after connecting run the same commands as in option 1 in your VSCode terminal.
3. If you prefer the Roihu Web Interface VSCode, you only need to open a terminal window and run the commands in it.

I recommend setting an alias for the commands, for example for running opencode on a cpu node, copy the following to your ~/.bashrc.
```bash
alias opencode_cpu="ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/cpu \
ml opencode \
opencode"
```

### Inference providers

> [!WARNING]
> If you use the Opencode Zen provider (the default), all of your data will be sent to the company behind Opencode and used for training.

To use Opencode with Aitta, you should get your API key from [here](https://aitta-auth.csc.fi/myToken), and save it to the $AITTA_KEY env variable before you start the agent. The agent already has Aitta configured.
```bash
export AITTA_KEY=<YOUR_KEY_HERE>
```

If you have a different API you want to use with Opencode, you can add it by  creating a config at ~/.config/opencode.json or your project folder and following the [instructions](https://opencode.ai/docs/providers) by Opencode.

Here is an example config:
```json
{
    "$schema": "https://opencode.ai/config.json",
    "provider": {
        "your_provider": {
            "npm": "@ai-sdk/openai-compatible",
            "name": "YourName",
            "options": {
                "baseURL": "https://enter-your-url/openai/v1",
                "apiKey": "{env:YOUR_API_KEY}"
            },
            "models": {
                "ModelName-Case-Sensitive": {
                    "options": {
                        "reasoningEffort": "high",
                        "textVerbosity": "low"
                    }
                },
                "Another-Model": {}
            }
        }
    },
}
```
If your API key changes often, you can leave that field out of the config, and when starting Opencode type /connect, choose your provider, and paste your key.

For Goose, if you are using Aitta, you save the Api key from [this](https://aitta-auth.csc.fi/myToken) link to the environment variable AITTA_KEY. Then run Goose.

For other providers, you load the environment module and run goose configure. Follow the prompts, and consult the [instructions](https://goose-docs.ai/docs/getting-started/providers/#configure-provider-and-model). The configuration will automatically be saved for you.