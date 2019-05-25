local Roact = require(script.Parent.Parent.Lib.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local MessageList = require(script.Parent.MessageList)

local function ToggleOption(props)
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder,
	}, {
		Label = Roact.createElement("TextLabel", {
			Text = props.text
		}),
		Checkbox = Roact.createElement("TextBox")
	})
end

local function App(props)

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("Frame", {
			BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),

			-- Options = Roact.createElement("Frame", {
			-- 	Size = UDim2.new(1, 0, 0, 0),
			-- 	BackgroundTransparency = 1,
			-- }, {
			-- 	Layout = Roact.createElement("UIListLayout", {
			-- 		SortOrder = Enum.SortOrder.LayoutOrder
			-- 	}),

			-- 	ToggleVisibility = Roact.createElement(ToggleOption, {
			-- 		text = "Show messages",
			-- 		layoutOrder = 1
			-- 	})
			-- }),

			-- Top bar for toggleable options (like visibility)
			-- Scrolling list of all messages
			List = Roact.createElement(MessageList, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, -64)
			})
		})
	end)
end

return App
