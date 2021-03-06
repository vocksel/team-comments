local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local PluginApp = require(script.Parent.PluginApp)
local MessageContext = require(TeamComments.Context.MessageContext)

return function(target)
	local root = Roact.createElement(MessageContext.Provider, { messageTag = "TeamComment" }, {
		Wrapper = Roact.createElement("Frame", {
			Size = UDim2.new(0, 400, 1, 0),
			BackgroundTransparency = 1,
		}, {
			PluginApp = Roact.createElement(PluginApp, {
				userId = "1343930",
			}),
		}),
	})

	local handle = Roact.mount(root, target, "PluginApp")

	return function()
		Roact.unmount(handle)
	end
end
