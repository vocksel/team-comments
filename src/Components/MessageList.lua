
local Roact = require(script.Parent.Parent.Lib.Roact)
local Connect = require(script.Parent.Parent.Lib.RoactRodux).connect
local t = require(script.Parent.Parent.Lib.t)
local Helpers = require(script.Parent.Parent.Helpers)
local ListBox = require(script.Parent.ListBox)
local CondensedMessage = require(script.Parent.CondensedMessage)

local Props = t.interface({
	layoutOrder = t.optional(t.integer)
})

local function MessageList(props)
	assert(Props(props))

	local children = {}

	local function sorter(a, b)
		return a.time > b.time
	end

	for index, message in Helpers.spairs(props.messages, sorter) do
		children[message.id] = Roact.createElement(CondensedMessage, {
			message = message,
			layoutOrder = index,
		})
	end

	return Roact.createElement(ListBox, {
		layoutOrder = props.layoutOrder,
	}, children)
end

local function mapStateToProps(state)
	return {
		messages = state.messages
	}
end

return Connect(mapStateToProps)(MessageList)
