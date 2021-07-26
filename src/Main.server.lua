
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
local CollectionService = game:GetService("CollectionService")

local Roact = require(script.Parent.Packages.Roact)
local Rodux = require(script.Parent.Packages.Rodux)
local StoreProvider = require(script.Parent.Packages.RoactRodux).StoreProvider
local Messages = require(script.Parent.Messages)
local Reducer = require(script.Parent.Reducer)
local Config = require(script.Parent.Config)
local App = require(script.Parent.Components.App)
local WorldMessages = require(script.Parent.Components.WorldMessages)
local CreateMessage = require(script.Parent.Lib.Actions.CreateMessage)
local DeleteMessage = require(script.Parent.Lib.Actions.DeleteMessage)
local SetMessageBody = require(script.Parent.Lib.Actions.SetMessageBody)

local toolbar = plugin:CreateToolbar(Config.DISPLAY_NAME)
local store = Rodux.Store.new(Reducer)

local function createWidget()
	local info = DockWidgetPluginGuiInfo.new(
		Enum.InitialDockState.Left,
		true
	)
	local widgetName = Config.PLUGIN_NAME.."App"
	local widget = plugin:CreateDockWidgetPluginGui(widgetName, info)

	widget.Name = widgetName
	widget.Title = Config.DISPLAY_NAME
	widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return widget
end

local function onMessagePartAdded(messagePart)
	Messages.runIfValid(messagePart, function()
		store:dispatch(CreateMessage(messagePart.Id.Value, messagePart.AuthorId.Value, messagePart.Time.Value))
		store:dispatch(SetMessageBody(messagePart.Id.Value, messagePart.Body.Value))

		-- TODO: Listen for changes to the message's Value instances and
		-- reconstruct if anything is edited manually.
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

local function createButtons(widget)
	local toggleAppView = toolbar:CreateButton(
		Config.DISPLAY_NAME,
		"View and edit the list of messages",
		""
	)

	toggleAppView.Click:Connect(function()
		widget.Enabled = not widget.Enabled
	end)

	widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		toggleAppView:SetActive(widget.Enabled)
	end)
end

local function createInterface(widget)
	local billboardsRoot = Roact.createElement(StoreProvider, {
		store = store
	}, {
		Roact.createElement(WorldMessages)
	})

	Roact.mount(billboardsRoot, CoreGui, Config.PLUGIN_NAME)

	local appRoot = Roact.createElement(StoreProvider, {
		store = store,
	}, {
		Roact.createElement(App, {
			plugin = plugin
		})
	})

	Roact.mount(appRoot, widget, "App")
end

local widget = createWidget()

setupInitialState()
createButtons(widget)
createInterface(widget)

print("loaded!")
