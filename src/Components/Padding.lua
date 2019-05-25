local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)

local Props = t.interface({
	size = t.integer
})

local function Padding(props)
	assert(Props(props))

	return Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, props.size),
		PaddingRight = UDim.new(0, props.size),
		PaddingBottom = UDim.new(0, props.size),
		PaddingLeft = UDim.new(0, props.size),
	})
end

return Padding
