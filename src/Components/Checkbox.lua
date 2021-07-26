local Roact = require(script.Parent.Parent.Packages.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local t = require(script.Parent.Parent.Packages.t)

local Props = t.interface({
	isChecked = t.boolean,
	onClick = t.optional(t.callback),
	position = t.optional(t.UDim2),
	anchorPoint = t.optional(t.Vector2),
	LayoutOrder = t.optional(t.integer),
})

local function Checkbox(props)
	assert(Props(props))

    local state = props.isChecked and "Selected" or "Default"

    return StudioThemeAccessor.withTheme(function(theme)
        return Roact.createElement("ImageButton", {
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundColor3 = theme:GetColor("CheckedFieldBackground", state),
            BorderColor3 = theme:GetColor("CheckedFieldBorder", state),
            AutoButtonColor = false,
            Position = props.position,
            AnchorPoint = props.anchorPoint,
            LayoutOrder = props.LayoutOrder,
            [Roact.Event.MouseButton1Click] = props.onClick,
        }, {
            Check = Roact.createElement("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 12),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Visible = props.isChecked == true,
                ImageColor3 = theme:GetColor("CheckedFieldIndicator", state),
                Image = "rbxassetid://2617163557",
            })
        })
    end)
end

return Checkbox
