local Roact = require(script.Parent.Parent.Lib.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local MessageList = require(script.Parent.MessageList)
local ListBox = require(script.Parent.ListBox)
local ToggleVisibilityCheckbox = require(script.Parent.ToggleVisibilityCheckbox)
local Styles = require(script.Parent.Parent.Styles)
local ScrollingFrame = require(script.Parent.ScrollingFrame)
local MessageInputField = require(script.Parent.MessageInputField)

local function App(props)
	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement(ScrollingFrame, nil, {
			Input = Roact.createElement(ListBox, {
				layoutOrder = 1,
			}, {
				InputField = Roact.createElement(MessageInputField, {
					plugin = props.plugin,
				}),
			}),

			Options = Roact.createElement(ListBox, {
				layoutOrder = 2,
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
				layoutOrder = 3,
				size = UDim2.new(1, 0, 1, 0)
			})
		})
	end)
end

return App
