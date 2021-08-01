local t = require(script.Parent.Packages.t)

local types = {}

types.IMessage = t.interface({
	id = t.string,
	userId = t.string,
	text = t.string,
	createdAt = t.number,
	responses = t.optional(t.array(t.string)),
	parentId = t.optional(t.string),
})

return types
