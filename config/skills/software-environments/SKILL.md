---
name: software-environments
description: check whether software is available on Roihu, explain how to load/use it, and guide installation from the docs if it isn't. Use when user wants to install, compile, use software, or asks if something is available.
---

# Software Environments Help

Software on roihu is used via Lmod module system. Software is not available before loading a necessary module, and will not be in user's PATH. You do not have access to Lmod commands, so use the documentation instead.

## Help steps

1. Each application has one page under `/opt/docs/apps`. 
2. If an application has a page, check the Available-section to see if it's available on Roihu. 
3. Use the page to tell the user how to load and use it. 
4. If the application isn't already available, ask the user if they want to install it. If yes, use `/opt/docs/computing/installing.md` to guide the user in the installation.