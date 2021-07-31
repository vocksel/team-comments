local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local Styles = require(TeamComments.Styles)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local MessageInputField = require(script.Parent.MessageInputField)
local Comment = require(script.Parent.Comment)

local function App(props, hooks)
	local theme = useTheme(hooks)

	-- FIXME: The scrolling frame doesn't update when new messages are
	-- added. Requires the widget to be resized first.
	return Roact.createElement("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		CanvasSize = UDim2.fromScale(1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		InputField = Roact.createElement(MessageInputField, {
			LayoutOrder = 1,
			userId = props.userId,
		}),

		Options = Roact.createElement("Frame", {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Light),
		}, {
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = Styles.Padding,
				PaddingRight = Styles.Padding,
				PaddingBottom = Styles.Padding,
				PaddingLeft = Styles.Padding,
			}),

			-- FIXME: Porting over to Roact Context from Rodux. Don't have
			-- any UI settings in place yet, so this still needs to be added.
			-- TODO: Create an action for each toggle so that the user can
			-- easily bind keys to them.
			-- ToggleVisibility = Roact.createElement(ToggleVisibilityCheckbox)
		}),

		MessageList = Roact.createElement("Frame", {
			LayoutOrder = 3,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, {
			Roact.createElement(MessageContext.Consumer, {
				render = function(context)
					local children = {}

					children.Layout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
					})

					for index, message in ipairs(context.getOrderedMessages()) do
						children[message.id] = Roact.createElement(Comment, {
							LayoutOrder = index,
							message = message,
						})
					end

					return Roact.createFragment(children)
				end,
			}),
		}),
	})
end

return Hooks.new(Roact)(App)
