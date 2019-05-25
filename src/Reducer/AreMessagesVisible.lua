local CreateReducer = require(script.Parent.Parent.Lib.Rodux).createReducer

local areMessagesVisible = CreateReducer(true, {
	ToggleMessagesVisibility = function(state)
		return not state
	end
})

return areMessagesVisible
