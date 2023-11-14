local TeamComments = script:FindFirstAncestor("TeamComments")

local Players = game:GetService("Players")

local Promise = require(TeamComments.Packages.Promise)
local React = require(TeamComments.Packages.React)

local fetchUserThumbnail = Promise.promisify(function(userId: string)
    return Players:GetUserThumbnailAsync(tonumber(userId), Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

local function useAvatar(userId: string)
    local avatar, setAvatar = React.useState("")

    React.useEffect(function()
        fetchUserThumbnail(userId):andThen(setAvatar)
    end, {})

    return avatar
end

return useAvatar
