
local Roact = require(script.Parent.Parent.Lib.Roact)
local Connect = require(script.Parent.Parent.Lib.RoactRodux).connect
local Helpers = require(script.Parent.Parent.Helpers)
local ScrollingFrame = require(script.Parent.ScrollingFrame)
local CondensedMessage = require(script.Parent.CondensedMessage)

local function MessageList(props)
	local children = {}

	local function sorter(a, b)
		return a.time > b.time
	end

	for index, message in Helpers.spairs(props.messages, sorter) do
		children[message.id] = Roact.createElement(CondensedMessage, {
			message = message,
			height = 64,
			layoutOrder = index,
		})
	end

	return Roact.createElement(ScrollingFrame, {
		List = true,
		ShowBorder = false,
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 1, 0),
	}, children)
end

local function mapStateToProps(state)
	return {
		messages = state.messages
	}
end

return Connect(mapStateToProps)(MessageList)
