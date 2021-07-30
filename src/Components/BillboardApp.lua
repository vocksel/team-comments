local Roact = require(script.Parent.Parent.Packages.Roact)
local Comment = require(script.Parent.Comment)
local Config = require(script.Parent.Parent.Config)
local Messages = require(script.Parent.Parent.Messages)
local CameraDistanceProvider = require(script.Parent.CameraDistanceProvider)
local MessageContext = require(script.Parent.MessageContext)

local function BillboardApp()
    -- if props.ui.areMessagesVisible then
    return Roact.createElement(MessageContext.Consumer, {
        render = function(context)
            local children = {}

            for _, message in pairs(context.messages) do
                local messagePart = Messages.getMessagePartById(message.id)

                children[message.id] = Roact.createElement(CameraDistanceProvider, {
                    origin = messagePart.Position,
                    render = function(distance)
                        return Roact.createElement("BillboardGui", {
                            MaxDistance = Config.BILLBOARD_MAX_DISTANCE,
                            Size = UDim2.new(0, 450, 0, 200),
                            LightInfluence = 0,
                            Adornee = messagePart
                        }, {
                            Roact.createElement(Comment, {
                                message = message,
                                distance = distance,
                            })
                        })
                    end
                })
            end

            return Roact.createElement("Folder", {}, children)
        end
    })
    -- end
end

return BillboardApp
