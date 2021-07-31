local Roact = require(script.Parent.Parent.Packages.Roact)
local Messages = require(script.Parent.Parent.Messages)
local MessageContext = require(script.Parent.MessageContext)
local CommentBillboard = require(script.Parent.CommentBillboard)

local function BillboardApp()
    -- if props.ui.areMessagesVisible then
    return Roact.createElement(MessageContext.Consumer, {
        render = function(context)
            local children = {}

            for _, message in pairs(context.messages) do
                children[message.id] = Roact.createElement(CommentBillboard, {
                    messagePart = Messages.getMessagePartById(message.id),
                    message = message,
                })
            end

            return Roact.createElement("Folder", {}, children)
        end
    })
    -- end
end

return BillboardApp
