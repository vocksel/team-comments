local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Immutable = require(TeamComments.Lib.Immutable)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local useTheme = require(TeamComments.Hooks.useTheme)
local useName = require(TeamComments.Hooks.useName)

local Props = t.interface({
	message = Types.Message,
	size = t.UDim2,
	LayoutOrder = t.integer,
})

local function MessageMeta(props, hooks)
	assert(Props(props))

	local date = os.date("*t", props.message.createdAt)
	local formattedDate = ("%02i/%02i/%i"):format(date.month, date.day, date.year)

	local theme = useTheme(hooks)
	local name = useName(hooks, props.message.userId)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = props.size,
		LayoutOrder = props.LayoutOrder,
	}, {
		Name = Roact.createElement(
			"TextLabel",
			Immutable.join(Styles.Text, {
				Text = name,
				Font = Styles.HeaderFont,
				TextSize = Styles.Header.TextSize,
				TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
			})
		),

		Date = Roact.createElement(
			"TextLabel",
			Immutable.join(Styles.Text, {
				Text = formattedDate,
				TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.DimmedText),
				TextXAlignment = Enum.TextXAlignment.Right,
				-- align right
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
			})
		),
	})
end

return Hooks.new(Roact)(MessageMeta)
