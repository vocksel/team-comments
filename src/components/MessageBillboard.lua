local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.t)
local config = require(script.Parent.Parent.config)
local messages = require(script.Parent.Parent.messages)
local types = require(script.Parent.Parent.types)
local Avatar = require(script.Parent.Avatar)

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
		Container = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0
		}, {
			Sidebar = Roact.createElement("Frame", {
				Size = UDim2.new(1/5, 0, 1, 0),
				BackgroundTransparency = 1
			}, {
				Avatar = Roact.createElement(Avatar, {
					userId = props.message.authorId,
				}),

				-- Time = Roact.createElement(TimeLabel, {
				-- 	time = props.message.time
				-- })
			}),

			Main = Roact.createElement("Frame", {
				Size = UDim2.new(4/5, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0 ,0),
				BackgroundTransparency = 1,
			}, {
				-- Message = Roact.createElement(Message, {
				-- 	messageId = props.message.id
				-- })
			})
		})
	})
end

return MessageBillboard
