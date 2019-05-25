local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Config = require(script.Parent.Parent.Config)
local Messages = require(script.Parent.Parent.Messages)
local Types = require(script.Parent.Parent.Types)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local MessageBody = require(script.Parent.MessageBody)

local Props = t.interface({
	message = Types.IMessage
})

local function MessageBillboard(props)
	assert(Props(props))

	local messagePart = Messages.getMessagePartById(props.message.id)

	return Roact.createElement("BillboardGui", {
		MaxDistance = Config.BILLBOARD_MAX_DISTANCE,
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
				})
			}),

			Main = Roact.createElement("Frame", {
				Size = UDim2.new(4/5, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0 ,0),
				BackgroundTransparency = 1,
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder
				}),

				Meta = Roact.createElement(MessageMeta, {
					message = props.message,
					size = UDim2.new(1, 0, 0.15, 0),
					layoutOrder = 1,
				}),

				Body = Roact.createElement(MessageBody, {
					message = props.message,
					size = UDim2.new(1, 0, .75, 0),
					layoutOrder = 2,
				})
			})
		})
	})
end

return MessageBillboard
