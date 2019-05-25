local combineReducers = require(script.Parent.Lib.Rodux).combineReducers

local reducer = combineReducers({
	ui = require(script.UI),
	messages = require(script.Messages)
})

return reducer
