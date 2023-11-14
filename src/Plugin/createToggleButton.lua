local config = require(script.Parent.Parent.config)
local assets = require(script.Parent.Parent.assets)

--[=[
    Creates the button to toggle the plugin widget.

    This function also sets up some events to toggle the widget when the button
    is clicked, and to sync up the button's "active" state with the widget.

    @return () -> nil -- Returns a callback for disconnecting button events
]=]
local function createToggleButton(toolbar: PluginToolbar, widget: DockWidgetPluginGui)
    local toggleAppView =
        toolbar:CreateButton(config.DISPLAY_NAME, "View and edit the list of messages", assets.CommentBubble)

    local click = toggleAppView.Click:Connect(function()
        widget.Enabled = not widget.Enabled
    end)

    local enabled = widget:GetPropertyChangedSignal("Enabled"):Connect(function()
        toggleAppView:SetActive(widget.Enabled)
    end)

    return function()
        click:Disconnect()
        enabled:Disconnect()
    end
end

return createToggleButton
