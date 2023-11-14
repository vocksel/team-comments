local TeamComments = script:FindFirstAncestor("TeamComments")

local Players = game:GetService("Players")

local Promise = require(TeamComments.Packages.Promise)
local React = require(TeamComments.Packages.React)

local fetchPlayerName = Promise.promisify(function(userId: string)
    return Players:GetNameFromUserIdAsync(tonumber(userId))
end)

local function useName(userId: string)
    local name, setName = React.useState("")

    React.useEffect(function()
        fetchPlayerName(userId):andThen(setName)
    end, { userId })

    return name
end

return useName
