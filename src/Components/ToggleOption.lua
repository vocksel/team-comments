local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Checkbox = require(script.Parent.Checkbox)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Styles = require(script.Parent.Parent.Styles)

local Props = t.interface({
	text = t.string,
	isChecked = t.boolean,
	onClick = t.optional(t.callback),
	layoutOrder = t.optional(t.integer),
})

local function ToggleOption(props)
	assert(Props(props))

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, Styles.Padding)
		}),

		Checkbox = Roact.createElement(Checkbox, {
			layoutOrder = 1,
			isChecked = props.isChecked,
			onClick = props.onClick,
		}),

		Label = Roact.createElement(ThemedTextLabel, {
			LayoutOrder = 2,
			Text = props.text,
			Size = UDim2.new(1, 0, 1, 0),
			TextYAlignment = Enum.TextYAlignment.Center,
		}),
	})
end

return ToggleOption
