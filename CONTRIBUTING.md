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
    - [Issue](https://github.com/6v6-Adjustments/6v6-adjustments/issues) tracking and [Pull Request](https://github.com/6v6-Adjustments/6v6-adjustments/pulls)
- Discord
    - Communication between developers


## Setup Instructions
1. Download [Visual Studio Code](https://code.visualstudio.com/download).
2. Go to extension tab in VScode and install `OverPy` extension.
5. Clone the repository to your local computer (use [GitHub Desktop](https://desktop.github.com/) if you don't know how to clone using terminal).
6. Open cloned repository folder on VS Code.
7. Try building gamemode using instructions [below](#building).
8. Follow [general workflow](#general-workflow) to start development.


## Building

For instructions on how to use OverPy, see [here](https://github.com/Zezombye/overpy/wiki)
  
1. Compile main.opy using the compiling instructions at [OverPy Wiki](https://github.com/Zezombye/overpy/wiki/General-usage#Compiling)
2. Open a custom game in Overwatch
3. Paste the compiled gamemode code


## General workflow

1. Find an [issue](https://github.com/6v6-Adjustments/6v6-adjustments/issues) to fix (or submit one yourself).
2. Create new branch dedicated to that issue.
3. Modify codebase using VScode. Be sure to follow [styling guidelines](#coding-style-guidelines).
4. Compile and test new codebase.
6. Commit working changes.
7. Submit [Pull Request](https://github.com/6v6-Adjustments/6v6-adjustments/pulls) (PR) to merge your branch into dev branch.
8. Wait for owner to approve and merge your Pull Request.


## Release Cycle

1. For every 3~5 features added to staging branch, the devs will compile a staging build and test each feature manually.
2. If your feature fails to meet quality expectations, the MR corresponding to that feature will be reverted to drop the changes.
3. After each feature in staging branch is confirmed, the staging branch will be merged to main branch and released as latest build. If the latest build plays without crashing, it will be set as the stable build.  


## Coding Style Guidelines

This codebase follows Python's [PEP 8 style guide](https://peps.python.org/pep-0008/) since OverPy follows Python syntax.

1. Variable names should be `snake_case`. Example: `hero_health_armor`
2. Function names should be `camelCase`. Example: `destroyBarrier()`
3. File names should be `snake_case`. Example: `custom_heroes.opy`
4. No [magic numbers](https://stackoverflow.com/q/47882). Constants should always be referred to by the names defined in [src/constants](https://github.com/6v6-Adjustments/6v6-adjustments/tree/main/src/constants).
5. Rule and subroutine names should follow the format `rule "[file_name.opy]: My custom rule":` and `@Name "[file_name.opy]: mySubroutineFunc()"` respectively.
6. Keep rules simple; each rule should only perform one task. Try to limit rules to at most 10 lines of code and group large blocks of code into subroutines whenever possible. See [src/heroes/bastion](https://gitlab.com/MaxwellJung/ow1_emulator/-/tree/main/src/heroes/bastion) as an example.
