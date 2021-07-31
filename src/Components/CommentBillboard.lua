local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local types = require(TeamComments.Types)
local useCameraDistance = require(TeamComments.Hooks.useCameraDistance)
local Comment = require(script.Parent.Comment)

local validateProps = t.interface({
	messagePart = t.instance("Part"),
	message = types.IMessage,
})

local function CommentBillboard(props, hooks)
	assert(validateProps(props))

	local distance = useCameraDistance(hooks, props.messagePart.Position)

	local onActivated = hooks.useCallback(function()
		print("activated")
	end, {})

	return Roact.createElement("BillboardGui", {
		MaxDistance = math.huge,
		Size = UDim2.fromOffset(400, 200),
		LightInfluence = 0,
		Adornee = props.messagePart,
		Active = true,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
		}),

		Comment = distance <= 100 and Roact.createElement(Comment, {
			message = props.message,
		}),

		Bubble = distance > 100 and Roact.createElement("ImageButton", {
			Size = UDim2.fromOffset(64, 64),
			[Roact.Event.Activated] = onActivated,
		}),
	})
end

return Hooks.new(Roact)(CommentBillboard)
