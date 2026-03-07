# Contribution Guide

If you're interested in submitting code to this gamemode, read this guide carefully.


## Required Tools
- [Visual Studio Code](https://code.visualstudio.com/download)
    - Text Editor for developing OverPy source code
- OverPy
    - VScode extension for compiling OverPy source code -> workshop script
- Git
    - Version control system
- GitHub
    - Remote archive of this source code repository
    - [Issue](https://github.com/Overwatch-1-Emulator/ow1-emulator/issues) tracking and [Pull Request](https://github.com/Overwatch-1-Emulator/ow1-emulator/pulls)
- Discord
    - Communication between developers


## Setup Instructions
1. Download [Visual Studio Code](https://code.visualstudio.com/download).
2. Go to extension tab in VScode and install `OverPy` extension.
3. Clone the repository to your local computer (use [GitHub Desktop](https://desktop.github.com/) if you don't know how to clone using terminal).
4. Open cloned repository folder on VScode.
5. (Optional) Install pre-commit hooks. Skip if you don't know what this is.
6. Try building gamemode using instructions [below](#building).
7. Follow [general workflow](#general-workflow) to start development.


## Building

For instructions on how to use OverPy, see [here](https://github.com/Zezombye/overpy/wiki)

1. Compile main.opy using the compiling instructions at [OverPy Wiki](https://github.com/Zezombye/overpy/wiki/General-usage#Compiling)
2. Open a custom game in Overwatch
3. Paste the compiled gamemode code


## General workflow

1. Find an [issue](https://github.com/Overwatch-1-Emulator/ow1-emulator/issues) to fix (or submit one yourself).
2. Create new branch dedicated to that issue.
3. Modify codebase using VScode. Be sure to follow [styling guidelines](#coding-style-guidelines).
4. Compile and test new codebase.
6. Commit working changes.
7. Submit [Pull Request](https://github.com/Overwatch-1-Emulator/ow1-emulator/pulls) (PR) to merge your fix into main branch.
8. Wait for owner to approve and merge your Pull Request.


## Release

Any commit messages formatted to [conventional commits](https://www.conventionalcommits.org) will be included in the patch notes.\
See example commit messages [here](https://github.com/googleapis/release-please?tab=readme-ov-file#how-should-i-write-my-commits).

To release:
1. Merge the release PR created by [release-please bot](https://github.com/googleapis/release-please).
2. After merging, [github-releases-to-discord bot](https://github.com/SethCohen/github-releases-to-discord) will forward the patch notes to Overwatch 1 Emulator [discord server](https://discord.com/channels/1125986404212670568/1157168349978050611).

Note:
- release-please bot requires Personal Access Token.
- github-releases-to-discord bot requires Discord webhook URL.


## Coding Style Guidelines

This codebase follows Python's [PEP 8 style guide](https://peps.python.org/pep-0008/) since OverPy follows Python syntax.

1. Variable names should be `snake_case`. Example: `hero_health_armor`
2. Function names should be `camelCase`. Example: `destroyBarrier()`
3. File names should be `snake_case`. Example: `custom_heroes.opy`
4. No [magic numbers](https://stackoverflow.com/q/47882). Constants should always be referred to by the names defined in [src/constants](https://github.com/Overwatch-1-Emulator/ow1-emulator/tree/staging/src/constants).
5. Rule and subroutine names should follow the format `rule "[file_name.opy]: My custom rule":` and `@Name "[file_name.opy]: mySubroutineFunc()"` respectively.
6. Keep rules simple; each rule should only perform one task. Try to limit rules to at most 10 lines of code and group large blocks of code into subroutines whenever possible. See [src/heroes/bastion](https://github.com/Overwatch-1-Emulator/ow1-emulator/tree/staging/src/heroes/bastion) as an example.
