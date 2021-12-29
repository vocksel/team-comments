local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local styles = require(TeamComments.styles)
local useTheme = require(TeamComments.Hooks.useTheme)

local validateProps = t.interface({
	text = t.string,
	LayoutOrder = t.interger,
	size = t.optional(t.UDim2),
	onClick = t.callback,
})

local function Button(props, hooks)
	assert(validateProps(props))

	local theme = useTheme(hooks)

	return Roact.createElement("TextButton", {
		Text = props.text,
		TextSize = styles.Text.TextSize - 2,
		Font = styles.Header.Font,
		LayoutOrder = props.LayoutOrder,
		TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button),
		Size = props.size or UDim2.new(0, 48, 1, 0),
		[Roact.Event.MouseButton1Click] = props.onClick,
	})
end

return Hooks.new(Roact)(Button)
