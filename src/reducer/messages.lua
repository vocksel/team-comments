local createReducer = require(script.Parent.Parent.Rodux).createReducer
local immutable = require(script.Parent.Parent.immutable)
local t = require(script.Parent.Parent.t)

local IMessage = t.interface({
	id = t.string,
	authorId = t.string,
	body = t.string,
	time = t.number,
})

local messages = createReducer({
	-- [id] = { authorId, body, id, time }
}, {
	CreateMessage = function(state, action)
		local message = action.message

		assert(IMessage(message))

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
