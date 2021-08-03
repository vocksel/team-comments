local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local Promise = require(script.Parent.Parent.Packages.Promise)

local fetchFilteredText = Promise.promisify(function(userId, text)
	local numericUserId = tonumber(userId)
	local result = TextService:FilterStringAsync(text, numericUserId)

	if numericUserId == Players.LocalPlayer.UserId then
		return result:GetNonChatStringForBroadcastAsync()
	else
		return result:GetChatForUserAsync(Players.LocalPlayer.UserId)
	end
end)

local function useTextFilter(hooks, userId, text)
	local filteredText, set = hooks.useState(text:gsub(".", "_"))

	hooks.useEffect(function()
		fetchFilteredText(userId, text):andThen(set)
	end, { set })

	return filteredText
end

return useTextFilter
