local combineReducers = require(script.Parent.lib.Rodux).combineReducers

local reducer = combineReducers({
	areMessagesVisible = require(script.areMessagesVisible),
	messages = require(script.messages)
})

return reducer
