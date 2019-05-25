
-- Button
-- When pressed, prompt the user with a textbox
	-- Type inside, press enter to finish
	-- Unfocusing the textbox destroys it
-- Creates a new free floating billboard with the text
	-- Will also maintain metadata of who wrote the message, the date/time, and a little avatar.

-- List of all notes
	-- Clicking a note jumps to it in the game
	-- Let author edit
	-- Allow deleting notes

-- Have all WorldMessages stored as Parts in the workspace
-- When Studio boots up, create state out of all the WorldMessages' Value instances
-- 	When a new "WorldMessage" tagged Part is added, add a new one
-- 	When a WorldMessage tagged part is destroyed, remove it from the state
-- 	When a WorldMessage is removed from the state, remove it from the game as well (link via IDs)

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local Roact = require(script.Parent.Roact)
local Rodux = require(script.Parent.Rodux)
local RoactRodux = require(script.Parent.RoactRodux)
local messages = require(script.Parent.messages)
local WorldMessage = require(script.Parent.components.WorldMessage)
local reducer = require(script.Parent.reducer)
local new = require(script.Parent.new)
local config = require(script.Parent.config)
local CreateMessage = require(script.Parent.actions.CreateMessage)
local DeleteMessage = require(script.Parent.actions.DeleteMessage)
local SetMessageBody = require(script.Parent.actions.SetMessageBody)
local ToggleMessagesVisibility = require(script.Parent.actions.ToggleMessagesVisibility)

local toolbar = plugin:CreateToolbar("World Messages")
local clientId = tostring(plugin:GetStudioUserId())
local store = Rodux.Store.new(reducer, nil, { Rodux.loggerMiddleware })

local function onMessagePartAdded(messagePart)
	messages.runIfValid(messagePart, function()
		store:dispatch(CreateMessage(messagePart.Id.Value, messagePart.AuthorId.Value, messagePart.Time.Value))
		store:dispatch(SetMessageBody(messagePart.Id.Value, messagePart.Body.Value))
	end)
end

local function onMessagePartRemoved(messagePart)
	messages.runIfValid(messagePart, function()
		print("deleted")
		store:dispatch(DeleteMessage(messagePart.Id.Value))
	end)
end

local function setupInitialState()
	for _, messagePart in pairs(CollectionService:GetTagged(config.TAG_NAME)) do
		print(messagePart:GetFullName())
		onMessagePartAdded(messagePart)
	end

	CollectionService:GetInstanceAddedSignal(config.TAG_NAME):Connect(onMessagePartAdded)

	CollectionService:GetInstanceRemovedSignal(config.TAG_NAME):Connect(onMessagePartRemoved)
end

local function createMessagePart(messageId, userId, position)
	local messagePart = new("Part", {
		Name = "WorldMessage",
		Anchored = true,
		Locked = true,
		CanCollide = false,
		Transparency = 1,
		-- Normally we would use Position, but this forces the Part to exist
		-- inside another, without being pushed up on top.
		CFrame = CFrame.new(position),
		Size = Vector3.new(0, 0, 0),
		Parent = workspace
	}, {
		new("StringValue", { Name = "Id", Value = messageId }),
		new("StringValue", { Name = "AuthorId", Value = userId, }),
		new("StringValue", { Name = "Body" }),
		new("NumberValue", { Name = "Time", Value = os.time() }),
	})

	CollectionService:AddTag(messagePart, config.TAG_NAME)

	return messagePart
end

-- TODO: Replace buttons with just a widget. Will have add, visibility filter,
-- and full list of messages
local function createButtons()
	-- TODO: Create actions for the buttons so that we can set keybinds for
	-- them. Like Ctrl+Alt+M in Google Docs.
	local newMessageButton = toolbar:CreateButton(
		"New message",
		"Creates a new message in the world for others to read",
		""
	)

	local toggleMessageVisibilityButton = toolbar:CreateButton(
		"Toggle visibility",
		"Shows or hides all of the messages in the world",
		""
	)

	newMessageButton.Click:Connect(function()
		local messageId = HttpService:GenerateGUID()

		-- TODO: Make the position about 5 studs in front of the user's camera
		-- so it's easier to author messages. Also, the 5 studs will be the max.
		-- If there's anything in the way, push it closer (ray cast to check)
		local position = workspace.CurrentCamera.CFrame.p

		createMessagePart(messageId, clientId, position)

		-- local p = messages.newMessagePart(userId)
		-- p.Parent = workspace
		-- p.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p)
	end)

	toggleMessageVisibilityButton.Click:Connect(function()
		store:dispatch(ToggleMessagesVisibility())
	end)
end

local function createInterface()
	-- TODO: re add UI stuff after unfucking the state
end

setupInitialState()
createButtons()
createInterface()

print("we in")
