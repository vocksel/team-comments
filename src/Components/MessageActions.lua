local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local Button = require(script.Parent.Button)
local Messages = require(script.Parent.Parent.Messages)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	LayoutOrder = t.integer,
})

local function MessageActions(props)
	assert(Props(props))

	return Roact.createElement("Frame", {
		Size = props.size,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, Styles.Padding),
		}),

		View = Roact.createElement(Button, {
			text = "Focus",
			LayoutOrder = 1,
			onClick = function()
				Messages.focus(props.message.id)
			end
		}),

		-- Edit = Roact.createElement(Button, {
		-- 	text = "Edit",
		-- 	LayoutOrder = 1,
		-- 	onClick = function()
		-- 		print("click :)")
		-- 	end
		-- }),

		Resolve = Roact.createElement(Button, {
			text = "Resolve",
			LayoutOrder = 2,
			onClick = function()
				Messages.delete(props.message.id)
			end
		})
	})
end

return MessageActions
