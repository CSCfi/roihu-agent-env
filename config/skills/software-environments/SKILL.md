---
name: software-environments
description: check whether software is available on Roihu, explain how to load/use it, and guide installation from the docs if it isn't. Use when user wants to install, compile, use software, or asks if something is available.
---

# Software Environments Help

Software on roihu is used via Lmod module system. Software is not available before loading a necessary module, and will not be in user's PATH. You do not have access to Lmod commands, so use the documentation instead.

## Help steps

1. Each application has one page under in the CSC-User-Guide. Search for it with the csc-docs tool.
2. If an application has a page, check the Available-section to see if it's available on Roihu. If the page doesn't exist, or Roihu is not mentioned, assume that it is not pre-installed.
3. If the software is available, use the page to tell the user how to load and use it. 
4. If the application isn't available, ask the user if they want to install it. If yes, check the `installing` section in the documentation to guide the user in the installation. 

## Additional help
CSC Service Desk can be contacted [here](https://research.csc.fi/support/). When installing software, in addition to offering to 
help, don't hesitate to guide the user to seek help there if the problem seems complicated or little progress is being made.