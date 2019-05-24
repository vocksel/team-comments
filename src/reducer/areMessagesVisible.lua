local createReducer = require(script.Parent.Parent.Rodux).createReducer

local areMessagesVisible = createReducer(true, {
	ToggleMessagesVisibility = function(state)
		return not state
	end
})

return areMessagesVisible
