local TeamComments = script:FindFirstAncestor("TeamComments")

local Players = game:GetService("Players")

local Promise = require(TeamComments.Packages.Promise)

local fetchPlayerName = Promise.promisify(function(userId)
	return Players:GetNameFromUserIdAsync(tonumber(userId))
end)

local function useName(hooks, userId)
	local name, setName = hooks.useState("")

	hooks.useEffect(function()
		fetchPlayerName(userId):andThen(setName)
	end, { userId })

	return name
end

return useName
