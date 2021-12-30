local CoreGui = game:GetService("CoreGui")

local Roact = require(script.Parent.Packages.Roact)
local PluginApp = require(script.Parent.Components.PluginApp)
local BillboardApp = require(script.Parent.Components.BillboardApp)
local MessageContext = require(script.Parent.Context.MessageContext)
local config = require(script.Parent.config)
local createWidget = require(script.Parent.Plugin.createWidget)
local createToggleButton = require(script.Parent.Plugin.createToggleButton)

local toolbar = plugin:CreateToolbar(config.DISPLAY_NAME)
local widget = createWidget(plugin)
local disconnectButtonEvents = createToggleButton(toolbar, widget)

local ui = Roact.createElement(MessageContext.Provider, {
	messageTag = "TeamComment",
}, {
	PluginApp = Roact.createElement(PluginApp, {
		-- selene: allow(incorrect_standard_library_use)
		userId = tostring(plugin:GetStudioUserId()),
	}),

	-- Billboards do not adorn when parented under PluginGuiService so we have
	-- to portal them to CoreGui.
	--
	-- We're using a portal instead of mounting BillboardApp separately because
	-- we need MessageContext shared between the plugin and billboards.
	Billboards = Roact.createElement(Roact.Portal, {
		target = CoreGui,
	}, {
		BillboardApp = Roact.createElement(BillboardApp, {
			widget = widget,
		}),
	}),
})

Roact.setGlobalConfig({
	typeChecks = true,
	elementTracing = true,
	propValidation = true,
})

local handle = Roact.mount(ui, widget, "Apps")

plugin.Unloading:Connect(function()
	Roact.unmount(handle)
	disconnectButtonEvents()
end)
