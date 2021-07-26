local Roact = require(script.Parent.Parent.Packages.Roact)
local Connect = require(script.Parent.Parent.Packages.RoactRodux).connect
local t = require(script.Parent.Parent.Packages.t)
local ToggleOption = require(script.Parent.ToggleOption)
local ToggleMessagesVisibility = require(script.Parent.Parent.Actions.ToggleMessagesVisibility)

local Props = t.interface({
	areMessagesVisible = t.boolean,
	toggleVisibility = t.callback,
	layoutOrder = t.optional(t.integer),
})

local function ToggleVisibilityCheckbox(props)
	assert(Props(props))

	return Roact.createElement(ToggleOption, {
		text = "Show messages",
		layoutOrder = props.layoutOrder,
		isChecked = props.areMessagesVisible,
		onClick = props.toggleVisibility
	})
end

local function mapStateToProps(state)
	return {
		areMessagesVisible = state.ui.areMessagesVisible
	}
end

local function mapDispatchToProps(dispatch)
	return {
		toggleVisibility = function()
			dispatch(ToggleMessagesVisibility())
		end
	}
end

return Connect(mapStateToProps, mapDispatchToProps)(ToggleVisibilityCheckbox)
