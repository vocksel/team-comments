local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Llama = require(TeamComments.Packages.Llama)
local Styles = require(TeamComments.Styles)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local MessageInputField = require(script.Parent.MessageInputField)
local Comment = require(script.Parent.Comment)
local ThreadView = require(script.Parent.ThreadView)

local validateProps = t.interface({
	userId = t.string,
})

local function App(props, hooks)
	assert(validateProps(props))

	local theme = useTheme(hooks)
	local messages = hooks.useContext(MessageContext)
	local selectedMessage = messages.getSelectedMessage()

	if selectedMessage then
		return Roact.createElement(ThreadView, {
			userId = props.userId,
			message = selectedMessage,
			messages = messages.getAllMessages(),
			onClose = function()
				messages.setSelectedMessage(nil)
			end,
		})
	else
		return Roact.createElement(
			"ScrollingFrame",
			Llama.Dictionary.join(Styles.ScrollingFrame, {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
				CanvasSize = UDim2.fromScale(1, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				BackgroundTransparency = 0,
			}),
			{
				Layout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),

				InputField = Roact.createElement(MessageInputField, {
					LayoutOrder = 1,
					userId = tostring(props.userId),
					placeholder = "Post a comment...",
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

							for index, message in ipairs(context.getOrderedComments()) do
								children[message.id] = Roact.createElement(Comment, {
									LayoutOrder = index,
									message = message,
								})
							end

							return Roact.createFragment(children)
						end,
					}),
				}),
			}
		)
	end
end

return Hooks.new(Roact)(App)
