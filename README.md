# Lean Agile & DevOps Guidance


## How to Contribute to these docs

This guidance is stored in the [Lean-Agile DevOps Content](https://github.com/nkdAgility/lean-agile-devops-content) under the ./source/ folder. Anyone can contribute by "forking" this Git Repository and adding or changing markdown content. When you submit your PR please list your changes and intent so that the Stewards can easily moderate it.


## Overview



## Content



## How to Contribute to these docs

This guidance is stored in the [Git Repository](https://github.com/nkdAgility/lean-agile-devops-content) under the ./source/ folder. Anyone can contribute by "forking" this Git Repository and adding or changing markdown content. When you submit your PR please list your changes and intent so that the Stewards can easily moderate it.

### What does a good PR look like

- All files spell checked
- configuration.json updated with any added, removed, or renamed files
- Any file renames or moves should use `git mv` to preserve history
- Do not combine changes to the Engine (azure-pipelines.yml, build.ps1, cover.tex, or header.tex) with Content changes. Please submit separate PR's
- Run Build.ps1 to regenerate PDF files and validate output

Note: PR's are approve by us and we may ask for changes to tone or message to keep within our vision of the workshops.


## How to build these docs

We have create a `build.ps1` and `release.ps1` files in the "build" folder. This file is cross platform and will run on Mac, Linux, and Windows:

- [Powershell v7+ for mac, linux, or windows](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
  - [PowerShellForGitHub](https://github.com/microsoft/PowerShellForGitHub#configuration) - This is installed automtically, but you do need to run `Set-GitHubAuthentication` to setup your auth.
- [PanDoc for mac, linux, or windows](https://pandoc.org/installing.html)
- [MiKTeX for mac, linux, or windows](https://miktex.org/download)
- [GitVersion for mac, linux, or windows](https://gitversion.net/docs/usage/cli/installation)

Once you have installed the pre-requisites you can then run:

- `.\build\build.ps1  -version 0.1.0 -project .\source\ws-introduction-to-agility\project.json` This will build a single project for testing with the output ending up in the project's bin folder; `.\source\ws-introduction-to-agility\bin\*`
- `.\build\build-all.ps1 -version 0.1.0` This script will build all of the projects found within the `.\source\*` folder.
- `.\build\release.ps1` This script will run a full build and then create and upload a release. This file generated the version number based on GitVersion. Creating a release will increment the next version number generated.

### Incrementing the Version Number artificially

The system will automatically create the next semantic version number based on the last tag on the git repo in that format. As each release tags the repo automatically the revision number will be incremented. If you want to increment the major or minor you can use the text `semver: major` or `semver: minor` in any commit or PR commit. Full documentation is available on the [GitVersion Documentation](https://gitversion.net/docs/reference/version-increments)
