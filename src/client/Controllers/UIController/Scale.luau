--!strict

local Scale = {}

local MinScale = 0.6

local function positive(value: unknown, fallback: number): number
	if type(value) == "number" and value > 0 then
		return value
	end
	return fallback
end

function Scale.FitRoot(root: GuiObject, viewport: Vector2)
	local fitScale = root:FindFirstChild("FitScale")
	local designWidth = root:GetAttribute("DesignW")
	local designHeight = root:GetAttribute("DesignH")
	if
		not fitScale
		or not fitScale:IsA("UIScale")
		or type(designWidth) ~= "number"
		or type(designHeight) ~= "number"
		or designWidth <= 0
		or designHeight <= 0
		or viewport.X < 2
		or viewport.Y < 2
	then
		return
	end
	local safeWidth = positive(root:GetAttribute("SafeW"), designWidth)
	local safeHeight = positive(root:GetAttribute("SafeH"), designHeight)
	local stageFit = math.min(viewport.X / designWidth, viewport.Y / designHeight)
	local safeFit = math.min(viewport.X / safeWidth, viewport.Y / safeHeight)
	local scale = math.min(safeFit, math.max(stageFit, MinScale))
	root.Size = UDim2.fromOffset(viewport.X / scale, viewport.Y / scale)
	fitScale.Scale = scale
end

function Scale.Fit(gui: ScreenGui)
	local root = gui:FindFirstChild("Root")
	if root and root:IsA("GuiObject") then
		Scale.FitRoot(root, gui.AbsoluteSize)
	end
end

return Scale
