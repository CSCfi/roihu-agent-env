# Best practices for Python environments on Roihu

This document contains some best practices for creating Python environments on Roihu. This is not intended to be an exhaustive guide, but instead supplementary information meant to be used together with searching CSC-Docs.

### Don't overload Lustre!
This is the most important thing to keep in mind with Python.
Lustre filesystem is bad at handling large amounts of small files, and Python environments are very common culprits of this.
Small environments with very few dependencies are usually fine to install as a venv, but any large environments should be containerized.

### Check the existing Python environments.
Roihu has several modules for Python environments that contain most commonly used packages. These are containerized environments, so they are fine for Lustre.
If one of the premade environments contains *almost* everything you need, it's fine to create a venv on top of it and install the missing packages there.
These modules are generally called `python-<something>`. You can use `module -r spider '.*python.*'` to search for them.
If any of them sound relevant, search the docs for that environment's name for a list of contents.
If that fails, ask the user to load the module and check with `python3 -sm pip list`. These environments don't work inside your sandbox, so you can't run that command yourself.
Avoid using the system python (module called just `python`). This is an old version that is updated infrequently, and has no additional packages.

### Creating large environments from scratch
If you need to create a larger environment from scratch, always use Tykky to containerize it. Search CSC-Docs for further instructions.
Note that Tykky doesn't work inside your sandbox, so instruct the user how to use it.
