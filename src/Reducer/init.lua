local combineReducers = require(script.Parent.Lib.Rodux).combineReducers

local reducer = combineReducers({
	areMessagesVisible = require(script.AreMessagesVisible),
	messages = require(script.Messages)
})

return reducer
