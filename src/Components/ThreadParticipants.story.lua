local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local ThreadParticipants = require(script.Parent.ThreadParticipants)

return function(target)
	local root = Roact.createElement(ThreadParticipants, {
		userIds = { "1343930", "29819622", "103649798" },
	})

	local handle = Roact.mount(root, target, "ThreadParticipants")

	return function()
		Roact.unmount(handle)
	end
end
