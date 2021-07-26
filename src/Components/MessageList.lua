
local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local CondensedMessage = require(script.Parent.CondensedMessage)
local MessageContext = require(script.Parent.MessageContext)

local Props = t.interface({
	LayoutOrder = t.optional(t.integer)
})

local function MessageList(props)
	assert(Props(props))

    return Roact.createElement(MessageContext.Consumer, {
        render = function(context)
            local children = {}

            children.Layout = Roact.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
            })

            for index, message in ipairs(context.getOrderedMessages()) do
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
    })
end

return MessageList
