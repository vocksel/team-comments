local CreateReducer = require(script.Parent.Parent.Packages.Rodux).createReducer
local Immutable = require(script.Parent.Parent.Lib.Immutable)
local Types = require(script.Parent.Parent.Types)

local messages = CreateReducer({
	-- [id] = { authorId, body, id, time }
}, {
	CreateMessage = function(state, action)
		local message = action.message

		assert(Types.IMessage(message))

		return Immutable.join(state, {
			[action.message.id] = message
		})
	end,

	DeleteMessage = function(state, action)
		return Immutable.set(state, action.id, nil)
	end,

	SetMessageBody = function(state, action)
		local newMessage = Immutable.join(state[action.id], {
			body = action.newBody
		})

		return Immutable.join(state, {
			[action.id] = newMessage
		})
	end
})

return messages
