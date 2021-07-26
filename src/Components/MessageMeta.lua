local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local PlayerName = require(script.Parent.PlayerName)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local TextLabel = require(script.Parent.TextLabel)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	LayoutOrder = t.integer
})

local function MessageMeta(props)
	assert(Props(props))

	local date = os.date("*t", props.message.time)
	local formattedDate = ("%02i/%02i/%i"):format(date.month, date.day, date.year)

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = props.size,
			LayoutOrder = props.LayoutOrder,
		}, {
			Name = Roact.createElement(PlayerName, {
				userId = props.message.authorId,
				render = function(name)
					return Roact.createElement(TextLabel, {
						Text = name,
						Font = Styles.HeaderFont,
						TextSize = Styles.HeaderTextSize,
						TextColor3 = theme:GetColor("MainText"),
					})
				end
			}),

			Date = Roact.createElement(TextLabel, {
				Text = formattedDate,
				TextColor3 = theme:GetColor("DimmedText"),
				TextXAlignment = Enum.TextXAlignment.Right,

				-- align right
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0)
			})
		})
	end)
end

return MessageMeta
