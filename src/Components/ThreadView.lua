local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local useTheme = require(TeamComments.Hooks.useTheme)
local Immutable = require(TeamComments.Lib.Immutable)
local Styles = require(TeamComments.Styles)
local types = require(TeamComments.Types)
local assets = require(TeamComments.Assets)
local Comment = require(script.Parent.Comment)
local MessageInputField = require(script.Parent.MessageInputField)

local TITLE_HEIGHT = Styles.Text.TextSize * 2

local validateProps = t.interface({
	userId = t.string,
	message = types.Message,
	-- TODO: Swap out full list of messages for the context
	messages = t.map(t.string, types.Message),
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
		children[messageId] = Roact.createElement(Comment, {
			LayoutOrder = index,
			message = props.messages[messageId],
		})
	end

	return Roact.createElement("Frame", {
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Title = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingRight = Styles.Padding,
				PaddingLeft = Styles.Padding,
			}),

			Main = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
			}, {
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					Padding = Styles.Padding,
				}),

				Close = Roact.createElement("ImageButton", {
					LayoutOrder = 1,
					Image = assets.ArrowLeft,
					Position = UDim2.fromScale(1, 0),
					AnchorPoint = Vector2.new(1, 0),
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					[Roact.Event.Activated] = props.onClose,
				}, {
					AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = 1,
					}),

					Scale = Roact.createElement("UIScale", {
						Scale = 0.8,
					}),
				}),

				Label = Roact.createElement(
					"TextLabel",
					Immutable.join(Styles.Header, {
						LayoutOrder = 2,
						Text = "Thread",
						Position = UDim2.fromScale(0, 0.5),
						AnchorPoint = Vector2.new(0, 0.5),
						TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
						BackgroundTransparency = 1,
					})
				),
			}),

			Border = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
			}),
		}),

		MessageScroller = Roact.createElement(
			"ScrollingFrame",
			Immutable.join(Styles.ScrollingFrame, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT),
			}),
			{
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

				Reply = Roact.createElement("Frame", {
					LayoutOrder = 4,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
				}, {
					MessageInputField = Roact.createElement(MessageInputField, {
						userId = props.userId,
						respondTo = props.message,
					}),
				}),
			}
		),
	})
end

return Hooks.new(Roact)(ThreadView)
