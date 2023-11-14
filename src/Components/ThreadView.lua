--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Llama = require(TeamComments.Packages.Llama)
local useTheme = require(TeamComments.Hooks.useTheme)
local styles = require(TeamComments.styles)
local types = require(TeamComments.types)
local assets = require(TeamComments.assets)
local Comment = require(script.Parent.Comment)
local MessageInputField = require(script.Parent.MessageInputField)

local TITLE_HEIGHT = styles.Text.TextSize * 2

export type Props = {
    userId: string,
    message: types.Message,
    -- TODO: Swap out full list of messages for the context
    messages: { [string]: types.Message },
    onClose: (() -> ())?,
}

local function ThreadView(props: Props)
    local theme = useTheme()

    local children = {}

    children.Layout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })

    children.Padding = React.createElement("UIPadding", {
        PaddingLeft = styles.Padding,
    })

    for index, messageId in ipairs(props.message.responses) do
        children[messageId] = React.createElement(Comment, {
            LayoutOrder = index,
            message = props.messages[messageId],
            showActions = false,
        })
    end

    return React.createElement("Frame", {
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
    }, {
        Layout = React.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        Title = React.createElement("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
        }, {
            Padding = React.createElement("UIPadding", {
                PaddingRight = styles.Padding,
                PaddingLeft = styles.Padding,
            }),

            Main = React.createElement("Frame", {
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
            }, {
                Layout = React.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = styles.Padding,
                }),

                Close = React.createElement("ImageButton", {
                    LayoutOrder = 1,
                    Image = assets.ArrowLeft,
                    Position = UDim2.fromScale(1, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    [React.Event.Activated] = props.onClose,
                }, {
                    AspectRatio = React.createElement("UIAspectRatioConstraint", {
                        AspectRatio = 1,
                    }),

                    Scale = React.createElement("UIScale", {
                        Scale = 0.8,
                    }),
                }),

                Label = React.createElement(
                    "TextLabel",
                    Llama.Dictionary.join(styles.Header, {
                        LayoutOrder = 2,
                        Text = "Thread",
                        Position = UDim2.fromScale(0, 0.5),
                        AnchorPoint = Vector2.new(0, 0.5),
                        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
                        BackgroundTransparency = 1,
                    })
                ),
            }),

            Border = React.createElement("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
            }),
        }),

        MessageScroller = React.createElement(
            "ScrollingFrame",
            Llama.Dictionary.join(styles.ScrollingFrame, {
                LayoutOrder = 3,
                Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT),
            }),
            {
                Layout = React.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = styles.Padding + styles.Padding,
                }),

                MainComment = React.createElement(Comment, {
                    LayoutOrder = 1,
                    message = props.message,
                }),

                Divider = React.createElement("Frame", {
                    LayoutOrder = 2,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                }, {
                    Layout = React.createElement("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = styles.Padding,
                        VerticalAlignment = Enum.VerticalAlignment.Center,
                        FillDirection = Enum.FillDirection.Horizontal,
                    }),

                    Padding = React.createElement("UIPadding", {
                        PaddingRight = styles.Padding,
                        PaddingLeft = styles.Padding,
                    }),

                    ReplyCount = React.createElement(
                        "TextLabel",
                        Llama.Dictionary.join(styles.Text, {
                            LayoutOrder = 1,
                            Text = `{#props.message.responses} replies`,
                            TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
                            BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            AutomaticSize = Enum.AutomaticSize.XY,
                            Size = UDim2.fromScale(0, 0),
                        })
                    ),

                    Line = React.createElement("Frame", {
                        LayoutOrder = 2,
                        Size = UDim2.new(1, 0, 0, 1),
                        AutomaticSize = Enum.AutomaticSize.X,
                        BorderSizePixel = 0,
                        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Border),
                    }),
                }),

                Responses = React.createElement("Frame", {
                    LayoutOrder = 3,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Size = UDim2.fromScale(1, 0),
                    BackgroundTransparency = 1,
                }, children),

                Reply = React.createElement("Frame", {
                    LayoutOrder = 4,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                }, {
                    MessageInputField = React.createElement(MessageInputField, {
                        userId = props.userId,
                        respondTo = props.message,
                        focusOnMount = true,
                        placeholder = "Reply...",
                    }),
                }),
            }
        ),
    })
end

return ThreadView
