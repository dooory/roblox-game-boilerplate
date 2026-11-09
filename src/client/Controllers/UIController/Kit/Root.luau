--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vide = require(ReplicatedStorage.Packages.Vide)

local create = Vide.create

local DesignWidth = 1920
local DesignHeight = 1080

return function(children: { Instance }, safe: Vector2?): Frame
	local root = create("Frame")({
		Name = "Root",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(DesignWidth, DesignHeight),
		Vide.action(function(instance: Instance)
			instance:SetAttribute("DesignW", DesignWidth)
			instance:SetAttribute("DesignH", DesignHeight)
			if safe then
				instance:SetAttribute("SafeW", safe.X)
				instance:SetAttribute("SafeH", safe.Y)
			end
		end),
		create("UIScale")({ Name = "FitScale" }),
	})
	for _, child in children do
		child.Parent = root
	end
	return root
end
