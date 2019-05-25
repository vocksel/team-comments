local action = require(script.Parent.Parent.lib.action)
local t = require(script.Parent.Parent.lib.t)

local check = t.tuple(t.string, t.string)

return action(script.Name, function(id, newBody)
	assert(check(id, newBody))

	return {
		id = id,
		newBody = newBody
	}
end)
