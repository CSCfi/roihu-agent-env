---
name: check-roihu-installation
description: Check if given software is installed on Roihu. If it is, print the documentation from the markdown file. Use when user wants to install or download software, or asks if software is installed, available, or if they can use a program.
---

# Check Installation

Roihu's installed applications are documented as Markdown pages in the CSC user
guide. Each application has one page under the `apps/` directory of the docs
tree. If an application has a page, check the Available-section to see if it's available on Roihu. Use the page
to tell the user how to load and use it instead of installing it themselves.

## Where the docs are

- Inside the agent container: `/opt/docs/apps`

Use whichever exists. Files are named in lowercase kebab-case with a `.md`
extension, e.g. `pytorch.md`, `python.md`, `r-env.md`, `alphafold.md`, `qe.md`.
There is also an `index.md` listing the applications — ignore it as a match.

## Procedure

1. **List the apps.** Run `ls /opt/docs/apps` to see every documented application.

2. **Match the software to a page.** The user's spelling will often not match
   the filename exactly, so reason about it — do not require an exact match:
   - Case and spacing differ: `PyTorch` → `pytorch.md`, `R env` → `r-env.md`.
   - The filename may be an abbreviation of a full product name:
     `Quantum ESPRESSO` → `qe.md`, `GROMACS` → `gromacs.md`.
   - If no filename looks right, grep the page contents for the full name, since
     the real name usually appears in the page title:
     `grep -rilF "quantum espresso" /opt/docs/apps`.

3. **Check the page's Available-section** All software that has a page isn't on Roihu.
    Check the page's available_on tag and the Available-section to see if the
    software is available on Roihu.

3. **Report the result.**
   - **Found:** state that the software is available on Roihu, then print the
     matching page (`cat /opt/docs/apps/<name>.md`) and summarize how to access
     it (module to load, example usage). Tell the user they can find the documentation at
     `https://docs.csc.fi/apps/<name>`
   - **Not sure / conflicting information / multiple candidates:** list the close matches and ask the user
     which one they mean, or briefly summarize each.
   - **Not found:** tell the user there is no documentation page for it, so it is
     most likely not pre-installed on Roihu. Do not attempt to install it
     yourself. Suggest they check with `module spider <name>` or contact CSC
     service desk if they believe it should be available.

## Notes

- The docs are a read-only, offline snapshot of https://docs.csc.fi. Prefer them
  over prior knowledge when describing how software is used on Roihu.
- This skill only tells you what is *documented*. Absence of a page is a strong
  hint the software is not provided centrally, but is not absolute proof.
