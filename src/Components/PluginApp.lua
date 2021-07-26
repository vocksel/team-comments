local Roact = require(script.Parent.Parent.Packages.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local MessageList = require(script.Parent.MessageList)
-- local ToggleVisibilityCheckbox = require(script.Parent.ToggleVisibilityCheckbox)
local Styles = require(script.Parent.Parent.Styles)
local MessageInputField = require(script.Parent.MessageInputField)

local function App(props)
	return StudioThemeAccessor.withTheme(function(theme)
        return Roact.createElement("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.fromScale(1, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollingDirection = Enum.ScrollingDirection.Y,
        }, {
            Layout = Roact.createElement("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),

            InputField = Roact.createElement(MessageInputField, {
                LayoutOrder = 1,
                userId = props.userId,
            }),

            Options = Roact.createElement("Frame", {
                LayoutOrder = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                Size = UDim2.fromScale(1, 0),
                BackgroundColor3 = theme:GetColor("Light")
            }, {
                Padding = Roact.createElement("UIPadding", {
                    PaddingTop = UDim.new(0, Styles.Padding),
                    PaddingRight = UDim.new(0, Styles.Padding),
                    PaddingBottom = UDim.new(0, Styles.Padding),
                    PaddingLeft = UDim.new(0, Styles.Padding),
                }),

                -- FIXME: Porting over to Roact Context from Rodux. Don't have
                -- any UI settings in place yet, so this still needs to be added.
                -- TODO: Create an action for each toggle so that the user can
				-- easily bind keys to them.
				-- ToggleVisibility = Roact.createElement(ToggleVisibilityCheckbox)
            }),

			List = Roact.createElement(MessageList, {
				LayoutOrder = 3,
			})
		})
	end)
end

return App
