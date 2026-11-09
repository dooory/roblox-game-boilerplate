# Getting started

For a person joining the project. Your AI agent does the rest: open this folder in Claude Code and ask it to
"set up the project". It runs `./scripts/setup.ps1` and walks you through the steps only you can do.

## What you do by hand, once

1. **Accounts.** A GitHub account that has access to this repo, and a Roblox account.
2. **Install Git and Rokit.**
   - Git: https://git-scm.com/downloads
   - Rokit: https://github.com/rojo-rbx/rokit (restart your terminal afterwards)
   - On Mac, also install PowerShell 7 (`brew install powershell`) and run scripts with `pwsh`.
3. **Clone the repo.** Ask your agent: "clone the repo into Documents/Projects". Or use GitHub Desktop.
4. **Run `./scripts/setup.ps1`.** It checks your tools, installs packages and runs the checks. It prints exactly
   what is missing and the one thing to do next.
5. **Install the Rojo plugin in Studio.** In Studio, open the Toolbox, search "Rojo" and install the plugin by the
   Rojo team, or follow https://rojo.space/docs/v7/getting-started/installation/.
6. **Create your own place.** In Creator Hub, open the project's experience and add a new place named after
   yourself, for example `Test - Sam`. You playtest here, so your tests and saved data never touch anyone else's.
   In Studio, open it and turn on **Game Settings > Security > Enable Studio Access to API Services**.
7. **Connect.** Run `./scripts/dev.ps1`, then in Studio open the Rojo plugin and click **Connect**. Accept the
   first sync. If someone else on this computer is already running Rojo, use another port:
   `./scripts/dev.ps1 -Port 34874`, and set the same number in the plugin.

## For UI work, also

- Python 3 with Pillow and numpy, Node 22 or newer, and Chrome or Edge.
- The `roblox-ui-maker` skill: see `ui/README.md`.
- The Roblox Studio MCP servers, so the agent can playtest and take screenshots.

## Day to day

- Ask your agent for what you want. It makes a branch, writes the code, runs the checks and opens a pull request.
- You review the pull request on GitHub. Merging it into `master` is how your work reaches your teammate.
- Never edit `master` directly. Pull the latest `master` before you start new work.
- One Rojo connection per place. Do not connect two people's checkouts to the same place.
