local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local MessageContext = require(TeamComments.Context.MessageContext)
local useCameraDistance = require(TeamComments.Hooks.useCameraDistance)
local CommentBubble = require(script.Parent.CommentBubble)

local validateProps = t.interface({
	widget = t.instance("DockWidgetPluginGui"),
})

local function BillboardApp(props, hooks)
	assert(validateProps(props))

	local messages = hooks.useContext(MessageContext)
	local children = {}

	for _, message in pairs(messages.getComments()) do
		local messagePart = messages.getAdornee(message.id)

		local function onActivated()
			props.widget.Enabled = true
			messages.focusAdornee(message.id)
			messages.setSelectedMessage(message.id)
		end

		if messagePart then
			local distance = useCameraDistance(hooks, messagePart.Position)

			children[message.id] = Roact.createElement("BillboardGui", {
				MaxDistance = math.huge,
				Size = UDim2.fromScale(4, 4),
				LightInfluence = 0,
				Adornee = messagePart,
				Active = true,
			}, {
				CommentBubble = Roact.createElement(CommentBubble, {
					isShown = distance < 60,
					message = message,
					onActivated = onActivated,
				}),
			})
		end
	end

	return Roact.createElement("Folder", {}, children)
end

return Hooks.new(Roact)(BillboardApp)
