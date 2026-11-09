--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Vide = require(ReplicatedStorage.Packages.Vide)
local UIAssets = require(ReplicatedStorage.Config.UIAssets)

local create = Vide.create

export type Placement = {
	Name: string?,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	Rotation: number?,
	ZIndex: number?,
	Visible: (boolean | (() -> boolean))?,
}

export type ImageProps = Placement & {
	Asset: string,
	Width: number,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	Activated: (() -> ())?,
}

export type SliceProps = Placement & {
	Asset: string,
	Size: UDim2,
	SliceCenter: Rect,
	SliceScale: number,
}

local Image = {}

local function lookup(key: string): UIAssets.Asset
	local kind, name = string.match(key, "^(%a+):(.+)$")
	local group = if kind == "icon" then UIAssets.Icons elseif kind == "art" then UIAssets.Art else nil
	local asset = if group and name then group[name] else nil
	if not asset then
		error(`UIAssets has no asset {key}`)
	end
	return asset
end

local function fixed(class: "ImageLabel" | "ImageButton", props: ImageProps): any
	local asset = lookup(props.Asset)
	local height = math.round(props.Width / asset.Aspect)
	return create(class)({
		Name = props.Name or props.Asset,
		Image = asset.Id,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(props.Width, height),
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Rotation = props.Rotation,
		ZIndex = props.ZIndex,
		Visible = props.Visible,
		ImageColor3 = props.ImageColor3,
		ImageTransparency = props.ImageTransparency,
		Activated = props.Activated,
	})
end

function Image.Plain(props: ImageProps): ImageLabel
	return fixed("ImageLabel", props)
end

function Image.Button(props: ImageProps): ImageButton
	return fixed("ImageButton", props)
end

function Image.Slice(props: SliceProps): ImageLabel
	local asset = lookup(props.Asset)
	return create("ImageLabel")({
		Name = props.Name or props.Asset,
		Image = asset.Id,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = props.SliceCenter,
		SliceScale = props.SliceScale,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		Rotation = props.Rotation,
		ZIndex = props.ZIndex,
		Visible = props.Visible,
	})
end

return Image
