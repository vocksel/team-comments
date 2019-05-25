local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local PlayerName = require(script.Parent.PlayerName)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	layoutOrder = t.integer
})

local TEXT_SIZE = 22

local function MessageMeta(props)
	assert(Props(props))

	local date = os.date("*t", props.message.time)
	local formattedDate = ("%i/%i/%i"):format(date.day, date.month, date.year)

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
					Font = Enum.Font.GothamBold,
					BackgroundTransparency = 1,
					TextSize = TEXT_SIZE,
					TextWrapped = true,
					TextColor3 = Color3.fromRGB(20, 20, 20),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
				})
			end
		}),

		Date = Roact.createElement("TextLabel", {
			Text = formattedDate,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamBold,
			BackgroundTransparency = 1,
			TextSize = TEXT_SIZE-4,
			TextWrapped = true,
			TextColor3 = Color3.fromRGB(129, 129, 138),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextYAlignment = Enum.TextYAlignment.Top,
		})
	})
end

return MessageMeta
