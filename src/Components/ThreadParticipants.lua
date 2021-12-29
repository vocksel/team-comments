local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local types = require(TeamComments.types)
local MessageContext = require(TeamComments.Context.MessageContext)
local Avatar = require(script.Parent.Avatar)

-- Shows all the users that have responsed to a thread
local validateProps = t.interface({
	message = types.Message,
	onActivated = t.optional(t.callback),
})

local function ThreadParticipants(props, hooks)
	assert(validateProps(props))

	local messages = hooks.useContext(MessageContext)
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

	children.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	for index, userId in ipairs(participants) do
		children[userId] = Roact.createElement(Avatar, {
			LayoutOrder = index,
			userId = userId,
		})
	end

	return Roact.createElement("ImageButton", {
		ImageTransparency = 1,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromScale(0, 1),
		[Roact.Event.Activated] = props.onActivated,
	}, children)
end

return Hooks.new(Roact)(ThreadParticipants)
