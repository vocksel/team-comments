local Roact = require(script.Parent.Parent.Lib.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local MessageList = require(script.Parent.MessageList)
local ListBox = require(script.Parent.ListBox)
local ToggleVisibilityCheckbox = require(script.Parent.ToggleVisibilityCheckbox)
local Styles = require(script.Parent.Parent.Styles)

local function App(props)
	return StudioThemeAccessor.withTheme(function(theme)
		-- TODO: Make this one giant scrolling frame that has a new message prompt, options, and the list of messages.
		return Roact.createElement(ListBox, {
			transparency = 0,
			backgroundColor = theme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
		}, {
			Options = Roact.createElement(ListBox, {
				layoutOrder = 1,
				transparency = 0,
				backgroundColor = theme:GetColor("Light"),
				paddingTop = Styles.BigPadding,
				paddingBottom = Styles.BigPadding,
				paddingLeft = Styles.Padding,
				paddingRight = Styles.Padding,
			}, {
				ToggleVisibility = Roact.createElement(ToggleVisibilityCheckbox)
			}),

			List = Roact.createElement(MessageList, {
				layoutOrder = 2,
				size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return App
