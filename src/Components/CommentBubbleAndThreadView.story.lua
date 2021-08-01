local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local MessageContext = require(TeamComments.Context.MessageContext)
local CommentBubble = require(script.Parent.CommentBubble)
local ThreadView = require(script.Parent.ThreadView)

local function Story(_props, hooks)
	local messages = hooks.useContext(MessageContext)
	local selectedMessage = messages.getSelectedMessage()

	local message = {
		id = "1",
		userId = "1343930",
		text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel leo bibendum, efficitur eros vel, tincidunt est. Aenean augue velit, volutpat et posuere quis, fermentum quis purus. Etiam est risus, fringilla sit amet elementum eget, elementum eu tellus. Vestibulum vehicula nibh felis, at gravida metus rhoncus eu. Curabitur ornare sodales varius.",
		createdAt = os.time(),
		position = Vector3.new(),
		responses = {},
	}

	hooks.useEffect(function()
		messages.comment(message, Vector3.new(0, 0, 0))
	end, {})

	local function onActivated()
		messages.setSelectedMessage(message.id)
	end

	return Roact.createFragment({
		CommentBubbleWrapper = Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.5, 1),
		}, {
			CommentBubble = Roact.createElement(CommentBubble, {
				isShown = true,
				message = message,
				onActivated = onActivated,
			}),
		}),

		ThreadViewWrapper = selectedMessage and Roact.createElement("Frame", {
			Size = UDim2.fromScale(0.5, 1),
			Position = UDim2.fromScale(0.5, 0),
		}, {
			ThreadView = Roact.createElement(ThreadView, {
				userId = "1343930",
				message = selectedMessage,
				messages = {
					[message.id] = message,
				},
			}),
		}),
	})
end
Story = Hooks.new(Roact)(Story)

return function(target)
	local root = Roact.createElement(MessageContext.Provider, {}, {
		Story = Roact.createElement(Story),
	})

	local handle = Roact.mount(root, target, "CommentBubbleAndThreadView")

	return function()
		Roact.unmount(handle)
	end
end
