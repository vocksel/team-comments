local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Config = require(script.Parent.Parent.Config)
local Messages = require(script.Parent.Parent.Messages)
local Types = require(script.Parent.Parent.Types)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local MessageBody = require(script.Parent.MessageBody)
local Padding = require(script.Parent.Padding)

local Props = t.interface({
	message = Types.IMessage
})

local PADDING = 8

local function MessageBillboard(props)
	assert(Props(props))

	local messagePart = Messages.getMessagePartById(props.message.id)

	return Roact.createElement("BillboardGui", {
		MaxDistance = Config.BILLBOARD_MAX_DISTANCE,
		Size = UDim2.new(0, 450, 0, 200),
		LightInfluence = 0,
		Adornee = messagePart
	}, {
		Container = Roact.createElement("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0
		}, {
			Padding = Roact.createElement(Padding, {
				size = PADDING
			}),

			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal
			}),

			Sidebar = Roact.createElement("Frame", {
				Size = UDim2.new(1/5, 0, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 1,
			}, {
				Avatar = Roact.createElement(Avatar, {
					userId = props.message.authorId,
				})
			}),

			Main = Roact.createElement("Frame", {
				Size = UDim2.new(4/5, -PADDING, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = 2,
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8)
				}),

				Padding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, PADDING)
				}),

				Meta = Roact.createElement(MessageMeta, {
					message = props.message,
					size = UDim2.new(1, 0, 0, 22),
					layoutOrder = 1,
				}),

				Body = Roact.createElement(MessageBody, {
					message = props.message,
					size = UDim2.new(1, 0, 0.85, 0),
					layoutOrder = 2,
				})
			})
		})
	})
end

return MessageBillboard
