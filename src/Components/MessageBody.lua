local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Types = require(script.Parent.Parent.Types)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local Props = t.interface({
    message = Types.IMessage,
    isTruncated = t.optional(t.boolean)
})

local function MessageBody(props)
    assert(Props(props))

    return Roact.createElement(ThemedTextLabel, {
        Text = props.message.text,
        Size = props.size,
        TextTruncate = props.isTruncated and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None,
        LayoutOrder = props.LayoutOrder
    })
end

return MessageBody
