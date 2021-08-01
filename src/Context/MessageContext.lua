local TeamComments = script:FindFirstAncestor("TeamComments")

local ChangeHistoryService = game:GetService("ChangeHistoryService")
local CollectionService = game:GetService("CollectionService")

local Roact = require(TeamComments.Packages.Roact)
local t = require(TeamComments.Packages.t)
local Immutable = require(TeamComments.Lib.Immutable)
local Config = require(TeamComments.Config)

local MessageContext = Roact.createContext()

local MessageProvider = Roact.Component:extend("MessageProvider")

MessageProvider.validateProps = t.interface({
	messageTag = t.optional(t.string),
	responseTag = t.optional(t.string),
	storageTag = t.optional(t.string),
})

MessageProvider.defaultProps = {
	messageTag = Config.TAG_NAME,
	responseTag = Config.RESPONSE_TAG_NAME,
	storageTag = Config.STORAGE_TAG_NAME,
}

function MessageProvider:init(initialProps)
	self.state = {
		messages = {},
	}

	self.getOrCreateBaseStorage = function()
		local storage = CollectionService:GetTagged(self.props.storageTag)[1]

		if not storage then
			storage = Instance.new("Folder")
			storage.Name = "TeamComments"
			storage.Parent = workspace

			CollectionService:AddTag(storage, self.props.storageTag)
		end

		return storage
	end

	self.saveMessageToInstance = function(message, instance)
		local keys = {
			"id",
			"userId",
			"text",
			"createdAt",
		}

		for _, key in ipairs(keys) do
			instance:SetAttribute(key, message[key])
		end
	end

	self.loadMessageFromInstance = function(instance)
		local message = {
			id = "-1",
			userId = "-1",
			text = "",
			createdAt = 0,
			responses = {},
		}

		for key, value in pairs(instance:GetAttributes()) do
			message[key] = value
		end

		return message
	end

	self.createMessagePart = function(message, position)
		local part = Instance.new("Part")
		part.Name = ("TeamComment_%i"):format(message.createdAt)
		part.Anchored = true
		part.Locked = true
		part.CanCollide = false
		part.CanTouch = false
		part.Transparency = 1
		-- Normally we would use Position, but this forces the Part to exist
		-- inside another, without being pushed up on top.
		part.CFrame = CFrame.new(position)
		part.Size = Vector3.new(0, 0, 0)
		part.Parent = self.getOrCreateBaseStorage()

		self.saveMessageToInstance(message, part)

		CollectionService:AddTag(part, initialProps.messageTag)

		return part
	end

	self.createResponseInstance = function(message)
		local messagePart = self.getMessagePart(message.id)
		local dialog = Instance.new("Dialog")
		dialog.Name = ("Response_%i"):format(message.createdAt)
		dialog.Parent = messagePart

		self.saveMessageToInstance(message, dialog)

		CollectionService:AddTag(dialog, initialProps.responseTag)

		return dialog
	end

	self.getMessagePart = function(messageId)
		for _, messagePart in pairs(CollectionService:GetTagged(self.props.messageTag)) do
			if messagePart:GetAttribute("id") == messageId then
				return messagePart
			end
		end
	end

	self.focusMessagePart = function(messageId)
		local messagePart = self.getMessagePart(messageId)

		if messagePart then
			local camera = workspace.CurrentCamera
			local orientation = camera.CFrame - camera.CFrame.p
			local newCFrame = CFrame.new(messagePart.Position) * orientation

			camera.Focus = messagePart.CFrame
			camera.CFrame = newCFrame * CFrame.new(-Config.PUSHBACK_FROM_FOCUS, 0, 0)
		end
	end

	self.createMessageState = function(message)
		self:setState(function(prevState)
			-- Skip over any messages that already exist in the state. This is
			-- so when the user sends a message that it doesn't get added a
			-- second time from CollectionService adding messages to the state
			-- when new message parts are added.
			if prevState.messages[message.id] then
				return
			end

			return {
				messages = Immutable.join(prevState.messages, {
					[message.id] = message,
				}),
			}
		end)
	end

	self.createMessage = function(message, position)
		-- Adding a message part triggers CollectionService, which in turn adds
		-- the message to the state. A bit roundabout, but it works well and
		-- solves some issues with trying to add state _then_ the part, and vice
		-- versa.
		self.createMessagePart(message, position)
	end

	self.deleteMessage = function(messageId)
		self:setState(function(state)
			return {
				messages = Immutable.set(state.messages, messageId, nil),
			}
		end)

		local messagePart = self.getMessagePart(messageId)

		if messagePart then
			ChangeHistoryService:SetWaypoint("Deleting message...")
			messagePart.Parent = nil
			ChangeHistoryService:SetWaypoint("Deleted message")
		end
	end

	self.setMessageText = function(messageId, newText)
		self:setState(function(state)
			local newMessage = Immutable.join(state.messages[messageId], {
				text = newText,
			})

			return {
				messages = Immutable.join(state.messages, {
					[messageId] = newMessage,
				}),
			}
		end)
	end

	-- Sorts the messages by the time they were created. Returns an array of
	-- each message in order from newest to oldest. This is used to display the
	-- list of messages in the plugin.
	self.getOrderedMessages = function()
		local messages = {}

		for _, message in pairs(self.state.messages) do
			table.insert(messages, message)
		end

		table.sort(messages, function(a, b)
			return a.createdAt > b.createdAt
		end)

		return messages
	end

	self.getMessages = function()
		return self.state.messages
	end
end

function MessageProvider:render()
	return Roact.createElement(MessageContext.Provider, {
		value = {
			getMessages = self.getMessages,
			createMessage = self.createMessage,
			deleteMessage = self.deleteMessage,
			setMessageText = self.setMessageText,
			getOrderedMessages = self.getOrderedMessages,
			getMessagePart = self.getMessagePart,
			focusMessagePart = self.focusMessagePart,
		},
	}, self.props[Roact.Children])
end

function MessageProvider:didMount()
	local function onAdded(messagePart: Part)
		local message = self.loadMessageFromInstance(messagePart)
		self.createMessageState(message)
	end

	local function onRemoved(messagePart)
		self.deleteMessage(messagePart:GetAttribute("id"))
	end

	for _, messagePart in ipairs(CollectionService:GetTagged(self.props.messageTag)) do
		onAdded(messagePart)
	end

	self.onAddedConn = CollectionService:GetInstanceAddedSignal(self.props.messageTag):Connect(onAdded)
	self.onRemovedConn = CollectionService:GetInstanceRemovedSignal(self.props.messageTag):Connect(onRemoved)
end

function MessageProvider:willUnmount()
	self.onAddedConn:Disconnect()
	self.onRemovedConn:Disconnect()
end

return {
	Consumer = MessageContext.Consumer,
	Provider = MessageProvider,
}
