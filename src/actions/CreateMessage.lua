local action = require(script.Parent.Parent.action)
local t = require(script.Parent.Parent.t)

local check = t.tuple(t.string, t.string, t.number, t.Vector3)

return action(script.Name, function(id, authorId, time, position)
	assert(check(id, authorId, time, position))

	return {
		message = {
			id = id,
			authorId = authorId,
			time = time,
			position = position,
			body = ""
		}
	}
end)
