---
name: software-environments
description: check whether software is available on Roihu, explain how to load/use it, and guide installation from the docs if it isn't. Use when user wants to install, compile, use software, or asks if something is available.
---

# Software Environments Help

Software on roihu is used via Lmod module system. Software is not available before loading a necessary module, and will not be in user's PATH. You have access to Lmod commands (`module avail <modulename>`, `module spider <modulename>`) as well as the CSC documentation.

## Help steps
1. Try running `module spider <modulename>`. If the user doesn't permit running of the command, go to steps in "Searching CSC documentation" subsection instead.
2. If a matching module is found, inform the users of the available versions and which they want to load. If there are no matches, try the steps "Searching CSC documentation" subsection instead.
3. If the user wants to load a specific version, check if it can loaded directly or if other modules need to be loaded first with `module spider <modulename>/<version>`.

### Searching CSC documentation
1. Each preinstalled application has one page under apps/ in the CSC-User-Guide. Search for it with the csc-docs tool.
2. If an application has a page, check the Available-section to see if it's available on Roihu. If the page doesn't exist, or Roihu is not mentioned, assume that it is not pre-installed.
3. If the software is available, use the page to tell the user how to load and use it.

### Unavailable software
If the application isn't available, ask the user if they want to install it. If they do, you must read [INSTALLING.md](./INSTALLING.md). Reading is absolutely necessary to achieving the precision required for correct installation.
