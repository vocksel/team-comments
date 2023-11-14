--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local PluginApp = require(script.Parent.PluginApp)
local MessageContext = require(TeamComments.Context.MessageContext)

return {
    story = function()
        return React.createElement(MessageContext.Provider, { messageTag = "TeamComment" }, {
            Wrapper = React.createElement("Frame", {
                Size = UDim2.new(0, 400, 1, 0),
                BackgroundTransparency = 1,
            }, {
                PluginApp = React.createElement(PluginApp, {
                    userId = "1343930",
                }),
            }),
        })
    end,
}
