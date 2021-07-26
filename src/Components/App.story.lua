local CollectionService = game:GetService("CollectionService")

local Roact = require(script.Parent.Parent.Packages.Roact)
local Rodux = require(script.Parent.Parent.Packages.Rodux)
local RoactRodux = require(script.Parent.Parent.Packages.RoactRodux)
local App = require(script.Parent.App)
local Reducer = require(script.Parent.Parent.Reducer)
local Messages = require(script.Parent.Parent.Messages)
local CreateMessage = require(script.Parent.Parent.Actions.CreateMessage)
local SetMessageBody = require(script.Parent.Parent.Actions.SetMessageBody)
local DeleteMessage = require(script.Parent.Parent.Actions.DeleteMessage)
local Config = require(script.Parent.Parent.Config)

return function(target)
    local store = Rodux.Store.new(Reducer)

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

    local function setupInitialState()
        for _, messagePart in pairs(CollectionService:GetTagged(Config.TAG_NAME)) do
            onMessagePartAdded(messagePart)
        end

        CollectionService:GetInstanceAddedSignal(Config.TAG_NAME):Connect(onMessagePartAdded)

        CollectionService:GetInstanceRemovedSignal(Config.TAG_NAME):Connect(onMessagePartRemoved)
    end

    setupInitialState()

    local root = Roact.createElement(RoactRodux.StoreProvider, {
		store = store
	}, {
		App = Roact.createElement(App, {
            userId = "1343930"
        })
	})

    local handle = Roact.mount(root, target, "App")

    return function()
        Roact.unmount(handle)
    end
end
