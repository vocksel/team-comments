local CreateReducer = require(script.Parent.Parent.Packages.Rodux).createReducer
local Immutable = require(script.Parent.Parent.Lib.Immutable)

local ui = CreateReducer({
	areMessagesVisible = true,
}, {
	ToggleMessagesVisibility = function(state)
		return Immutable.join(state, {
			areMessagesVisible = not state.areMessagesVisible
		})
	end
})

return ui
