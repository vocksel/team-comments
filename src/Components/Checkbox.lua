local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local useTheme = require(TeamComments.Hooks.useTheme)

local validateProps = t.interface({
	isChecked = t.boolean,
	onClick = t.optional(t.callback),
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
})

local function Checkbox(props, hooks)
	assert(validateProps(props))

	local state = props.isChecked and Enum.StudioStyleGuideModifier.Selected or Enum.StudioStyleGuideModifier.Default
	local theme = useTheme(hooks)

	return Roact.createElement("ImageButton", {
		Size = UDim2.new(0, 20, 0, 20),
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBackground, state),
		BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBorder, state),
		AutoButtonColor = false,
		Position = props.position,
		AnchorPoint = props.anchorPoint,
		LayoutOrder = props.LayoutOrder,
		[Roact.Event.MouseButton1Click] = props.onClick,
	}, {
		Check = Roact.createElement("ImageLabel", {
			Size = UDim2.new(0, 16, 0, 12),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Visible = props.isChecked == true,
			ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator, state),
			Image = "rbxassetid://2617163557",
		}),
	})
end

return Hooks.new(Roact)(Checkbox)
