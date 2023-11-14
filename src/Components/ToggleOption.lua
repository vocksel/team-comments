--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Llama = require(TeamComments.Packages.Llama)
local Checkbox = require(script.Parent.Checkbox)
local styles = require(TeamComments.styles)
local useTheme = require(TeamComments.Hooks.useTheme)

export type Props = {
    text: string,
    isChecked: boolean,
    onClick: (() -> ())?,
    LayoutOrder: number?,
}

local function ToggleOption(props: Props)
    local theme = useTheme()

    return React.createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        LayoutOrder = props.LayoutOrder,
    }, {
        Layout = React.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = styles.Padding,
        }),

        Checkbox = React.createElement(Checkbox, {
            LayoutOrder = 1,
            isChecked = props.isChecked,
            onClick = props.onClick,
        }),

        Label = React.createElement(
            "TextLabel",
            Llama.Dictionary.join(styles.Text, {
                LayoutOrder = 2,
                Text = props.text,
                TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
                Size = UDim2.new(1, 0, 1, 0),
                TextYAlignment = Enum.TextYAlignment.Center,
            })
        ),
    })
end

return ToggleOption
