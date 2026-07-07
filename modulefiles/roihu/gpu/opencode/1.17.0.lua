-- LUMI AI Factory agent environment module
--
-- This module enables use of the LUMI AI Factory's containerized environment
-- for running AI coding agents on LUMI in a more secure manner.
--

help([[
The LUMI AI Factory agent environment is a containerized environment
for running AI coding agents on LUMI in a more secure manner.

This module provides the following commands:
* opencode

More information:
* https://docs.lumi-supercomputer.eu/laif/software/agent-infrastructure
* https://github.com/lumi-ai-factory/laifs-agent-env
* https://opencode.ai/docs
]])

--
-- Make this module mutually exclusive with the goose agent environment.
-- Both provide overlapping wrappers and set the same env vars (AGENT_IMAGE,
-- SLURM_MCP_BIN), so only one may be loaded at a time. conflict() makes Lmod
-- refuse to load this module while any version of goose is loaded.
--

family("agent-env")

--
-- Specify the container image.
--

-- Resolve the environment root from this modulefile's own location. myFileName()
-- is an Lmod builtin returning this file's absolute path; strip /modulefiles/...
-- to get the install root. (Lmod reads modulefiles with its own Lua interpreter,
-- so ${BASH_SOURCE[0]} does NOT refer to this file and must not be used here.)
local root = myFileName():gsub("/modulefiles/.*$", "")

setenv("AGENT_IMAGE", pathJoin(root, "images/opencode-gpu-1.17.0.sif"))

-- Path to the host-side Slurm MCP server binary. The opencode/goose wrapper launches this.
setenv("SLURM_MCP_DIR", pathJoin(root, "bin/roihu/slurm-mcp"))

--
-- Set module-level Singularity bind paths
--

-- TODO: Check if these are necessary
-- setenv("APPTAINER_BIND", "/appl")

--
-- Add executables to `PATH`
--

prepend_path("PATH", pathJoin(root, "bin/roihu/opencode"))

--
-- Print load message
--

--if mode() == "load" then
--    LmodMessage(
--        "\n" ..
--        "=========================================================\n" ..
--        "CAUTION: Loaded LUMI AI Factory agent environment module.\n" ..
--        "=========================================================\n" ..
--        "\n" ..
--        "* Data privacy: The default OpenCode model is hosted by the\n" ..
--        "  company maintaining OpenCode. If you use this model, any data\n" ..
--        "  you enter will be sent to the company.\n" ..
--        "* Data security: Your current working directory and any\n" ..
--        "  subdirectories are accessible inside the environment.\n" ..
--        "* Tool use: The agent must prompt you for permission in order to\n" ..
--        "  use tools other than the LUMI AIF MCP server.\n" ..
--        "* Experimental status: The agent environment is experimental and\n" ..
--        "  may evolve rapidly. Check the `lumi-ai-factory/laifs-agent-env`\n" ..
--        "  GitHub repository for any changes to agent capabilities and\n" ..
--        "  permissions before use.\n" ..
--        "\n" ..
--        "Run `module help " .. myModuleName() .. "` for more information.\n"
--    )
--end
