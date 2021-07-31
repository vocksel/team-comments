local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Immutable = require(TeamComments.Lib.Immutable)
local Styles = require(TeamComments.Styles)

local function TextLabel(props)
    local newProps = Immutable.join({
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 0),
        BackgroundTransparency = 1,
        Font = Styles.Font,
        Text = "",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = Styles.TextSize,
        TextTruncate = Enum.TextTruncate.None,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
    }, props)

    return Roact.createElement("TextLabel", newProps)
end

return TextLabel
