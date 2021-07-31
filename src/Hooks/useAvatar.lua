local TeamComments = script:FindFirstAncestor("TeamComments")

local Players = game:GetService("Players")

local Promise = require(TeamComments.Packages.Promise)

local fetchUserThumbnail = Promise.promisify(function(userId)
	return Players:GetUserThumbnailAsync(tonumber(userId), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

local function useAvatar(hooks, userId)
	local avatar, setAvatar = hooks.useState("")

	hooks.useEffect(function()
		fetchUserThumbnail(userId):andThen(setAvatar)
	end, {})

	return avatar
end

return useAvatar
