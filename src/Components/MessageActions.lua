local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local t = require(TeamComments.Packages.t)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local MessageContext = require(TeamComments.Context.MessageContext)
local Button = require(script.Parent.Button)

local Props = t.interface({
    message = Types.IMessage,
    size = t.UDim2,
    LayoutOrder = t.integer,
})

local function MessageActions(props)
    assert(Props(props))

    return Roact.createElement(MessageContext.Consumer, {
        render = function(context)
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
                        context.focusMessagePart(props.message.id)
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
                        context.deleteMessage(props.message.id)
                    end
                })
            })
        end
    })
end

return MessageActions
