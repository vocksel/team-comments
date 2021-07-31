local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local t = require(TeamComments.Packages.t)
local Immutable = require(TeamComments.Lib.Immutable)
local Checkbox = require(script.Parent.Checkbox)
local Styles = require(TeamComments.Styles)
local useTheme = require(TeamComments.Hooks.useTheme)

local Props = t.interface({
	text = t.string,
	isChecked = t.boolean,
	onClick = t.optional(t.callback),
	LayoutOrder = t.optional(t.integer),
})

local function ToggleOption(props, hooks)
	assert(Props(props))

	local theme = useTheme(hooks)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = Styles.Padding,
		}),

		Checkbox = Roact.createElement(Checkbox, {
			LayoutOrder = 1,
			isChecked = props.isChecked,
			onClick = props.onClick,
		}),

		Label = Roact.createElement(
			"TextLabel",
			Immutable.join(Styles.Text, {
				LayoutOrder = 2,
				Text = props.text,
				TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
				Size = UDim2.new(1, 0, 1, 0),
				TextYAlignment = Enum.TextYAlignment.Center,
			})
		),
	})
end

return ToggleOption
