local TeamComments = script:FindFirstAncestor("TeamComments")

local HttpService = game:GetService("HttpService")

local Roact = require(TeamComments.Packages.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local MessageContext = require(TeamComments.Context.MessageContext)
local Styles = require(TeamComments.Styles)

local MessageInputField = Roact.Component:extend("MessageInputField")

function MessageInputField:init()
    self.state = {
        text = ""
    }

    self.setText = function(rbx)
        self:setState({ text = rbx.Text })
    end
end

function MessageInputField:render()
    return Roact.createElement(MessageContext.Consumer, {
        render = function(context)
            local function onFocusLost(_rbx, enterPressed)
                if enterPressed then
                    local messageId = HttpService:GenerateGUID()
                    local position = workspace.CurrentCamera.CFrame.p

                    context.createMessage(messageId, tostring(self.props.userId), self.state.text, os.time(), position)
                    self:setState({ text = "" })
                end
            end

            return StudioThemeAccessor.withTheme(function(theme)
                return Roact.createElement("TextBox", {
                    LayoutOrder = self.props.LayoutOrder,
                    Text = self.state.text,
                    PlaceholderText = "Write a new message...",
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.fromScale(1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    BackgroundColor3 = theme:GetColor("InputFieldBackground"),
                    BorderSizePixel = 0,
                    TextColor3 = theme:GetColor("MainText"),
                    PlaceholderColor3 = theme:GetColor("SubText"),
                    ClearTextOnFocus = false,
                    TextWrapped = true,
                    LineHeight = Styles.TextSize,

                    [Roact.Change.Text] = self.setText,
                    [Roact.Event.FocusLost] = onFocusLost
                }, {
                    Padding = Roact.createElement("UIPadding", {
                        PaddingTop = UDim.new(0, Styles.Padding),
                        PaddingRight = UDim.new(0, Styles.Padding),
                        PaddingBottom = UDim.new(0, Styles.Padding),
                        PaddingLeft = UDim.new(0, Styles.Padding),
                    })
                })
            end)
        end
    })
end

return MessageInputField
