--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vide = require(ReplicatedStorage.Packages.Vide)
local Scale = require(script.Parent.Parent.Scale)

return function(root: Frame, target: GuiObject): Frame
	local function fit()
		Scale.FitRoot(root, target.AbsoluteSize)
	end
	local connection = target:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
	Vide.cleanup(function()
		connection:Disconnect()
	end)
	fit()
	return root
end
