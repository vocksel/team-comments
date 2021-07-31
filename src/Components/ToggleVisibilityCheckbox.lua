local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Connect = require(TeamComments.Packages.RoactRodux).connect
local t = require(TeamComments.Packages.t)
local ToggleOption = require(script.Parent.ToggleOption)
local ToggleMessagesVisibility = require(TeamComments.Actions.ToggleMessagesVisibility)

local Props = t.interface({
    areMessagesVisible = t.boolean,
    toggleVisibility = t.callback,
    LayoutOrder = t.optional(t.integer),
})

local function ToggleVisibilityCheckbox(props)
    assert(Props(props))

    return Roact.createElement(ToggleOption, {
        text = "Show messages",
        LayoutOrder = props.LayoutOrder,
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
