--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Llama = require(TeamComments.Packages.Llama)
local types = require(TeamComments.types)
local styles = require(TeamComments.styles)
local useTheme = require(TeamComments.Hooks.useTheme)
local useName = require(TeamComments.Hooks.useName)

local function getDateString(timestamp: number)
    -- Aug 02, 07:26 PM
    local formatStr = "%b %d, %I:%M %p"

    local dateObj = os.date("*t", timestamp)

    if dateObj.year ~= os.date("*t").year then
        -- Aug 02 2021, 07:26 PM
        formatStr = "%b %d %Y, %I:%M %p"
    end

    return os.date(formatStr, timestamp)
end

export type Props = {
    message: types.Message,
    size: UDim2?,
    LayoutOrder: number?,
}

local function MessageMeta(props: Props)
    local theme = useTheme()
    local name = useName(props.message.userId)

    return React.createElement("Frame", {
        BackgroundTransparency = 1,
        Size = props.size,
        LayoutOrder = props.LayoutOrder,
    }, {
        Name = React.createElement(
            "TextLabel",
            Llama.Dictionary.join(styles.Text, {
                Text = name,
                Font = styles.Header.Font,
                TextSize = styles.Header.TextSize,
                TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
            })
        ),

        Date = React.createElement(
            "TextLabel",
            Llama.Dictionary.join(styles.Text, {
                Text = getDateString(props.message.createdAt),
                TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
                TextXAlignment = Enum.TextXAlignment.Right,
                -- align right
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
            })
        ),
    })
end

return MessageMeta
