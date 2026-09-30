# Using Python on Roihu

This document contains some tips for using Python on Roihu. This is not an exhaustive guide, use this alongside the CSC-Docs tool.

### Check the existing Python environments.
Roihu has several modules for Python environments that contain most commonly used packages for their domain. These environments are containerized, to avoid overloading Lustre.
These modules are generally called `python-<something>`. You can use `module -r spider '.*python.*'` to search for them.
Avoid using the system python (module simple called `python`). This is an old version that is updated infrequently.
Most of these have separate pages on CSC-Docs with additional details. Use CSC-Docs tool to look up ones that sound relevant.
If that fails, ask the user to load the module and check with `python3 -sm pip list`. These environments don't work inside your sandbox, so you can't run that command yourself.

### Creating environments
Creating Python environments on Roihu has several common pitfalls. If creating a new environment is needed, you **must** use `software-installation` skill to avoid these.
