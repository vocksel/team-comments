local combineReducers = require(script.Parent.Packages.Rodux).combineReducers

local reducer = combineReducers({
	ui = require(script.UI),
	messages = require(script.Messages)
})

return reducer
