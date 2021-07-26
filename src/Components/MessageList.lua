
local Roact = require(script.Parent.Parent.Packages.Roact)
local Connect = require(script.Parent.Parent.Packages.RoactRodux).connect
local t = require(script.Parent.Parent.Packages.t)
local CondensedMessage = require(script.Parent.CondensedMessage)

local Props = t.interface({
	LayoutOrder = t.optional(t.integer)
})

local function MessageList(props)
	assert(Props(props))

	local children = {}

    children.Layout = Roact.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
    })

    -- Gather the messages and sort them by time
    local messages = {}
    for _, message in pairs(props.messages) do
        table.insert(messages, message)
    end
    table.sort(messages, function(a, b)
        return a.time > b.time
    end)

	for index, message in pairs(messages) do
		children[message.id] = Roact.createElement(CondensedMessage, {
			LayoutOrder = index,
			message = message,
		})
	end

    return Roact.createElement("Frame", {
        LayoutOrder = props.LayoutOrder,
        Size = UDim2.fromScale(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, children)
end

local function mapStateToProps(state)
	return {
		messages = state.messages
	}
end

return Connect(mapStateToProps)(MessageList)
