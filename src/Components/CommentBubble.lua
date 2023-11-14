--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local Flipper = require(TeamComments.Packages.Flipper)
local Llama = require(TeamComments.Packages.Llama)
local types = require(TeamComments.types)
local useTheme = require(TeamComments.Hooks.useTheme)
local useAvatar = require(TeamComments.Hooks.useAvatar)

local SPRING_CONFIG = {
    frequency = 1.2,
    dampingRatio = 1,
}

export type Props = {
    message: types.Message,
    isShown: boolean?,
    onActivated: (() -> ())?,
}

local defaultProps = {
    isShown = true,
}

type InternalProps = typeof(defaultProps) & Props

local function CommentBubble(providedProps: Props)
    local props: InternalProps = Llama.Dictionary.join(defaultProps, providedProps)

    local scale, setScale = React.useState(1)
    local transparency, setTransparency = React.useState(1)
    local theme = useTheme()
    local avatar = useAvatar(props.message.userId)

    local motor = React.useMemo(function()
        return Flipper.SingleMotor.new(scale)
    end, {})

    React.useEffect(function()
        motor:onStep(function(value)
            setScale(value)
            setTransparency(1 - value)
        end)

        return function()
            motor:destroy()
        end
    end, {})

    React.useEffect(function()
        motor:setGoal(Flipper.Spring.new(props.isShown and 1 or 0.3, SPRING_CONFIG))
    end, {
        props.isShown,
    })

    return React.createElement("ImageButton", {
        Image = avatar,
        ImageTransparency = transparency,
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
        BackgroundTransparency = transparency,
        Size = UDim2.fromScale(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        [React.Event.Activated] = props.onActivated,
    }, {
        Corner = React.createElement("UICorner", {
            CornerRadius = UDim.new(1, 0),
        }),

        Scale = React.createElement("UIScale", {
            Scale = scale,
        }),

        AspectRatio = React.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1,
        }),
    })
end

return CommentBubble
