local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local useAvatar = require(TeamComments.Hooks.useAvatar)

local validateProps = t.interface({
    LayoutOrder = t.optional(t.number),
    userId = t.string,
})

local function Avatar(props, hooks)
    assert(validateProps(props))

    local avatar = useAvatar(hooks, props.userId)

    return Roact.createElement("ImageLabel", {
        LayoutOrder = props.LayoutOrder,
        Image = avatar,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1,
        }),

        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0.5, 0),
        }),
    })
end

return Hooks.new(Roact)(Avatar)
