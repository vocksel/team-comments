local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Avatar = require(script.Parent.Avatar)

return function(target)
    local BACKGROUND_COLOR = Color3.fromRGB(200, 200, 200)

    local root = Roact.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = BACKGROUND_COLOR,
    }, {
        Avatar = Roact.createElement(Avatar, {
            LayoutOrder = 1,
            userId = "1343930",
            maskColor = BACKGROUND_COLOR
        })
    })

    local handle = Roact.mount(root, target, "Avatar")

    return function()
        Roact.unmount(handle)
    end
end
