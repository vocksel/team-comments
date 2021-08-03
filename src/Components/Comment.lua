local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local assets = require(TeamComments.Assets)
local Immutable = require(TeamComments.Lib.Immutable)
local useTheme = require(TeamComments.Hooks.useTheme)
local MessageContext = require(TeamComments.Context.MessageContext)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local ThreadParticipants = require(script.Parent.ThreadParticipants)
local ImageButton = require(script.Parent.ImageButton)

local validateProps = t.interface({
	LayoutOrder = t.optional(t.integer),
	message = Types.Message,
})

local AVATAR_SIZE = 64

local function Comment(props, hooks)
	assert(validateProps(props))

	local theme = useTheme(hooks)
	local messages = hooks.useContext(MessageContext)
	local hasResponses = #props.message.responses > 0

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

			Actions = Roact.createElement("Frame", {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundTransparency = 1,
			}, {
				Left = hasResponses and Roact.createElement("Frame", {
					Size = UDim2.fromScale(1 / 2, 1),
					BackgroundTransparency = 1,
				}, {
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = Styles.Padding,
					}),

					Participants = Roact.createElement(ThreadParticipants, {
						message = props.message,
						onActivated = function()
							messages.setSelectedMessage(props.message.id)
						end,
					}),

					ReplyCount = Roact.createElement(
						"TextLabel",
						Immutable.join(Styles.Text, {
							LayoutOrder = 2,
							TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
							TextYAlignment = Enum.TextYAlignment.Bottom,
							AutomaticSize = Enum.AutomaticSize.X,
							Size = UDim2.fromScale(0, 1),
							Text = ("%i replies"):format(#props.message.responses),
						})
					),
				}),

				Right = Roact.createElement("Frame", {
					Size = UDim2.fromScale(1 / 2, 1),
					Position = UDim2.fromScale(1 / 2, 0),
					BackgroundTransparency = 1,
				}, {
					Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = Styles.Padding,
					}),

					View = Roact.createElement(ImageButton, {
						LayoutOrder = 1,
						Image = assets.Focus,
						onActivated = function()
							messages.focusAdornee(props.message.id)
						end,
					}),

					Resolve = Roact.createElement(ImageButton, {
						LayoutOrder = 2,
						Image = assets.Delete,
						onActivated = function()
							messages.deleteMessage(props.message.id)
						end,
					}),

					Reply = Roact.createElement(ImageButton, {
						LayoutOrder = 3,
						Image = assets.Reply,
						onActivated = function()
							messages.setSelectedMessage(props.message.id)
						end,
					}),
				}),
			}),
		}),
	})
end

return Hooks.new(Roact)(Comment)
