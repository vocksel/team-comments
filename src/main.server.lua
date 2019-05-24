
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

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Roact = require(script.Parent.Roact)
local Rodux = require(script.Parent.Rodux)
local messages = require(script.Parent.messages)
local WorldMessage = require(script.Parent.components.WorldMessage)
local reducer = require(script.Parent.reducer)
local CreateMessage = require(script.Parent.actions.CreateMessage)
local SetMessageBody = require(script.Parent.actions.SetMessageBody)
local ToggleMessagesVisibility = require(script.Parent.actions.ToggleMessagesVisibility)

local toolbar = plugin:CreateToolbar("World Messages")
local userId = tostring(plugin:GetStudioUserId())
local store = Rodux.Store.new(reducer, nil, { Rodux.loggerMiddleware })

-- TODO: Replace buttons with just a widget. Will have add, visibility filter,
-- and full list of messages
local function createButtons()
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
		store:dispatch(CreateMessage(messageId, userId, os.time(), Vector3.new(20, 20, 20)))

		-- local p = messages.newMessagePart(client.UserId)
		-- p.Parent = workspace
		-- p.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.p)

		-- TODO: we need state so we can easily add, edit, and delete messages.
		--
		-- right now we have no way to add a new message to the roact hierarchy
		-- when the user adds a new billboard.
	end)

	toggleMessageVisibilityButton.Click:Connect(function()
		store:dispatch(ToggleMessagesVisibility())
	end)
end

local function createInterface()
	local children = {}

	for _, messagePart in pairs(messages.getAll()) do
		children[messagePart.Id.Value] = Roact.createElement(WorldMessage, {
			adornee = messagePart
		})
	end

	local tree = Roact.mount(
		Roact.createElement("Folder", {}, children),
		CoreGui,
		"WorldMessages"
	)

	plugin.Unloading:Connect(function()
		print("clean up")
		Roact.unmount(tree)
	end)
end

createButtons()
createInterface()

print("we in")
