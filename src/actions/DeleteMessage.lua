local action = require(script.Parent.Parent.lib.action)
local t = require(script.Parent.Parent.lib.t)

local check = t.tuple(t.string)

return action(script.Name, function(id)
	assert(check(id))

	return {
		id = id
	}
end)
