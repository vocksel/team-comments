local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)
local Styles = require(script.Parent.Parent.Styles)

local Props = t.interface({
	size = t.optional(t.integer)
})

local function Padding(props)
	assert(Props(props))

	local size = props.size or Styles.Padding

	return Roact.createElement("UIPadding", {
		PaddingTop = UDim.new(0, size),
		PaddingRight = UDim.new(0, size),
		PaddingBottom = UDim.new(0, size),
		PaddingLeft = UDim.new(0, size),
	})
end

return Padding
