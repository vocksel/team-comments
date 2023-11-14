--!strict
local CoreGui = game:GetService("CoreGui")

local React = require(script.Parent.Packages.React)
local ReactRoblox = require(script.Parent.Packages.ReactRoblox)
local PluginApp = require(script.Parent.Components.PluginApp)
local BillboardApp = require(script.Parent.Components.BillboardApp)
local MessageContext = require(script.Parent.Context.MessageContext)
local config = require(script.Parent.config)
local createWidget = require(script.Parent.Plugin.createWidget)
local createToggleButton = require(script.Parent.Plugin.createToggleButton)

local toolbar = plugin:CreateToolbar(config.DISPLAY_NAME)
local widget = createWidget(plugin)
local disconnectButtonEvents = createToggleButton(toolbar, widget)

local ui = React.createElement(MessageContext.Provider, {
    messageTag = "TeamComment",
}, {
    PluginApp = React.createElement(PluginApp, {
        -- selene: allow(incorrect_standard_library_use)
        userId = tostring(plugin:GetStudioUserId()),
    }),

    -- Billboards do not adorn when parented under PluginGuiService so we have
    -- to portal them to CoreGui.
    --
    -- We're using a portal instead of mounting BillboardApp separately because
    -- we need MessageContext shared between the plugin and billboards.
    Billboards = ReactRoblox.createPortal(
        React.createElement(BillboardApp, {
            widget = widget,
        }),
        CoreGui
    ),
})

local root = ReactRoblox.createRoot(widget)
root:render(ui)

plugin.Unloading:Connect(function()
    root:unmount()
    disconnectButtonEvents()
end)
