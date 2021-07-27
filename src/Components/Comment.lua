local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local Avatar = require(script.Parent.Avatar)
local MessageMeta = require(script.Parent.MessageMeta)
local MessageBody = require(script.Parent.MessageBody)
local MessageActions = require(script.Parent.MessageActions)

local Props = t.interface({
    LayoutOrder = t.optional(t.integer),
    message = Types.IMessage
})

local AVATAR_SIZE = 48

local function Comment(props)
    assert(Props(props))

    return StudioThemeAccessor.withTheme(function(theme)
        return Roact.createElement("Frame", {
            LayoutOrder = props.LayoutOrder,
            BackgroundTransparency = 1,
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.fromScale(1, 0),
        }, {
            Layout = Roact.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
            }),

            Padding = Roact.createElement("UIPadding", {
                PaddingTop = UDim.new(0, Styles.Padding),
                PaddingRight = UDim.new(0, Styles.Padding),
                PaddingBottom = UDim.new(0, Styles.Padding),
                PaddingLeft = UDim.new(0, Styles.Padding),
            }),

            Sidebar = Roact.createElement("Frame", {
                LayoutOrder = 1,
                Size = UDim2.fromScale(1/6, 1),
                BackgroundTransparency = 1,
            }, {
                Avatar = Roact.createElement(Avatar, {
                    LayoutOrder = 1,
                    userId = props.message.userId,
                    size = UDim2.new(0, AVATAR_SIZE, 0, AVATAR_SIZE),
                    maskColor = theme:getColor("MainBackground"),
                }),
            }),


            Main = Roact.createElement("Frame", {
                LayoutOrder = 2,
                BackgroundTransparency = 1,
                -- The X offset is to account for the avatar
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.fromScale(5/6, 0),
            }, {
                Layout = Roact.createElement("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, Styles.Padding)
                }),

                Padding = Roact.createElement("UIPadding", {
                    PaddingLeft = UDim.new(0, Styles.Padding)
                }),

                Meta = Roact.createElement(MessageMeta, {
                    message = props.message,
                    size = UDim2.new(1, 0, 0, Styles.HeaderTextSize),
                    LayoutOrder = 1,
                }),

                Body = Roact.createElement(MessageBody, {
                    message = props.message,
                    LayoutOrder = 2,
                    isTruncated = true,
                }),

                Actions = Roact.createElement(MessageActions, {
                    message = props.message,
                    size = UDim2.new(1, 0, 0, 20),
                    LayoutOrder = 3,
                })
            })
        })
    end)
end

return Comment
