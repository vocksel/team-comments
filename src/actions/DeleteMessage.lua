local action = require(script.Parent.Parent.action)
local t = require(script.Parent.Parent.t)

local check = t.tuple(t.string)

return action(script.Name, function(id)
	assert(check(id))

	return {
		id = id
	}
end)
