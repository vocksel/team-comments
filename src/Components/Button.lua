local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Styles = require(script.Parent.Parent.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

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
			TextSize = Styles.TextSize-2,
			Font = Styles.HeaderFont,
			LayoutOrder = props.layoutOrder,
			TextColor3 = theme:GetColor("MainText"),
			BackgroundColor3 = theme:GetColor("Button"),
			Size = props.size or UDim2.new(0, 48, 1, 0),
			[Roact.Event.MouseButton1Click] = props.onClick
		})
	end)
end

return Button
