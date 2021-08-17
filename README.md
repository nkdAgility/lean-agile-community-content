# Professional Lean-Agile Practitioner
Memoirs of a Professional Scrum Trainer


## How to Contribute to these docs

This guidance is stored in the [Lean-Agile DevOps Content](https://github.com/nkdAgility/lean-agile-devops-content) under the ./source/ folder. Anyone can contribute by "forking" this Git Repository and adding or changing markdown content. When you submit your PR please list your changes and intent so that the Stewards can easily moderate it.

### What does a good PR look like

- All files spell checked
- configuration.json updated with any added, removed, or renamed files
- Any file renames or moves should use `git mv` to preserve history
- Do not combine changes to the Engine (azure-pipelines.yml, build.ps1, cover.tex, or header.tex) with Content changes. Please submit separate PR's
- Run Build.ps1 to regenerate PDF files and validate output

Note: PR's are approve by us and we may ask for changes to tone or message to keep within our vision of the workshops.

## How to build these docs

We have create a `build\build.ps1` file in the root of the repository. This file is cross platform and will run on Mac, Linux, and Windows:

- [Powershell v7+ for mac, linux, or windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [PanDoc for mac, linux, or windows](https://pandoc.org/installing.html)
  
Once you have both of these installed you should be able to call `build.ps1` which will create the `APS Trainer Reference.*` in the root of the repository.

