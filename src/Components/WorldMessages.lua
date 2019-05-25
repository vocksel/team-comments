local Roact = require(script.Parent.Parent.lib.Roact)
local connect = require(script.Parent.Parent.lib.RoactRodux).connect
local MessageBillboard = require(script.Parent.MessageBillboard)

local function WorldMessages(props)
	local children = {}

	for _, message in pairs(props.messages) do
		children[message.id] = Roact.createElement(MessageBillboard, {
			message = message
		})
	end

	return Roact.createElement("Folder", {}, children)
end

local function mapStateToProps(state)
	return {
		messages = state.messages
	}
end

return connect(mapStateToProps)(WorldMessages)
