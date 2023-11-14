--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local types = require(TeamComments.types)
local MessageContext = require(TeamComments.Context.MessageContext)
local Avatar = require(script.Parent.Avatar)

-- Shows all the users that have responsed to a thread

export type Props = {
    message: types.Message,
    onActivated: (() -> ())?,
}

local function ThreadParticipants(props: Props)
    local messages = MessageContext.useContext()
    local allMessages = messages.getAllMessages()
    local responses = props.message.responses

    if #responses == 0 then
        return
    end

    local participants = {}
    for _, responseId in ipairs(responses) do
        local response = allMessages[responseId]

        if not table.find(participants, response.userId) then
            table.insert(participants, response.userId)
        end
    end

    local children = {}

    children.Layout = React.createElement("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    })

    for index, userId in ipairs(participants) do
        children[userId] = React.createElement(Avatar, {
            LayoutOrder = index,
            userId = userId,
        })
    end

    return React.createElement("ImageButton", {
        ImageTransparency = 1,
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromScale(0, 1),
        [React.Event.Activated] = props.onActivated,
    }, children)
end

return ThreadParticipants
