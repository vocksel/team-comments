local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local CommentIcon = require(script.Parent.CommentIcon)

local Story = Hooks.new(Roact)(function(_props, hooks)
	local isShown, set = hooks.useState(true)

	hooks.useEffect(function()
		local isLooping = true

		coroutine.wrap(function()
			while isLooping do
				set(function(prev)
					return not prev
				end)

				wait(1)
			end
		end)()

		return function()
			isLooping = false
		end
	end, {})

	print("isShown", isShown)

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
	}, {
		Roact.createElement(CommentIcon, {
			isShown = isShown,
		}),
	})
end)

return function(target)
	local handle = Roact.mount(Roact.createElement(Story), target, "CommentIcon")

	return function()
		Roact.unmount(handle)
	end
end
