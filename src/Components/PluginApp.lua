--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Llama = require(TeamComments.Packages.Llama)
local styles = require(TeamComments.styles)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local MessageInputField = require(script.Parent.MessageInputField)
local Comment = require(script.Parent.Comment)
local ThreadView = require(script.Parent.ThreadView)

export type Props = {
    userId: string,
}

local function App(props: Props)
    local theme = useTheme()
    local messages = MessageContext.useContext()
    local selectedMessage = messages.getSelectedMessage()

    if selectedMessage then
        return React.createElement(ThreadView, {
            userId = props.userId,
            message = selectedMessage,
            messages = messages.getAllMessages(),
            onClose = function()
                messages.setSelectedMessage(nil)
            end,
        })
    else
        return React.createElement(
            "ScrollingFrame",
            Llama.Dictionary.join(styles.ScrollingFrame, {
                Size = UDim2.fromScale(1, 1),
                BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
                CanvasSize = UDim2.fromScale(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                BackgroundTransparency = 0,
            }),
            {
                Layout = React.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                }),

                InputField = React.createElement(MessageInputField, {
                    LayoutOrder = 1,
                    userId = tostring(props.userId),
                    placeholder = "Post a comment...",
                }),

                MessageList = React.createElement("Frame", {
                    LayoutOrder = 3,
                    Size = UDim2.fromScale(1, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                }, {
                    React.createElement(MessageContext.Consumer, {
                        render = function(context)
                            local children = {}

                            children.Layout = React.createElement("UIListLayout", {
                                SortOrder = Enum.SortOrder.LayoutOrder,
                            })

                            for index, message in ipairs(context.getOrderedComments()) do
                                children[message.id] = React.createElement(Comment, {
                                    LayoutOrder = index,
                                    message = message,
                                })
                            end

                            return React.createElement(React.Fragment, nil, children)
                        end,
                    }),
                }),
            }
        )
    end
end

return App
