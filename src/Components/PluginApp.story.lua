local Roact = require(script.Parent.Parent.Packages.Roact)
local Rodux = require(script.Parent.Parent.Packages.Rodux)
local RoactRodux = require(script.Parent.Parent.Packages.RoactRodux)
local PluginApp = require(script.Parent.PluginApp)
local Reducer = require(script.Parent.Parent.Reducer)
local initializeState = require(script.Parent.Parent.InitializeState)

return function(target)
    local store = Rodux.Store.new(Reducer)

    initializeState(store)

    local root = Roact.createElement(RoactRodux.StoreProvider, {
		store = store
	}, {
        Wrapper = Roact.createElement("Frame", {
            Size = UDim2.fromScale(0.4, 0.8),
            BackgroundTransparency = 1,
        }, {
            PluginApp = Roact.createElement(PluginApp, {
                userId = "1343930"
            })
        })
	})

    local handle = Roact.mount(root, target, "PluginApp")

    return function()
        Roact.unmount(handle)
    end
end
