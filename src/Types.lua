local t = require(script.Parent.Packages.t)

local types = {}

types.IMessage = t.interface({
	id = t.string,
	userId = t.string,
	text = t.string,
	createdAt = t.number,
})

return types
