local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local Colors = require(script.Parent.Parent.Colors)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local Padding = require(script.Parent.Padding)
local Avatar = require(script.Parent.Avatar)

local Props = t.interface({
	height = t.integer,
	layoutOrder = t.integer,
	message = Types.IMessage
})

local function CondensedMessage(props)
	assert(Props(props))

	return StudioThemeAccessor.withTheme(function(theme)
		local isEven = props.layoutOrder % 2 == 0
		local themeBackgroundColor = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
		local backgroundColor = isEven and themeBackgroundColor or Colors.darken(themeBackgroundColor, 20)

		return Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, props.height),
			BackgroundColor3 = backgroundColor,
			BorderSizePixel = 0,
			LayoutOrder = props.layoutOrder,
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
			}),

			Padding = Roact.createElement(Padding),

			Avatar = Roact.createElement(Avatar, {
				userId = props.message.authorId,
				sizeConstraint = Enum.SizeConstraint.RelativeYY,
				maskColor = backgroundColor,
				layoutOrder = 1,
			}),

			Main = Roact.createElement("Frame", {
				-- The X offset is to account for the avatar
				Size = UDim2.new(1, -props.height, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
			}, {
				Layout = Roact.createElement("UIListLayout"),

				-- debug
				Time = Roact.createElement("TextLabel", {
					Text = props.message.time,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
				})
			})
		})
	end)
end

return CondensedMessage
