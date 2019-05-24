local combineReducers = require(script.Parent.Rodux).combineReducers

local reducer = combineReducers({
	areMessagesVisible = require(script.areMessagesVisible),
	messages = require(script.messages)
})

return reducer
