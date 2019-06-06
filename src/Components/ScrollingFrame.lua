local Roact = require(script.Parent.Parent.Lib.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local ListBox = require(script.Parent.ListBox)

local ScrollingFrame = Roact.Component:extend("ScrollingFrame")

function ScrollingFrame:init()
	self.height, self.setHeight = Roact.createBinding(0)

	self.mapHeight = function(height)
		return UDim2.new(0, 0, 0, height)
	end
end

function ScrollingFrame:render()
	return StudioThemeAccessor.withTheme(function(theme, themeEnum)
		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = theme:GetColor("MainBackground"),
			BorderColor3 = theme:GetColor("Border"),
			LayoutOrder = self.props.layoutOrder,
			ClipsDescendants = true,
		}, {
			BarBackground = Roact.createElement("Frame", {
				BackgroundColor3 = theme:GetColor("ScrollBarBackground"),
				Size = UDim2.new(0, 12, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				BorderSizePixel = 0,
			}),
			ScrollingFrame = Roact.createElement("ScrollingFrame", {
				Size = UDim2.new(1, -2, 1, 0),
				CanvasSize = self.height:map(self.mapHeight),
				VerticalScrollBarInset = Enum.ScrollBarInset.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ScrollBarThickness = 8,
				TopImage = "rbxasset://textures/StudioToolbox/ScrollBarTop.png",
				MidImage = "rbxasset://textures/StudioToolbox/ScrollBarMiddle.png",
				BottomImage = "rbxasset://textures/StudioToolbox/ScrollBarBottom.png",
				ScrollBarImageColor3 = themeEnum == Enum.UITheme.Dark and Color3.fromRGB(85, 85, 85)
					or Color3.fromRGB(245, 245, 245),--theme:GetColor("ScrollBar"),
			}, {
				List = Roact.createElement(ListBox, {
					onHeightChange = self.setHeight,
				}, self.props[Roact.Children])
			})
		})
	end)
end

return ScrollingFrame
