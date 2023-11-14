--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local ThreadParticipants = require(script.Parent.ThreadParticipants)

return {
    story = function()
        return React.createElement(ThreadParticipants, {
            userIds = { "1343930", "29819622", "103649798" },
        })
    end,
}
