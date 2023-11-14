local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Avatar = require(script.Parent.Avatar)

return {
    story = function()
        return Roact.createElement("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(200, 200, 200),
        }, {
            Avatar = Roact.createElement(Avatar, {
                LayoutOrder = 1,
                userId = "1343930",
            }),
        })
    end,
}
