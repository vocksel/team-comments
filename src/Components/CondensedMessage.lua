local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local MessageBody = require(script.Parent.MessageBody)
local MessageActions = require(script.Parent.MessageActions)
local ListBox = require(script.Parent.ListBox)

local Props = t.interface({
	layoutOrder = t.integer,
	message = Types.IMessage
})

local AVATAR_SIZE = 48

local function CondensedMessage(props)
	assert(Props(props))

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement(ListBox, {
			layoutOrder = props.layoutOrder,
			fillDirection = Enum.FillDirection.Horizontal,
			padding = Styles.Padding,
		}, {
			Avatar = Roact.createElement(Avatar, {
				userId = props.message.authorId,
				size = UDim2.new(0, AVATAR_SIZE, 0, AVATAR_SIZE),
				maskColor = theme:getColor("MainBackground"),
				layoutOrder = 1,
			}),

			Main = Roact.createElement(ListBox, {
				-- The X offset is to account for the avatar
				width = UDim.new(1, -AVATAR_SIZE),
				layoutOrder = 2,
				listPadding = Styles.Padding,
				paddingLeft = Styles.Padding,
			}, {
				Meta = Roact.createElement(MessageMeta, {
					message = props.message,
					size = UDim2.new(1, 0, 0, Styles.HeaderTextSize),
					layoutOrder = 1,
				}),

				Body = Roact.createElement(MessageBody, {
					message = props.message,
					layoutOrder = 2,
					isTruncated = true,
				}),

				Actions = Roact.createElement(MessageActions, {
					message = props.message,
					size = UDim2.new(1, 0, 0, 20),
					layoutOrder = 3,
				})
			})
		})
	end)
end

return CondensedMessage
