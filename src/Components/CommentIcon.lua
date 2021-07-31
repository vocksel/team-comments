local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local Flipper = require(TeamComments.Packages.Flipper)
local Immutable = require(TeamComments.Lib.Immutable)
local assets = require(TeamComments.Assets)
local t = require(TeamComments.Packages.t)
local types = require(TeamComments.Types)
local useTheme = require(TeamComments.Hooks.useTheme)

local SPRING_CONFIG = {
	frequency = 1.2,
	dampingRatio = 1,
}

local validateProps = t.interface({
	message = types.IMessage,
	isShown = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
})

local defaultProps = {
	isShown = true,
}

local BUTTON_SIZE = 64

local function CommentIcon(props, hooks)
	props = Immutable.join(defaultProps, props)
	assert(validateProps(props))

	local scale, setScale = hooks.useState(1)
	local transparency, setTransparency = hooks.useState(1)
	local theme = useTheme(hooks)

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
		motor:setGoal(Flipper.Spring.new(props.isShown and 1 or 0.2, SPRING_CONFIG))
	end, {
		props.isShown,
	})

	return Roact.createElement("Frame", {
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BackgroundTransparency = transparency,
		Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
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

		Icon = Roact.createElement("ImageButton", {
			Image = assets.CommentBubble,
			ImageTransparency = transparency,
			ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(BUTTON_SIZE - 24, BUTTON_SIZE - 24),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			[Roact.Event.Activated] = props.onActivated,
		}),
	})
end

return Hooks.new(Roact)(CommentIcon)
