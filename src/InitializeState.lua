local CollectionService = game:GetService("CollectionService")

local Messages = require(script.Parent.Messages)
local CreateMessage = require(script.Parent.Actions.CreateMessage)
local SetMessageBody = require(script.Parent.Actions.SetMessageBody)
local DeleteMessage = require(script.Parent.Actions.DeleteMessage)
local Config = require(script.Parent.Config)

local function initializeState(store)
    -- Setup the initial state. Should have a better way to create new messages
    -- that doesn't rely on the part being created first.
    local function onMessagePartAdded(messagePart)
        Messages.runIfValid(messagePart, function()
            store:dispatch(CreateMessage(messagePart.Id.Value, messagePart.AuthorId.Value, messagePart.Time.Value))
            store:dispatch(SetMessageBody(messagePart.Id.Value, messagePart.Body.Value))
        end)
    end

    local function onMessagePartRemoved(messagePart)
        Messages.runIfValid(messagePart, function()
            store:dispatch(DeleteMessage(messagePart.Id.Value))
        end)
    end

    for _, messagePart in pairs(CollectionService:GetTagged(Config.TAG_NAME)) do
        onMessagePartAdded(messagePart)
    end

    CollectionService:GetInstanceAddedSignal(Config.TAG_NAME):Connect(onMessagePartAdded)
    CollectionService:GetInstanceRemovedSignal(Config.TAG_NAME):Connect(onMessagePartRemoved)
end

return initializeState
