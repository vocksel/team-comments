local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local Immutable = require(TeamComments.Lib.Immutable)
local useTheme = require(TeamComments.Hooks.useTheme)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local MessageActions = require(script.Parent.MessageActions)

local Props = t.interface({
	LayoutOrder = t.optional(t.integer),
	message = Types.IMessage,
})

local AVATAR_SIZE = 48

local function Comment(props, hooks)
	assert(Props(props))

	local theme = useTheme(hooks)

	return Roact.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
		}),

		Padding = Roact.createElement("UIPadding", {
			PaddingTop = Styles.Padding,
			PaddingRight = Styles.Padding,
			PaddingBottom = Styles.Padding,
			PaddingLeft = Styles.Padding,
		}),

		Sidebar = Roact.createElement("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromScale(1 / 6, 1),
			BackgroundTransparency = 1,
		}, {
			Avatar = Roact.createElement(Avatar, {
				LayoutOrder = 1,
				userId = props.message.userId,
				size = UDim2.new(0, AVATAR_SIZE, 0, AVATAR_SIZE),
				maskColor = theme:getColor(Enum.StudioStyleGuideColor.MainBackground),
			}),
		}),

		Main = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			-- The X offset is to account for the avatar
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(5 / 6, 0),
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = Styles.Padding,
			}),

			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = Styles.Padding,
			}),

			Meta = Roact.createElement(MessageMeta, {
				message = props.message,
				size = UDim2.new(1, 0, 0, Styles.Header.TextSize),
				LayoutOrder = 1,
			}),

			Body = Roact.createElement(
				"TextLabel",
				Immutable.join(Styles.Text, {
					LayoutOrder = 2,
					Text = props.message.text,
					TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
				})
			),

			Actions = Roact.createElement(MessageActions, {
				message = props.message,
				size = UDim2.new(1, 0, 0, 20),
				LayoutOrder = 3,
			}),
		}),
	})
end

return Hooks.new(Roact)(Comment)
