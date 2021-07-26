local Roact = require(script.Parent.Parent.Packages.Roact)
local Connect = require(script.Parent.Parent.Packages.RoactRodux).connect
local BillboardMessage = require(script.Parent.BillboardMessage)
local Config = require(script.Parent.Parent.Config)
local Messages = require(script.Parent.Parent.Messages)
local CameraDistanceProvider = require(script.Parent.CameraDistanceProvider)

local function BillboardApp(props)
	if props.ui.areMessagesVisible then
		local children = {}

		for _, message in pairs(props.messages) do
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
                        Roact.createElement(BillboardMessage, {
                            message = message,
                            distance = distance,
                        })
                    })
                end
            })
        end

		return Roact.createElement("Folder", {}, children)
	end
end

local function mapStateToProps(state)
	return {
		messages = state.messages,
		ui = state.ui,
	}
end

return Connect(mapStateToProps)(BillboardApp)
