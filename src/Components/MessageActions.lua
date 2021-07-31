local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local MessageContext = require(TeamComments.Context.MessageContext)
local Button = require(script.Parent.Button)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	LayoutOrder = t.integer,
})

local function MessageActions(props, hooks)
	assert(Props(props))

	local messages = hooks.useContext(MessageContext)

	return Roact.createElement("Frame", {
		Size = props.size,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = Styles.Padding,
		}),

		View = Roact.createElement(Button, {
			text = "Focus",
			LayoutOrder = 1,
			onClick = function()
				messages.focusMessagePart(props.message.id)
			end,
		}),

		-- Edit = Roact.createElement(Button, {
		-- 	text = "Edit",
		-- 	LayoutOrder = 1,
		-- 	onClick = function()
		-- 		print("click :)")
		-- 	end
		-- }),

		Resolve = Roact.createElement(Button, {
			text = "Resolve",
			LayoutOrder = 2,
			onClick = function()
				messages.deleteMessage(props.message.id)
			end,
		}),
	})
end

return Hooks.new(Roact)(MessageActions)
