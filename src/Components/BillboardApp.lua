--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local MessageContext = require(TeamComments.Context.MessageContext)
local useCameraDistance = require(TeamComments.Hooks.useCameraDistance)
local CommentBubble = require(script.Parent.CommentBubble)

export type Props = {
    widget: DockWidgetPluginGui,
}

local function BillboardApp(props: Props)
    local messages = MessageContext.useContext()
    local children = {}

    for _, message in pairs(messages.getComments()) do
        local messagePart = messages.getAdornee(message.id)

        local function onActivated()
            props.widget.Enabled = true
            messages.focusAdornee(message.id)
            messages.setSelectedMessage(message.id)
        end

        if messagePart then
            local distance = useCameraDistance(messagePart.Position)

            children[message.id] = React.createElement("BillboardGui", {
                MaxDistance = math.huge,
                Size = UDim2.fromScale(4, 4),
                LightInfluence = 0,
                Adornee = messagePart,
                Active = true,
            }, {
                CommentBubble = React.createElement(CommentBubble, {
                    isShown = distance < 60,
                    message = message,
                    onActivated = onActivated,
                }),
            })
        end
    end

    return React.createElement("Folder", {}, children)
end

return BillboardApp
