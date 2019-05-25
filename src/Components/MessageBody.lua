local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	layoutOrder = t.integer
})

local function MessageBody(props)
	assert(Props(props))

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("TextLabel", {
			Text = props.message.body,
			Size = props.size,
			LayoutOrder = props.layoutOrder,
			Font = Styles.Font,
			BackgroundTransparency = 1,
			TextSize = Styles.TextSize,
			TextWrapped = true,
			TextColor3 = theme:GetColor("MainText"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
		})
	end)
end

return MessageBody
