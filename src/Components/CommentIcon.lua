local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local Flipper = require(TeamComments.Packages.Flipper)
local t = require(TeamComments.Packages.t)

local SPRING_CONFIG = {
	frequency = 1.2,
	dampingRatio = 1,
}

local validateProps = t.interface({
	isShown = t.optional(t.boolean),
	onActivated = t.optional(t.callback),
})

local function CommentIcon(props, hooks)
	assert(validateProps(props))

	local scale, setScale = hooks.useState(1)

	local motor = hooks.useMemo(function()
		return Flipper.SingleMotor.new(scale)
	end, {})

	hooks.useEffect(function()
		motor:onStep(setScale)

		return function()
			motor:destroy()
		end
	end, {})

	hooks.useEffect(function()
		motor:setGoal(Flipper.Spring.new(props.isShown and 1 or 0.2, SPRING_CONFIG))
	end, {
		props.isShown,
	})

	return Roact.createElement("ImageButton", {
		-- Image = ""
		Size = UDim2.fromOffset(48, 48),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		[Roact.Event.Activated] = props.onActivated,
	}, {
		Scale = Roact.createElement("UIScale", {
			Scale = scale,
		}),
	})
end

return Hooks.new(Roact)(CommentIcon)
