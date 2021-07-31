local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local useTheme = require(TeamComments.Hooks.useTheme)
local Immutable = require(TeamComments.Lib.Immutable)
local Styles = require(TeamComments.Styles)
local types = require(TeamComments.Types)
local Comment = require(script.Parent.Comment)

local validateProps = t.interface({
	message = types.IMessage,
	-- TODO: Swap out full list of messages for the context
	messages = t.map(t.string, types.IMessage),
})

local function ThreadView(props, hooks)
	assert(validateProps(props))

	local theme = useTheme(hooks)

	local children = {}

	children.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	})

	children.Padding = Roact.createElement("UIPadding", {
		PaddingLeft = Styles.Padding,
	})

	for index, messageId in ipairs(props.message.responses) do
		table.insert(
			children,
			Roact.createElement(Comment, {
				LayoutOrder = index,
				message = props.messages[messageId],
			})
		)
	end

	return Roact.createElement("Frame", {
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Title = Roact.createElement(
			"TextLabel",
			Immutable.join(Styles.Header, {
				LayoutOrder = 1,
				Text = "Thread",
				TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
			}),
			{
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = Styles.Padding,
					PaddingRight = Styles.Padding,
					PaddingBottom = Styles.Padding,
					PaddingLeft = Styles.Padding,
				}),
			}
		),

		MessageScroller = Roact.createElement("ScrollingFrame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.fromScale(1, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = Styles.Padding + Styles.Padding,
			}),

			MainComment = Roact.createElement(Comment, {
				LayoutOrder = 1,
				message = props.message,
			}),

			Divider = Roact.createElement("Frame", {
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = Styles.Padding,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
				}),

				Padding = Roact.createElement("UIPadding", {
					PaddingRight = Styles.Padding,
					PaddingLeft = Styles.Padding,
				}),

				ReplyCount = Roact.createElement(
					"TextLabel",
					Immutable.join(Styles.Text, {
						LayoutOrder = 1,
						Text = ("%s replies"):format(#props.message.responses),
						TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
						BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
						BackgroundTransparency = 0,
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						Size = UDim2.fromScale(0, 0),
					})
				),

				Line = Roact.createElement("Frame", {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 1),
					AutomaticSize = Enum.AutomaticSize.X,
					BorderSizePixel = 0,
					BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
				}),
			}),

			Responses = Roact.createElement("Frame", {
				LayoutOrder = 3,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0),
				BackgroundTransparency = 1,
			}, children),
		}),
	})
end

return Hooks.new(Roact)(ThreadView)
