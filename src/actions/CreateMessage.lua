local action = require(script.Parent.Parent.action)
local t = require(script.Parent.Parent.t)

local check = t.tuple(t.string, t.string, t.number)

return action(script.Name, function(id, authorId, time)
	assert(check(id, authorId, time))

	return {
		message = {
			id = id,
			authorId = authorId,
			time = time,
			body = ""
		}
	}
end)
