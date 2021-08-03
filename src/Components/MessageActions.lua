local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local assets = require(TeamComments.Assets)
local MessageContext = require(TeamComments.Context.MessageContext)
local ImageButton = require(script.Parent.ImageButton)

local validateProps = t.interface({
	message = Types.Message,
	size = t.UDim2,
	LayoutOrder = t.integer,
})

local function MessageActions(props, hooks)
	assert(validateProps(props))

	local messages = hooks.useContext(MessageContext)

	return Roact.createElement("Frame", {
		Size = props.size,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			Padding = Styles.Padding,
		}),

		View = Roact.createElement(ImageButton, {
			LayoutOrder = 1,
			Image = assets.Focus,
			onActivated = function()
				messages.focusAdornee(props.message.id)
			end,
		}),

		Resolve = Roact.createElement(ImageButton, {
			LayoutOrder = 2,
			Image = assets.Delete,
			onActivated = function()
				messages.deleteMessage(props.message.id)
			end,
		}),

		Reply = Roact.createElement(ImageButton, {
			LayoutOrder = 3,
			Image = assets.Reply,
			onActivated = function()
				messages.setSelectedMessage(props.message.id)
			end,
		}),
	})
end

return Hooks.new(Roact)(MessageActions)
