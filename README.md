# ow1-emulator

This repository contains OverPy source code for building [Overwatch 1 Emulator](https://workshop.codes/PBMYC) Workshop gamemode.

Overwatch 1 stats are referenced using the [Wayback Machine](https://web.archive.org/web/20220929084035/https://overwatch.fandom.com/wiki/Overwatch_Wiki).\
Overwatch 2 heroes are balanced in-house with the help of our [Discord](https://discord.gg/GMVqwYXbWB) community.


Progress (✅ = Equivalent to OW1, ✔ = Close to OW1, Blank = Untouched):
<!--- https://docs.google.com/spreadsheets/d/1MdZIFEBehciwviUKqBGfStEGfqiRPaCtIdXxLSDwUMM/edit?usp=sharing -->
<!--- https://www.tablesgenerator.com/markdown_tables -->
|  | Primary Fire (M1) | Secondary Fire (M2) | Ability 1 (Shift) | Ability 2 (E) | Ultimate (Q) | Other |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| Ana | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Ashe | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Baptiste | ✅ | ✅ | ✅ | ✔ | ✅ |  |
| Bastion | ✔ | ✅ | ✅ | ✅ | ✅ | ✅ Sentry Reload Animation |
| Brigitte | ✅ | ✅ | ✅ | ✔ | ✔ | ✅ Shield Bash |
| Cassidy | ✅ | ✅ | ✅ | ✅ | ✔ |  |
| D.Va | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Doomfist | ✅ | ✅ | ✅ | ✅ | ✔ |  |
| Echo | ✅ | ✅ | ✅ | ✅ | ✔ |  |
| Genji | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Hanzo | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Junkrat | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Lucio | ✅ | ✅ | ✅ | ✅ | ✔ |  |
| Mei | ✔ | ✔ | ✅ | ✔ | ✅ |  |
| Mercy | ✅ | ✅ | ✅ | ✅ | ✔ | ✅ Regen |
| Moira | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Orisa | ✅ | ✅ | ✔ | ✔ | ✔ |  |
| Pharah | ✅ | ✔ | ✔ | ✔ | ✅ |  |
| Reaper | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Reinhardt | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ Steadfast |
| Roadhog | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ Ult Charge |
| Sigma | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Soldier: 76 | ✅ | ✅ | ✅ | ✔ | ✅ |  |
| Sombra |  | ✔ | ✔ | ✔ | ✔ |  |
| Symmetra | ✔ | ✔ | ✔ | ✔ | ✅ |  |
| Torbjorn | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Tracer | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Widowmaker | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Winston | ✅ | ✅ | ✅ | ✅ | ✅ |  |
| Wrecking Ball | ✅ | ✅ | ✅ | ✔ | ✔ | ✅ Piledriver |
| Zarya | ✅ | ✅ | ✅ | ✅ | ✔ |  |
| Zenyatta | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ Melee |

## Building with Bazel

Install Bazelisk by following [https://github.com/bazelbuild/bazelisk#installation](https://github.com/bazelbuild/bazelisk#installation).

Then compile the gamemode (hermetic Node + OverPy; no local Node install required):

```bash
bazel build //:gamemode
# Output: bazel-bin/gamemode.txt
```

CI also runs:

```bash
bazel build //...
bazel test //...
```

## Changelog

See [releases](https://github.com/Overwatch-1-Emulator/ow1-emulator/releases)

## Contributing Code

See [contribution guide](./CONTRIBUTING.md) for step by step instruction.
