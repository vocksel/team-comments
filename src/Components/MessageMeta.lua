local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Llama = require(TeamComments.Packages.Llama)
local types = require(TeamComments.types)
local styles = require(TeamComments.styles)
local useTheme = require(TeamComments.Hooks.useTheme)
local useName = require(TeamComments.Hooks.useName)

local function getDateString(timestamp)
	-- Aug 02, 07:26 PM
	local formatStr = "%b %d, %I:%M %p"

	local dateObj = os.date("*t", timestamp)

	if dateObj.year ~= os.date("*t").year then
		-- Aug 02 2021, 07:26 PM
		formatStr = "%b %d %Y, %I:%M %p"
	end

	return os.date(formatStr, timestamp)
end

local validateProps = t.interface({
	message = types.Message,
	size = t.UDim2,
	LayoutOrder = t.integer,
})

local function MessageMeta(props, hooks)
	assert(validateProps(props))

	local theme = useTheme(hooks)
	local name = useName(hooks, props.message.userId)

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = props.size,
		LayoutOrder = props.LayoutOrder,
	}, {
		Name = Roact.createElement(
			"TextLabel",
			Llama.Dictionary.join(styles.Text, {
				Text = name,
				Font = styles.HeaderFont,
				TextSize = styles.Header.TextSize,
				TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
			})
		),

		Date = Roact.createElement(
			"TextLabel",
			Llama.Dictionary.join(styles.Text, {
				Text = getDateString(props.message.createdAt),
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
