local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Immutable = require(TeamComments.Lib.Immutable)
local t = require(TeamComments.Packages.t)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local TextLabel = require(script.Parent.TextLabel)

local Props = t.interface({
	style = t.optional(t.string),
	state = t.optional(t.string),
})

local function ThemedTextLabel(props)
	assert(Props(props))

	local style = props.style or "MainText"
	local state = props.state or "Default"

	return StudioThemeAccessor.withTheme(function(theme)
		local newProps = Immutable.join({
			TextColor3 = theme:GetColor(style, state),
		}, props)

		return Roact.createElement(TextLabel, newProps)
	end)
end

return ThemedTextLabel
