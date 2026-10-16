---
name: roblox-ui
description: Use when adding or changing Roblox screens, ScreenGuis, UIController modules, StarterGui hierarchy, or Studio-authored UI.
---

# UI

`UIController` (`src/client/Controllers/UIController`) owns every screen. It ships with no screens; its `modules` table is empty.

**Build UI in Studio, not in code.** Prefer ScreenGuis authored in StarterGui, with code finding and driving them. Only create UI in code (`Instance.new`, React or similar) if the user says they prefer that.

- Use the Roblox Studio MCP tools to create and edit UI in StarterGui: inspect the existing tree, add ScreenGuis and elements, and take screenshots to check the result.
- If no Roblox Studio MCP is connected, do not fall back to building UI in code. Tell the user to set it up using https://create.roblox.com/docs/studio/mcp, and continue with the code side (the screen module) meanwhile.
- UI in StarterGui is saved in the place file, not on disk; Rojo does not sync it. Remind the user to save the place after UI changes.

```text
src/client/Controllers/UIController/
	init.luau
	Types.luau
	Screens/
		<Name>.luau
```

- **Adding a screen:**
  1. Create a ScreenGui in StarterGui named after the screen.
  2. Add `Screens/<Name>.luau` using the template below.
  3. Add `<Name> = require(script.Screens.<Name>)` to the `modules` table in `init.luau`.
- **What `init.luau` does:**
  - Waits up to 15 seconds for each ScreenGui with `WaitFor`. If one is missing, it warns with the expected path and disables only that screen.
  - Sets `ResetOnSpawn = false` so screens survive respawns.
  - Creates each screen, tracks which are open, closes other modals when a modal opens, and destroys everything in `Destroy`.
- **API for other systems:** `UIController:Open(name)`, `UIController:Close(name)` and `UIController:IsOpen(name)`.
- **Screen contract** (`Types.luau`):
  - A screen module returns `{ new = function(context, gui): Screen }`.
  - The screen object has `Modal`, `StartsOpen`, `Open`, `Close` and `Destroy`.
  - Non-modal screens (HUD, notifications) can be open together. Opening a modal screen (shop, settings) closes other modals.
  - Screens may hold state because they are created objects. They own their connections through a Trove and clean them up in `Destroy`.
- **What screens receive:** `context.Controllers` (the controller registry), `context.Open` and `context.Close`. Screens never require each other; open another screen through `context.Open`.
- **What screens may do:** send requests through `Packets` and display player data through `context.Controllers.DataController` (see `.agents/skills/roblox-data/SKILL.md`). They never decide outcomes.
- **Finding elements:** look up authored elements by name inside `gui` and check their class (`IsA`) before use, so a renamed element fails visibly rather than erroring.
- **Complex client logic** such as a placement preview goes in its own controller, which the screen calls through `context.Controllers`.

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Trove = require(ReplicatedStorage.Packages.Trove)
local Types = require(script.Parent.Parent.Types)

local Hud = {}

function Hud.new(context: Types.Context, gui: ScreenGui): Types.Screen
	local trove = Trove.new()

	trove:Add(context.Controllers.DataController:Observe({ "Cash" }, function(cash: any)
		local label = gui:FindFirstChild("Cash", true)
		if label and label:IsA("TextLabel") then
			label.Text = if type(cash) == "number" then string.format("%d", cash) else "..."
		end
	end))

	return {
		Modal = false,
		StartsOpen = true,
		Open = function(_self: Types.Screen)
			gui.Enabled = true
		end,
		Close = function(_self: Types.Screen)
			gui.Enabled = false
		end,
		Destroy = function(_self: Types.Screen)
			trove:Destroy()
		end,
	}
end

return Hud
```
