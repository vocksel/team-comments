local Action = require(script.Parent.Parent.Lib.Action)
local t = require(script.Parent.Parent.Packages.t)

local check = t.tuple(t.string, t.string, t.number)

return Action(script.Name, function(id, authorId, time)
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
