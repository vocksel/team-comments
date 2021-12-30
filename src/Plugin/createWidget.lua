local config = require(script.Parent.Parent.config)

local function createWidget(plugin: Plugin)
	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, true)
	local widgetName = config.PLUGIN_NAME .. "App"
	local widget = plugin:CreateDockWidgetPluginGui(widgetName, info)

	widget.Name = widgetName
	widget.Title = config.DISPLAY_NAME
	widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	return widget
end

return createWidget
