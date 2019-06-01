local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local Props = t.interface({
	message = Types.IMessage,
	isTruncated = t.optional(t.boolean)
})

local function MessageBody(props)
	assert(Props(props))

	return Roact.createElement(ThemedTextLabel, {
		Text = props.message.body,
		Size = props.size,
		TextTruncate = props.isTruncated and Enum.TextTruncate.AtEnd or Enum.TextTruncate.None,
		LayoutOrder = props.layoutOrder
	})
end

return MessageBody
