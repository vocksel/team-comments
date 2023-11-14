--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local useTheme = require(TeamComments.Hooks.useTheme)

export type Props = {
    Image: string,
    LayoutOrder: number?,
    onActivated: (() -> ())?,
}

local function ImageButton(props: Props)
    local theme = useTheme()
    local isHovered, setIsHovered = React.useState(false)

    local onMouseEnter = React.useCallback(function()
        setIsHovered(true)
    end, {})

    local onMouseLeave = React.useCallback(function()
        setIsHovered(false)
    end, {})

    return React.createElement("ImageButton", {
        LayoutOrder = props.LayoutOrder,
        Image = props.Image,
        Active = true,
        Size = UDim2.fromOffset(24, 24),
        ImageColor3 = theme:GetColor(
            Enum.StudioStyleGuideColor.MainText,
            isHovered and Enum.StudioStyleGuideModifier.Hover or nil
        ),
        BackgroundTransparency = 1,
        [React.Event.Activated] = props.onActivated,
        [React.Event.MouseEnter] = onMouseEnter,
        [React.Event.MouseLeave] = onMouseLeave,
    })
end

return ImageButton
