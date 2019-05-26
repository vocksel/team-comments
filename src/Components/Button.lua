local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Styles = require(script.Parent.Parent.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local Padding = require(script.Parent.Padding)

local Props = t.interface({
	text = t.string,
	layoutOrder = t.interger,
	size = t.optional(t.UDim2),
	onClick = t.callback,
})

local function Button(props)
	assert(Props(props))

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("TextButton", {
			Text = props.text,
			TextSize = Styles.TextSize,
			Font = Styles.HeaderFont,
			LayoutOrder = props.layoutOrder,
			TextColor3 = theme:GetColor("MainText"),
			BackgroundColor3 = theme:GetColor("Button"),
			Size = props.size or UDim2.new(0, 64, 0, 24),
			[Roact.Event.MouseButton1Click] = props.onClick
		}, {
			Padding = Roact.createElement(Padding)
		})
	end)
end

return Button
