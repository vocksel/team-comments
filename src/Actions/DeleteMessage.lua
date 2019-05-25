local Action = require(script.Parent.Parent.Lib.Action)
local t = require(script.Parent.Parent.Lib.t)

local check = t.tuple(t.string)

return Action(script.Name, function(id)
	assert(check(id))

	return {
		id = id
	}
end)
