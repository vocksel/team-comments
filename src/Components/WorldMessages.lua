local Roact = require(script.Parent.Parent.Lib.Roact)
local Connect = require(script.Parent.Parent.Lib.RoactRodux).connect
local BillboardMessage = require(script.Parent.BillboardMessage)

local function getTheme(name)
    for _, theme in pairs(settings().Studio:GetAvailableThemes()) do
        if theme.Name == name then
            return theme
        end
    end
end

local function WorldMessages(props)
	if props.ui.areMessagesVisible then
		local children = {}

		for _, message in pairs(props.messages) do
			children[message.id] = Roact.createElement(BillboardMessage, {
				message = message
			})
		end

		return Roact.createElement("Folder", {}, children)
	end
end

local function mapStateToProps(state)
	return {
		messages = state.messages,
		ui = state.ui,
	}
end

return Connect(mapStateToProps)(WorldMessages)
