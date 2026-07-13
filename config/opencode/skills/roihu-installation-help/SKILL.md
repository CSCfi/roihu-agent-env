---
name: roihu-installation-help
description: check whether software is available on Roihu, explain how to load/use it, and guide installation from the docs if it isn't. Use when user wants to install, compile, use software, or asks if something is available. 
---

# Check Installation

Roihu's installed applications are documented as Markdown pages in the CSC user
guide. Each application has one page under the `apps/` directory of the docs
tree. If an application has a page, check the Available-section to see if it's available on Roihu. Use the page
to tell the user how to load and use it. If the application isn't already available, use documentation
to guide the user in the installation.

## Where the docs are

- Application-pages: Inside the agent container: `/opt/docs/apps` Files are named in lowercase kebab-case with a `.md`
   extension, e.g. `pytorch.md`, `python.md`, `r-env.md`, `alphafold.md`, `qe.md`.
- There is also an `index.md` listing the applications — ignore it as a match.
- Installation instructions: `/opt/docs/computing/installing.md`


## Procedure

1. **Always start by listing the filenames.** Run `ls /opt/docs/apps`. Do not
   skip this — you cannot judge whether a page exists, or match a fuzzy name,
   without the actual list in front of you.

2. **Match the software to a filename from that list.** The user's spelling will
   often not match exactly, so reason about it — do not require an exact match:
   - Case and spacing differ: `PyTorch` → `pytorch.md`, `R env` → `r-env.md`.
   - The filename may be an abbreviation of a full product name:
     `Quantum ESPRESSO` → `qe.md`, `GROMACS` → `gromacs.md`.
   - **Only if no filename plausibly matches**, fall back to searching page
     contents for the full name, which usually appears in the page title:
     `grep -rilF "quantum espresso" /opt/docs/apps`.

3. **Check the page's Available-section.** Having a page does not mean the
   software is on Roihu. Open the matched page and check its `available_on` tag
   and the Available-section to see whether it is available on Roihu.

4. **Report the results.**
   - **Available on Roihu:** state that the software is available on Roihu, tell the user that the documentation can be found at
     https://docs.csc.fi/apps/<name> and summarize how to access it (module to load, example usage).
   - **Not available on Roihu:** state whether documentation for the software exists, and if it does where the software *is* available.
     If the documentation exists, tell the user it can be found at https://docs.csc.fi/apps/<name>
     Advise the user to check with `module spider <name>` and the list at https://docs.csc.fi/apps. 
     If not found, ask if the user wants help with installation, and guide in the process.
     See `/opt/docs/computing/installing.md` for the instructions and Roihu-specific best practices.
   - **Not sure / conflicting information / multiple candidates** list the close matches / conflicts, ask the user
     to clarify which one they mean.

## Notes

- The docs are a read-only, offline snapshot of https://docs.csc.fi, which map 1:1 with the markdowns. Prefer them
  over prior knowledge when describing how software is used on Roihu. Non-existence of documentation
  doesn't guarantee that software isn't already available, but if the availability is documented, it is 
  likely still true.
  