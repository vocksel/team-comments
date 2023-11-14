--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local useAvatar = require(TeamComments.Hooks.useAvatar)

export type Props = {
    userId: string,
    LayoutOrder: number?,
}

local function Avatar(props: Props)
    local avatar = useAvatar(props.userId)

    return React.createElement("ImageLabel", {
        LayoutOrder = props.LayoutOrder,
        Image = avatar,
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        AspectRatio = React.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1,
        }),

        Corner = React.createElement("UICorner", {
            CornerRadius = UDim.new(0.5, 0),
        }),
    })
end

return Avatar
