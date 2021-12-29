local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local Flipper = require(TeamComments.Packages.Flipper)
local Llama = require(TeamComments.Packages.Llama)
local t = require(TeamComments.Packages.t)
local types = require(TeamComments.Types)
local useTheme = require(TeamComments.Hooks.useTheme)
local useAvatar = require(TeamComments.Hooks.useAvatar)

local SPRING_CONFIG = {
	frequency = 1.2,
	dampingRatio = 1,
}

local validateProps = t.interface({
	message = types.Message,
	isShown = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
})

local defaultProps = {
	isShown = true,
}

local function CommentBubble(props, hooks)
	props = Llama.Dictionary.join(defaultProps, props)

	assert(validateProps(props))

	local scale, setScale = hooks.useState(1)
	local transparency, setTransparency = hooks.useState(1)
	local theme = useTheme(hooks)
	local avatar = useAvatar(hooks, props.message.userId)

	local motor = hooks.useMemo(function()
		return Flipper.SingleMotor.new(scale)
	end, {})

	hooks.useEffect(function()
		motor:onStep(function(value)
			setScale(value)
			setTransparency(1 - value)
		end)

		return function()
			motor:destroy()
		end
	end, {})

	hooks.useEffect(function()
		motor:setGoal(Flipper.Spring.new(props.isShown and 1 or 0.3, SPRING_CONFIG))
	end, {
		props.isShown,
	})

	return Roact.createElement("ImageButton", {
		Image = avatar,
		ImageTransparency = transparency,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BackgroundTransparency = transparency,
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		[Roact.Event.Activated] = props.onActivated,
	}, {
		Corner = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0),
		}),

		Scale = Roact.createElement("UIScale", {
			Scale = scale,
		}),

		AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),
	})
end

return Hooks.new(Roact)(CommentBubble)
