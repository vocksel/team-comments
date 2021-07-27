local Roact = require(script.Parent.Parent.Packages.Roact)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
-- local ToggleVisibilityCheckbox = require(script.Parent.ToggleVisibilityCheckbox)
local Styles = require(script.Parent.Parent.Styles)
local MessageInputField = require(script.Parent.MessageInputField)
local MessageContext = require(script.Parent.MessageContext)
local Comment = require(script.Parent.Comment)

local function App(props)
    return StudioThemeAccessor.withTheme(function(theme)
        -- FIXME: The scrolling frame doesn't update when new messages are
        -- added. Requires the widget to be resized first.
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

            MessageList = Roact.createElement("Frame", {
                LayoutOrder = 3,
                Size = UDim2.fromScale(1, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
            }, {
                Roact.createElement(MessageContext.Consumer, {
                    render = function(context)
                        local children = {}

                        children.Layout = Roact.createElement("UIListLayout", {
                            SortOrder = Enum.SortOrder.LayoutOrder,
                        })

                        for index, message in ipairs(context.getOrderedMessages()) do
                            children[message.id] = Roact.createElement(Comment, {
                                LayoutOrder = index,
                                message = message,
                            })
                        end

                        return Roact.createFragment(children)
                    end
                })
            })

        })
    end)
end

return App
