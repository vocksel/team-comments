--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local useTheme = require(TeamComments.Hooks.useTheme)

export type Props = {
    isChecked: boolean,
    onClick: (() -> ())?,
    position: UDim2?,
    anchorPoint: Vector2?,
    LayoutOrder: number?,
}

local function Checkbox(props: Props)
    local state = props.isChecked and Enum.StudioStyleGuideModifier.Selected or Enum.StudioStyleGuideModifier.Default
    local theme = useTheme()

    return React.createElement("ImageButton", {
        Size = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBackground, state),
        BorderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldBorder, state),
        AutoButtonColor = false,
        Position = props.position,
        AnchorPoint = props.anchorPoint,
        LayoutOrder = props.LayoutOrder,
        [React.Event.MouseButton1Click] = props.onClick,
    }, {
        Check = React.createElement("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 12),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Visible = props.isChecked == true,
            ImageColor3 = theme:GetColor(Enum.StudioStyleGuideColor.CheckedFieldIndicator, state),
            Image = "rbxassetid://2617163557",
        }),
    })
end

return Checkbox
