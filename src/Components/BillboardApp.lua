local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local MessageContext = require(TeamComments.Context.MessageContext)
local CommentBillboard = require(script.Parent.CommentBillboard)

local function BillboardApp(_props, hooks)
	local messages = hooks.useContext(MessageContext)

	local children = {}

	for _, message in pairs(messages.getMessages()) do
		children[message.id] = Roact.createElement(CommentBillboard, {
			messagePart = messages.getMessagePart(message.id),
			message = message,
		})
	end

	return Roact.createElement("Folder", {}, children)
end

return Hooks.new(Roact)(BillboardApp)
