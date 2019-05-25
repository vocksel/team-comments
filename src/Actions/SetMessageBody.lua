local Action = require(script.Parent.Parent.Lib.Action)
local t = require(script.Parent.Parent.Lib.t)

local check = t.tuple(t.string, t.string)

return Action(script.Name, function(id, newBody)
	assert(check(id, newBody))

	return {
		id = id,
		newBody = newBody
	}
end)
