local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local ThreadParticipants = require(script.Parent.ThreadParticipants)

return {
    story = function()
        return Roact.createElement(ThreadParticipants, {
            userIds = { "1343930", "29819622", "103649798" },
        })
    end,
}
