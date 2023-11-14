--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local MessageContext = require(TeamComments.Context.MessageContext)
local CommentBubble = require(script.Parent.CommentBubble)
local ThreadView = require(script.Parent.ThreadView)

local function Story()
    local messages = MessageContext.useContext()
    local selectedMessage = messages.getSelectedMessage()

    local message = {
        id = "1",
        userId = "1343930",
        text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel leo bibendum, efficitur eros vel, tincidunt est. Aenean augue velit, volutpat et posuere quis, fermentum quis purus. Etiam est risus, fringilla sit amet elementum eget, elementum eu tellus. Vestibulum vehicula nibh felis, at gravida metus rhoncus eu. Curabitur ornare sodales varius.",
        createdAt = os.time(),
        position = Vector3.new(),
        responses = {},
    }

    React.useEffect(function()
        messages.comment(message, Vector3.new(0, 0, 0))
    end, {})

    local function onActivated()
        messages.setSelectedMessage(message.id)
    end

    return React.createElement(React.Fragment, nil, {
        CommentBubbleWrapper = React.createElement("Frame", {
            Size = UDim2.fromScale(0.5, 1),
        }, {
            CommentBubble = React.createElement(CommentBubble, {
                isShown = true,
                message = message,
                onActivated = onActivated,
            }),
        }),

        ThreadViewWrapper = selectedMessage and React.createElement("Frame", {
            Size = UDim2.fromScale(0.5, 1),
            Position = UDim2.fromScale(0.5, 0),
        }, {
            ThreadView = React.createElement(ThreadView, {
                userId = "1343930",
                message = selectedMessage,
                messages = {
                    [message.id] = message,
                },
            }),
        }),
    })
end

return {
    story = function()
        return React.createElement(MessageContext.Provider, {}, {
            Story = React.createElement(Story),
        })
    end,
}
