--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local styles = require(TeamComments.styles)
local useTheme = require(TeamComments.Hooks.useTheme)

export type Props = {
    text: string,
    LayoutOrder: number?,
    size: UDim2?,
    onClick: (() -> ())?,
}

local function Button(props: Props)
    local theme = useTheme()

    return React.createElement("TextButton", {
        Text = props.text,
        TextSize = styles.Text.TextSize - 2,
        Font = styles.Header.Font,
        LayoutOrder = props.LayoutOrder,
        TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.Button),
        Size = props.size or UDim2.new(0, 48, 1, 0),
        [React.Event.MouseButton1Click] = props.onClick,
    })
end

return Button
