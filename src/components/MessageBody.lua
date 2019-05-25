local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.t)
local types = require(script.Parent.Parent.types)

local Props = t.interface({
	message = types.IMessage,
	size = t.UDim2,
	layoutOrder = t.integer
})

local function MessageBody(props)
	assert(Props(props))

	return Roact.createElement("TextLabel", {
		Text = props.message.body,
		Size = props.size,
		LayoutOrder = props.layoutOrder,
		Font = Enum.Font.Gotham,
		BackgroundTransparency = 1,
		TextScaled = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
end

return MessageBody
