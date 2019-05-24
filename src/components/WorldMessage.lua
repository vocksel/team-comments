local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.t)

local config = require(script.Parent.Parent.config)

local Props = t.interface({
	adornee = t.instanceIsA("BasePart")
})

local function Billboard(props)
	assert(Props(props))

	return Roact.createElement("BillboardGui", {
		MaxDistance = config.BILLBOARD_MAX_DISTANCE,
		Size = UDim2.new(10, 0, 6, 0),
		LightInfluence = 0,
		Adornee = props.adornee
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		})
	})
end

return Billboard
