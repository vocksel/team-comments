
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

-- Have all TeamComments stored as Parts in the workspace
-- When Studio boots up, create state out of all the TeamComments' Value instances
-- 	When a new "TeamComment" tagged Part is added, add a new one
-- 	When a TeamComment tagged part is destroyed, remove it from the state
-- 	When a TeamComment is removed from the state, remove it from the game as well (link via IDs)

local CoreGui = game:GetService("CoreGui")

local Roact = require(script.Parent.Packages.Roact)
local Config = require(script.Parent.Config)
local PluginApp = require(script.Parent.Components.PluginApp)
local BillboardApp = require(script.Parent.Components.BillboardApp)
local MessageContext = require(script.Parent.Components.MessageContext)

local toolbar = plugin:CreateToolbar(Config.DISPLAY_NAME)

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

local widget = createWidget()
createButtons(widget)

local ui = Roact.createElement(MessageContext.Provider, {
    messageTag = "TeamComment",
    storageTag = "TeamCommentStorage"
}, {
    PluginApp = Roact.createElement(PluginApp, {
        -- selene: allow(incorrect_standard_library_use)
        userId = plugin:GetStudioUserId()
    }),

    -- Billboards do not adorn when parented under PluginGuiService so we have
    -- to portal them to CoreGui.
    --
    -- We're using a portal instead of mounting BillboardApp separately because
    -- we need MessageContext shared between the plugin and billboards.
    Billboards = Roact.createElement(Roact.Portal, {
        target = CoreGui,
    }, {
        BillboardApp = Roact.createElement(BillboardApp),
    }),
})

local handle = Roact.mount(ui, widget, "Apps")

plugin.Unloading:Connect(function()
    Roact.unmount(handle)
end)
