# UI

How a screen gets from idea to working UI in this repo. The look is designed in HTML in this folder and turned
into a generated Vide Look by the `roblox-ui-maker` skill. A hand-written Screen module drives it. Code rules
for Screen modules, scaling and images are in `.agents/skills/roblox-ui/SKILL.md`.

## Set up (once per person)

- Get the skill: clone [UntitledProductions/roblox-skills](https://github.com/UntitledProductions/roblox-skills)
  and link or copy `skills/roblox-ui-maker` into `~/.claude/skills/`. Pull it to get updates.
- Python 3 with Pillow and numpy, Node 22+, and Chrome or Edge. Set the `CHROME` environment variable if
  the browser is not found.
- The official `Roblox_Studio` MCP server for `upload_image`. Enable **Game Settings > Security > Enable Studio
  Access to API Services**.
- Your own licensed icon pack. Pass its path to the skill's `copy_icons.py --pack`. Never commit it.
- Optional: the [UI Labs](https://ui-labs.luau.page/) Studio plugin to preview stories by hand.

## What is committed

`README.md`, `build.py`, `kit.css`, `style.css`, `styles/`, `ref.png`, `icons.json`, `rbx.json`, and the upload
ledger `rbx/out/uploaded.json`, so teammates reuse asset ids instead of uploading again. Generated pages,
the icon pack copy, downloaded textures and build output are ignored (`ui/.gitignore`).

The generated Luau is committed where the game uses it: `UIController/Looks/<Screen>.luau` and
`src/shared/Config/UIAssets.luau`. Never edit them by hand.

## `rbx.json`

Point the skill at the game's code:

```json
{
	"luau_out": "rbx/luau",
	"look_out": "../src/client/Controllers/UIController/Looks",
	"assets_out": "../src/shared/Config/UIAssets.luau",
	"screens": [{ "name": "Shop", "page": "shop", "groups": ["Shop"], "safe": [1100, 700] }]
}
```

`safe` is the box, in design pixels, that must stay fully visible on a small screen. Make it the screen's
content plus a small margin.

## What the skill produces

- `Looks/<Screen>.luau`: a function that takes an optional `Bindings` table and returns `Root`, a design-size
  frame with a `FitScale` `UIScale`. `UIController` creates the ScreenGui and fits `Root`; screens never do.
- Elements are named in the HTML (`name=`). A uniquely named label becomes a `Text` binding, a button an
  `Activated` binding, and an element hidden in the HTML a `Visible` binding.
- Art is uploaded once, after you have seen it. Ids live in the ledger and end up in `UIAssets.luau` with
  each image's aspect ratio. Every image goes through `Kit/Image.luau`, which keeps the aspect ratio.

## Flow

1. Ask for the screens and read the style reference (`ref.png`). Mock every screen and state in HTML.
2. Review and approve the mockups before anything is uploaded.
3. Export, generate, show the files to upload, upload after approval, then run `look.py`.
4. Write `Screens/<Name>.luau`, register it in `UIController`, run `./scripts/check.ps1`.
5. Playtest at 1920x1080, 1366x768 and 844x390. Check that nothing important leaves the safe box.

Change a screen's look in the HTML and regenerate. A hand edit to a Look is lost on the next run.
