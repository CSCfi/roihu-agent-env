# Roihu Agent Environment

This is a port of LUMI AI Factory Agent Environment to Roihu. See original repository for details: https://github.com/lumi-ai-factory/laifs-agent-env/tree/main

## Contents

- Apptainer definition file for installing [OpenCode](https://opencode.ai/docs) and [Claude CLI](https://code.claude.com/docs/en/overview) inside a container.
- Script `build_roihu_agent_env.sh` for building the images on Roihu.
- Module files and wrapper scripts for defining which directories to mount inside the container.
- An `AGENTS.md` file for Roihu adapted from the LAIFS one.
- An `opencode.json` adds the Slurm MCP-server, CSC User Guide MCP-server, and configuration for [Aitta](https://aitta.csc.fi) use.
- `managed-settings.json` and `managed-mcp.json` providing default settings for Claude
- Skills: batch-scripts, job-efficiency, and software environments. See `config/skills` for details.

## Usage
### Agent environment
The Roihu agent environment is a containerized environment for running AI coding agents in a more secure manner. Currently, container includes the open-source agents [Opencode](https://opencode.ai), as well as [Claude Code](https://claude.com/product/claude-code). The container comes with an AGENTS.md that gives the agents context about Roihu, the Slurm-MCP and how to access documentation.

**Must** **read:**
* The user is always responsible for the actions of their AI agents. Any command executed by an agent is run under your personal account.
* Data privacy: OpenCode uses the third-party OpenCode Zen model endpoint by default, which is hosted by Anomaly Innovations Inc., the company that maintains OpenCode. If you use models from this endpoint, be aware that any data that you enter or is read from your working directory will be sent to the company hosting the endpoint. Consider configuring OpenCode to use a different endpoint, for example a custom endpoint. Instructions for this are listed below.
* Data security: Your current working directory (```$PWD```) and any subdirectories are accessible inside the environment. Your home directory is not accessible, with the exception of certain directories, where OpenCode looks for configuration files and stores data.
* Tool use: The default configuration file included for Opencode gives permission for the agent to use read-only tools, and the Slurm-MCP server without permission.

If you wish OpenCode or Claude to have access to directories that are not under your current working directory, you can bind mount them by setting the `AGENT_BIND_PATHS` environment variable.
```bash
# Bind mount additional directories (optional)
export AGENT_BIND_PATHS=/path/to/dir1,/path/to/dir2
```
For more information, see the [apptainer documentation](https://apptainer.org/user-docs/master/index.html).

### Workflow
1. You can use the agent in a Roihu terminal window by running the commands below.
```bash
# Load environment module, use either cpu or gpu depending on your current node.
ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/<cpu or gpu>
ml roihu-agent-env

# Start agent
opencode
# or
claude
```
2. You can use your local VSCode with VSCode's Remote-SSH extension, connect to Roihu following the extensions [instructions](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh), and after connecting run you can install the Opencode extension and use it in the sidebar. You still need to activate the module with the commands `ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/<cpu or gpu> && ml roihu-agent-env` before using the extension.
3. If you prefer the Roihu Web Interface VSCode, you only need to open a VSCode terminal window and run the commands in it.
4. You can use the agent in Zed by navigating to 'Settings' > 'AI' > 'Terminal Thread Init Command' and adding `ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/cpu && ml roihu-agent-env && opencode` line to the field. Or add the following to your ~/.config/zed/config.json:
```json
{
  "agent": {
    "terminal_init_command": "ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/<cpu or gpu> && ml roihu-agent-env && opencode"
  }
}
```
To start a new agent thread, click the '+' in the Agent Panel (left edge by default), choose your workspace, and a new terminal should appear with Opencode running. To create another thread, repeat the steps.

I recommend setting an alias for the commands, for example, for running opencode on a cpu node, copy the following to your ~/.bashrc.
```bash
alias opencode_cpu="ml use /projappl/project_2001659/ansoneli/roihu-agent-env/modulefiles/roihu/cpu &&\
ml roihu-agent-env &&\
opencode"
```

### AI endpoint providers

> [!WARNING]
> If you use the Opencode Zen provider (the default), all of your data will be sent to the company behind Opencode and used for training.

To use Opencode with Aitta, you should get your API key from [here](https://aitta-auth.csc.fi/myToken), and save it to the $AITTA_KEY env variable before you start the agent. The agent already has Aitta configured.
```bash
export AITTA_KEY=<YOUR_KEY_HERE>
```

If you have a different API you want to use with Opencode, you can add it by creating a config at ~/.config/opencode/opencode.json or your project folder and following the [instructions](https://opencode.ai/docs/providers) by Opencode.

> [!NOTE]
> The model names are case-sensitive!

Here is an example config:
```json
{
    "$schema": "https://opencode.ai/config.json",
    "provider": {
        "your_provider": {
            "npm": "@ai-sdk/openai-compatible",
            "name": "provider_name",
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


### MCP Servers

The agents are by default configured to have access to a Slurm MCP server, which lets the agent access certain (read-only) Slurm commands safely. Up-to-date information about the server, including which commands are available, can be found [here](https://gitlab.ci.csc.fi/compen/hpc-environment/slurm-mcp).

Agents also have access to the CSC User Guide via a csc-docs MCP server, forked from the MCP made by [LAIFS](https://github.com/lumi-ai-factory/laifs-mcp-server). The User Guide version repo can be found [here](https://gitlab.ci.csc.fi/compen/hpc-environment/docs-mcp-deploy/-/tree/main?ref_type=heads).

If you want to use [Context7](https://context7.com) add this to your ~/.config/opencode/opencode.json. NB! Not a CSC service!

```json
{
  "$schema": "https://opencode.ai/config.json",
        "mcp": {
          "context7": {
            "type": "remote",
            "url": "https://mcp.context7.com/mcp",
            "headers": {
              "Authorization": "Bearer {env:CTX7_KEY}"
            },
            "enabled": true
        }
  }
}
```

### Skills

The agent comes with certain skills to help you with HPC specific tasks. The agent can autonomously use the skills when it sees it necessary, or you can invoke the skill by typing /<skill_name> before your prompt.
The current list of skills is:
- Software-environments - Help you with using or installing software on Roihu.
- Job-efficiency - Enables the agent to check how well your job ran.
- Batch-scripts - Help with Slurm batch scripts.

You can add your own skills in `~/.config/opencode/skills/`.

## Potential issues

### Excessive snapshots
Opencode uses git to create snapshots of file changes during sessions. In most cases this is desirable, but it can cause heavy filesystem load if you run opencode in a directory with large number of files which aren't gitignored. In these cases disable snapshots in config:

```json
{
    "$schema": "https://opencode.ai/config.json",
    ...
    "snapshots": false
}
```

### Errors when switching between versions

If you have switched between different Opencode versions and the TUI no longer starts up, this is likely caused by your session database being incompatible with the newer version. Removing your previous sessions fixes the issue. Session database should be located at `~/.local/share/<x86_64 or aarch64>/opencode/opencode.db`.
