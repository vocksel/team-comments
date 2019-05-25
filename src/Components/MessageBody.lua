local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)

local Props = t.interface({
	message = Types.IMessage,
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
