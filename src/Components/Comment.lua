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

local validateProps = t.interface({
	message = Types.Message,
	LayoutOrder = t.optional(t.integer),
	showActions = t.optional(t.boolean),
})

local defaultProps = {
	showActions = true,
}

local AVATAR_SIZE = 64

local function Comment(props, hooks)
	props = Immutable.join(defaultProps, props)

	print(props)

	assert(validateProps(props))

	local theme = useTheme(hooks)

	return Roact.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BorderSizePixel = 0,
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
			Size = UDim2.fromOffset(AVATAR_SIZE, AVATAR_SIZE),
			BackgroundTransparency = 1,
		}, {
			Avatar = Roact.createElement(Avatar, {
				LayoutOrder = 1,
				userId = props.message.userId,
				size = UDim2.new(0, AVATAR_SIZE, 0, AVATAR_SIZE),
			}),
		}),

		Main = Roact.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			-- The X offset is to account for the avatar
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, -AVATAR_SIZE, 0, 0),
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

			Actions = props.showActions and Roact.createElement(MessageActions, {
				message = props.message,
				size = UDim2.new(1, 0, 0, 20),
				LayoutOrder = 3,
			}),
		}),
	})
end

return Hooks.new(Roact)(Comment)
