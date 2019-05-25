local createReducer = require(script.Parent.Parent.lib.Rodux).createReducer
local immutable = require(script.Parent.Parent.lib.immutable)
local types = require(script.Parent.Parent.types)

local messages = createReducer({
	-- [id] = { authorId, body, id, time }
}, {
	CreateMessage = function(state, action)
		local message = action.message

		assert(types.IMessage(message))

		return immutable.join(state, {
			[action.message.id] = message
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
