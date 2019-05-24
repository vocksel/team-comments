local createReducer = require(script.Parent.Parent.Rodux).createReducer
local immutable = require(script.Parent.Parent.immutable)

local messages = createReducer({
	-- [id] = { authorId, body, id, time }
}, {
	CreateMessage = function(state, action)
		return immutable.join(state, {
			[action.id] = {
				id = action.id,
				authorId = action.authorId,
				time = action.time,
				body = ""
			}
		})
	end,

	DeleteMessage = function(state, action)
		return immutable.set(state, action.id, nil)
	end,

	SetMessageBody = function(state, action)
		local newMessage = immutable.join(state[action.id], {
			body = action.newBody
		})

		return immutable.join(state, {
			[action.id] = newMessage
		})
	end
})

return messages
