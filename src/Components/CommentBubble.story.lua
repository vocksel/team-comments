local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local CommentBubble = require(script.Parent.CommentBubble)

local Story = Hooks.new(Roact)(function(_props, hooks)
	local isShown, set = hooks.useState(true)

	hooks.useEffect(function()
		local isLooping = true

		coroutine.wrap(function()
			while isLooping do
				set(function(prev)
					return not prev
				end)

				wait(2)
			end
		end)()

		return function()
			isLooping = false
		end
	end, {})

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
	}, {
		Roact.createElement(CommentBubble, {
			isShown = isShown,
			message = {
				id = "1",
				userId = "1343930",
				text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel leo bibendum, efficitur eros vel, tincidunt est. Aenean augue velit, volutpat et posuere quis, fermentum quis purus. Etiam est risus, fringilla sit amet elementum eget, elementum eu tellus. Vestibulum vehicula nibh felis, at gravida metus rhoncus eu. Curabitur ornare sodales varius.",
				createdAt = os.time(),
                position = Vector3.new(),
                responses = {},
			},
			onActivated = function()
				print("clicked")
			end,
		}),
	})
end)

return function(target)
	local handle = Roact.mount(Roact.createElement(Story), target, "CommentBubble")

	return function()
		Roact.unmount(handle)
	end
end
