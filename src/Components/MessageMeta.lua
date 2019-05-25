local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Types = require(script.Parent.Parent.Types)
local PlayerName = require(script.Parent.PlayerName)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	layoutOrder = t.integer
})

local function MessageMeta(props)
	assert(Props(props))

	local date = os.date("*t", props.message.time)
	local formattedDate = ("%i/%i/%i"):format(date.day, date.month, date.year)

	return Roact.createElement(PlayerName, {
		userId = props.message.authorId,
		render = function(name)
			return Roact.createElement("TextLabel", {
				Text = ("%s · %s"):format(name, formattedDate),
				Size = props.size,
				LayoutOrder = props.layoutOrder,
				Font = Enum.Font.GothamBlack,
				BackgroundTransparency = 1,
				TextSize = 20,
				TextWrapped = true,
				TextColor3 = Color3.fromRGB(20, 20, 20),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			})
		end
	})
end

return MessageMeta
