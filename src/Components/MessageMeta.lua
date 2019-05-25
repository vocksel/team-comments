local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local PlayerName = require(script.Parent.PlayerName)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	layoutOrder = t.integer
})

local function MessageMeta(props)
	assert(Props(props))

	local date = os.date("*t", props.message.time)
	local formattedDate = ("%02i/%02i/%i"):format(date.month, date.day, date.year)

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = props.size,
			LayoutOrder = props.layoutOrder,
		}, {
			Name = Roact.createElement(PlayerName, {
				userId = props.message.authorId,
				render = function(name)
					return Roact.createElement("TextLabel", {
						Text = name,
						Size = UDim2.new(1, 0, 1, 0),
						Font = Styles.HeaderFont,
						BackgroundTransparency = 1,
						TextSize = Styles.HeaderTextSize,
						TextWrapped = true,
						TextColor3 = theme:GetColor("MainText"),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,
					})
				end
			}),

			Date = Roact.createElement("TextLabel", {
				Text = formattedDate,
				Size = UDim2.new(1, 0, 1, 0),
				Font = Styles.Font,
				BackgroundTransparency = 1,
				TextSize = Styles.TextSize,
				TextWrapped = true,
				TextColor3 = theme:GetColor("DimmedText"),
				TextXAlignment = Enum.TextXAlignment.Right,
				TextYAlignment = Enum.TextYAlignment.Top,
			})
		})
	end)
end

return MessageMeta
