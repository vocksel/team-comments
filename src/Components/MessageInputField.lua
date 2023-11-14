--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local HttpService = game:GetService("HttpService")

local React = require(TeamComments.Packages.React)
local Llama = require(TeamComments.Packages.Llama)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local styles = require(TeamComments.styles)
local assets = require(TeamComments.assets)
local types = require(TeamComments.types)
local ImageButton = require(script.Parent.ImageButton)

export type Props = {
    userId: string,
    placeholder: string?,
    focusOnMount: boolean?,
    respondTo: types.Message?,
    LayoutOrder: number?,
}

local defaultProps = {
    focusOnMount = false,
}

type InternalProps = typeof(defaultProps) & Props

local function MessageInputField(providedProps: Props)
    local props: InternalProps = Llama.Dictionary.join(defaultProps, providedProps)

    local input = React.createRef()
    local text, setText = React.useState("")
    local messages = React.useContext(MessageContext)
    local theme = useTheme()

    local send = React.useCallback(function()
        local position = workspace.CurrentCamera.CFrame.Position

        if text == "" then
            return
        end

        local message = {
            id = HttpService:GenerateGUID(),
            userId = props.userId,
            text = text,
            createdAt = os.time(),
            responses = {},
        }

        if props.respondTo then
            messages.respond(props.respondTo, message)
        else
            messages.comment(message, position)
        end

        setText("")
    end, { text, setText, messages, props } :: { any })

    local onFocusLost = React.useCallback(function(_rbx, enterPressed)
        if enterPressed then
            send()
        end
    end, {
        send,
    })

    local onTextChanged = React.useCallback(function(rbx)
        setText(rbx.Text)
    end, { setText })

    React.useEffect(function()
        if props.focusOnMount then
            local field = input:getValue()
            -- why does this work
            spawn(function()
                field:CaptureFocus()
            end)
        end
    end, {
        props.focusOnMount,
    })

    return React.createElement("Frame", {
        LayoutOrder = props.LayoutOrder,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromScale(1, 0),
        BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground),
        BorderSizePixel = 0,
    }, {
        Layout = React.createElement("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        Input = React.createElement(
            "TextBox",
            Llama.Dictionary.join(styles.TextBox, {
                Text = text,
                Active = true,
                PlaceholderText = props.placeholder,
                TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
                PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
                BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground),
                [React.Change.Text] = onTextChanged,
                [React.Event.FocusLost] = onFocusLost,
                ref = input,
            }),
            {
                SizeConstraint = React.createElement("UISizeConstraint", {
                    MinSize = Vector2.new(0, styles.Text.TextSize * 2),
                }),

                Padding = React.createElement("UIPadding", {
                    PaddingTop = styles.Padding,
                    PaddingRight = styles.Padding,
                    PaddingBottom = styles.Padding,
                    PaddingLeft = styles.Padding,
                }),
            }
        ),

        Actions = React.createElement("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            Size = UDim2.fromScale(1, 0),
            BackgroundTransparency = 1,
        }, {
            Layout = React.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = styles.Padding,
            }),

            Padding = React.createElement("UIPadding", {
                PaddingRight = styles.PaddingLarge,
                PaddingLeft = styles.Padding,
            }),

            -- TODO: Add emoji support! https://github.com/vocksel/TeamComments/issues/7
            -- Emojis = React.createElement(ImageButton, {
            -- 	LayoutOrder = 1,
            -- 	Image = assets.Emojis,
            -- 	[React.Event.Activated] = send,
            -- }),

            Send = React.createElement(ImageButton, {
                LayoutOrder = 2,
                Image = assets.Send,
                onActivated = send,
            }),
        }),
    })
end

return MessageInputField
