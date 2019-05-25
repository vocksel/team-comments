local createReducer = require(script.Parent.Parent.lib.Rodux).createReducer

local areMessagesVisible = createReducer(true, {
	ToggleMessagesVisibility = function(state)
		return not state
	end
})

return areMessagesVisible
