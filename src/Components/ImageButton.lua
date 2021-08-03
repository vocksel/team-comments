local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local useTheme = require(TeamComments.Hooks.useTheme)

local validateProps = t.interface({
	Image = t.string,
	LayoutOrder = t.optional(t.number),
	onActivated = t.optional(t.callback),
})

local function ImageButton(props, hooks)
	assert(validateProps(props))

	local theme = useTheme(hooks)
	local isHovered, setIsHovered = hooks.useState(false)

	local onMouseEnter = hooks.useCallback(function()
		setIsHovered(true)
	end, {})

	local onMouseLeave = hooks.useCallback(function()
		setIsHovered(false)
	end, {})

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Image = props.Image,
		Active = true,
		Size = UDim2.fromOffset(24, 24),
		ImageColor3 = theme:GetColor(
			Enum.StudioStyleGuideColor.MainText,
			isHovered and Enum.StudioStyleGuideModifier.Hover or nil
		),
		BackgroundTransparency = 1,
		[Roact.Event.Activated] = props.onActivated,
		[Roact.Event.MouseEnter] = onMouseEnter,
		[Roact.Event.MouseLeave] = onMouseLeave,
	})
end

return Hooks.new(Roact)(ImageButton)
