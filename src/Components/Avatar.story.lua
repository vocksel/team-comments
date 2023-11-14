--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Avatar = require(script.Parent.Avatar)

return {
    story = function()
        return React.createElement("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        }, {
            Avatar = React.createElement(Avatar, {
                LayoutOrder = 1,
                userId = "1343930",
            }),
        })
    end,
}
