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

Inside the agent container: `/opt/docs/apps` Files are named in lowercase kebab-case with a `.md`
extension, e.g. `pytorch.md`, `python.md`, `r-env.md`, `alphafold.md`, `qe.md`.
There is also an `index.md` listing the applications — ignore it as a match.

## How to decide

The decisive signal is the **filename**: an application has a page if and only if
`apps/` contains a file named after it. You then open that page to check whether
it is actually available on Roihu. Grepping page *contents* is noisy — common
terms like `python` or `blast` appear across many pages — so it is only a
fallback for finding the right filename. Because the answer comes from a specific
page's `available_on` tag and Available-section, you must first locate that page
by its filename, which means you must see the list of filenames.

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

4. **Report the result.**
   - **Found:** state that the software is available on Roihu, then print the
     matching page (`cat /opt/docs/apps/<name>.md`) and summarize how to access
     it (module to load, example usage). Tell the user they can find the documentation at
     the address `https://docs.csc.fi/apps/<name>`, do not tell them to go look at the markdown files, as they 
     can be outdated.
   - **Not sure / conflicting information / multiple candidates:** list the close matches and ask the user
     which one they mean, or briefly summarize each.
   - **Not found:** tell the user there is no documentation page for it, so it is
     most likely not pre-installed on Roihu. Do not attempt to install it
     yourself. Suggest they check with `module spider <name>` and check the up-to-date 
     documentation at `https://docs.csc.fi` or contact CSC service desk if they
     believe it should be available.

## Notes

- The docs are a read-only, offline snapshot of https://docs.csc.fi. Prefer them
  over prior knowledge when describing how software is used on Roihu.
- This skill only tells you what is *documented*. Absence of a page is a strong
  hint the software is not provided centrally, but is not absolute proof.
