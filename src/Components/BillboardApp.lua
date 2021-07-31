local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local MessageContext = require(TeamComments.Context.MessageContext)
local useCameraDistance = require(TeamComments.Hooks.useCameraDistance)
local CommentIcon = require(script.Parent.CommentIcon)

local function BillboardApp(_props, hooks)
	local messages = hooks.useContext(MessageContext)

	local children = {}

	for _, message in pairs(messages.getMessages()) do
		local messagePart = messages.getMessagePart(message.id)
		local distance = useCameraDistance(hooks, messagePart.Position)

		local function onActivated()
			print("activated")
		end

		children[message.id] = Roact.createElement("BillboardGui", {
			MaxDistance = math.huge,
			Size = UDim2.fromOffset(400, 200),
			LightInfluence = 0,
			Adornee = messagePart,
			Active = true,
		}, {
			CommentIcon = Roact.createElement(CommentIcon, {
				isShown = distance < 40,
				onActivated = onActivated,
			}),
		})
	end

	return Roact.createElement("Folder", {}, children)
end

return Hooks.new(Roact)(BillboardApp)
