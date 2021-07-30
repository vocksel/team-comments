local CollectionService = game:GetService("CollectionService")

local Roact = require(script.Parent.Parent.Packages.Roact)
local Immutable = require(script.Parent.Parent.Lib.Immutable)

local MessageContext = Roact.createContext()

local MessageProvider = Roact.Component:extend("MessageProvider")

function MessageProvider:init(initialProps)
    self.state = {
        messages = {}
    }

    self.getOrCreateBaseStorage = function()
        local storage = CollectionService:GetTagged(initialProps.storageTag)[1]

        if not storage then
            storage = Instance.new("Folder")
            storage.Name = "TeamComments"
            storage.Parent = workspace

            CollectionService:AddTag(storage, initialProps.storageTag)
        end

        return storage
    end

    self.createMessagePart = function(messageId, userId, text, createdAt, position)
        local part = Instance.new("Part")
        part.Name = ("TeamComment_%i"):format(createdAt)
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

        part:SetAttribute("Id", messageId)
        part:SetAttribute("UserId", userId)
        part:SetAttribute("Text", text)
        part:SetAttribute("CreatedAt", createdAt)

        CollectionService:AddTag(part, initialProps.messageTag)

        return part
    end

    self.createMessageState = function(messageId, userId, text, createdAt)
        self:setState(function(prevState)
            -- Skip over any messages that already exist in the state. This is
            -- so when the user sends a message that it doesn't get added a
            -- second time from CollectionService adding messages to the state
            -- when new message parts are added.
            if prevState.messages[messageId] then
                return
            end

            local message = {
                id = messageId,
                userId = userId,
                text = text,
                createdAt = createdAt,
            }

            return {
                messages = Immutable.join(prevState.messages, {
                    [messageId] = message
                })
            }
        end)
    end

    self.createMessage = function(messageId, userId, text, createdAt, position)
        self.createMessageState(messageId, userId, text, createdAt)
        self.createMessagePart(messageId, userId, text, createdAt, position)
    end

    self.deleteMessage = function(messageId)
        self:setState(function(state)
            return {
                messages =  Immutable.join(state.messages, {
                    [messageId] = Roact.None
                })
            }
        end)
    end

    self.setMessageText = function(messageId, newText)
        self:setState(function(state)
            local newMessage = Immutable.join(state.messages[messageId], {
                text = newText
            })

            return {
                messages = Immutable.join(state.messages, {
                    [messageId] = newMessage
                })
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
end

function MessageProvider:render()
    return Roact.createElement(MessageContext.Provider, {
        value = {
            messages = self.state.messages,
            createMessage = self.createMessage,
            deleteMessage = self.deleteMessage,
            setMessageText = self.setMessageText,
            getOrderedMessages = self.getOrderedMessages,
        }
    }, self.props[Roact.Children])
end

function MessageProvider:didMount()
    local function onAdded(messagePart: Part)
        local attr = messagePart:GetAttributes()
        self.createMessageState(attr.Id, attr.UserId, attr.Text, attr.CreatedAt)
    end

    local function onRemoved(messagePart)
        local messageId = messagePart:GetAttribute("Id")
        self.deleteMessage(messageId)
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
