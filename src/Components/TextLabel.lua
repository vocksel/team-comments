local TextService = game:GetService("TextService")

local Roact = require(script.Parent.Parent.Lib.Roact)
local Immutable = require(script.Parent.Parent.Lib.Immutable)
local Styles = require(script.Parent.Parent.Styles)

local function TextLabel(props)
	local function update(rbx)
		if not rbx then return end
		local width = rbx.AbsoluteSize.x
		local tb = TextService:GetTextSize(rbx.Text, rbx.TextSize, rbx.Font, Vector2.new(width - 2, 100000))
		rbx.Size = UDim2.new(1, 0, 0, tb.y)
	end

	local autoSize = not props.Size

	local newProps = Immutable.join({
		Size = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,

		Font = Styles.Font,
		Text = "",
		TextColor3 = Color3.fromRGB(0, 0, 0),
		TextSize = Styles.TextSize,
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, props, {
		[Roact.Ref] = autoSize and update or nil,
		[Roact.Change.TextBounds] = autoSize and update or nil,
		[Roact.Change.AbsoluteSize] = autoSize and update or nil,
		[Roact.Change.Parent] = autoSize and update or nil,
	})

	return Roact.createElement("TextLabel", newProps)
end

return TextLabel
