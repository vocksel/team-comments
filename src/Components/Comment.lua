--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Llama = require(TeamComments.Packages.Llama)
local types = require(TeamComments.types)
local styles = require(TeamComments.styles)
local assets = require(TeamComments.assets)
local useTheme = require(TeamComments.Hooks.useTheme)
local MessageContext = require(TeamComments.Context.MessageContext)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local ThreadParticipants = require(script.Parent.ThreadParticipants)
local ImageButton = require(script.Parent.ImageButton)

export type Props = {
    message: types.Message,
    showActions: boolean?,
    LayoutOrder: number?,
}

local defaultProps = {
    showActions = true,
}

local AVATAR_SIZE = 64

local function Comment(props: Props)
    props = Llama.Dictionary.join(defaultProps, props)

    print(props)

    local theme = useTheme()
    local messages = MessageContext.useContext()
    local hasResponses = #props.message.responses > 0

    return React.createElement("Frame", {
        LayoutOrder = props.LayoutOrder,
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 0),
    }, {
        Layout = React.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
        }),

        Padding = React.createElement("UIPadding", {
            PaddingTop = styles.Padding,
            PaddingRight = styles.Padding,
            PaddingBottom = styles.Padding,
            PaddingLeft = styles.Padding,
        }),

        Sidebar = React.createElement("Frame", {
            LayoutOrder = 1,
            Size = UDim2.fromOffset(AVATAR_SIZE, AVATAR_SIZE),
            BackgroundTransparency = 1,
        }, {
            Avatar = React.createElement(Avatar, {
                LayoutOrder = 1,
                userId = props.message.userId,
                size = UDim2.new(0, AVATAR_SIZE, 0, AVATAR_SIZE),
            }),
        }),

        Main = React.createElement("Frame", {
            LayoutOrder = 2,
            BackgroundTransparency = 1,
            -- The X offset is to account for the avatar
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.new(1, -AVATAR_SIZE, 0, 0),
        }, {
            Layout = React.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = styles.Padding,
            }),

            Padding = React.createElement("UIPadding", {
                PaddingLeft = styles.Padding,
            }),

            Meta = React.createElement(MessageMeta, {
                message = props.message,
                size = UDim2.new(1, 0, 0, styles.Header.TextSize),
                LayoutOrder = 1,
            }),

            Body = React.createElement(
                "TextLabel",
                Llama.Dictionary.join(styles.Text, {
                    LayoutOrder = 2,
                    Text = props.message.text,
                    TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
                })
            ),

            Actions = props.showActions and React.createElement("Frame", {
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
            }, {
                Left = hasResponses and React.createElement("Frame", {
                    Size = UDim2.fromScale(1 / 2, 1),
                    BackgroundTransparency = 1,
                }, {
                    Layout = React.createElement("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Horizontal,
                        Padding = styles.Padding,
                    }),

                    Participants = React.createElement(ThreadParticipants, {
                        message = props.message,
                        onActivated = function()
                            messages.setSelectedMessage(props.message.id)
                        end,
                    }),

                    ReplyCount = React.createElement(
                        "TextLabel",
                        Llama.Dictionary.join(styles.Text, {
                            LayoutOrder = 2,
                            TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
                            TextYAlignment = Enum.TextYAlignment.Bottom,
                            AutomaticSize = Enum.AutomaticSize.X,
                            Size = UDim2.fromScale(0, 1),
                            Text = ("%i replies"):format(#props.message.responses),
                        })
                    ),
                }),

                Right = React.createElement("Frame", {
                    Size = UDim2.fromScale(1 / 2, 1),
                    Position = UDim2.fromScale(1 / 2, 0),
                    BackgroundTransparency = 1,
                }, {
                    Layout = React.createElement("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        FillDirection = Enum.FillDirection.Horizontal,
                        HorizontalAlignment = Enum.HorizontalAlignment.Right,
                        Padding = styles.Padding,
                    }),

                    View = React.createElement(ImageButton, {
                        LayoutOrder = 1,
                        Image = assets.Focus,
                        onActivated = function()
                            messages.focusAdornee(props.message.id)
                        end,
                    }),

                    Resolve = React.createElement(ImageButton, {
                        LayoutOrder = 2,
                        Image = assets.Delete,
                        onActivated = function()
                            messages.deleteMessage(props.message.id)
                        end,
                    }),

                    Reply = React.createElement(ImageButton, {
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

return Comment
