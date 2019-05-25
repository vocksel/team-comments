local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.t)

local config = require(script.Parent.Parent.config)
local messages = require(script.Parent.Parent.messages)
local types = require(script.Parent.Parent.types)

local Props = t.interface({
	message = types.IMessage
})

local function MessageBillboard(props)
	assert(Props(props))

	local messagePart = messages.getMessagePartById(props.message.id)

	return Roact.createElement("BillboardGui", {
		MaxDistance = config.BILLBOARD_MAX_DISTANCE,
		Size = UDim2.new(8, 0, 4, 0),
		LightInfluence = 0,
		Adornee = messagePart
	}, {
		Sidebar = Roact.createElement("Frame", {
			Size = UDim2.new(1/5, 0, 1, 0),
			BackgroundTransparency = 1
		}, {
			-- Avatar = Roact.createElement(Avatar, { userId = props.userId }),
			-- Time = Roact.createElement(TimeLabel, { })
		}),
		Message = Roact.createElement("Frame", {
			Size = UDim2.new(4/5, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		}, {

		})
	})
end

return MessageBillboard
