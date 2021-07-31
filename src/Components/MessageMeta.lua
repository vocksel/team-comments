local TeamComments = script:FindFirstAncestor("TeamComments")

local Players = game:GetService("Players")

local Promise = require(TeamComments.Packages.Promise)
local Roact = require(TeamComments.Packages.Roact)
local t = require(TeamComments.Packages.t)
local Immutable = require(TeamComments.Lib.Immutable)
local Types = require(TeamComments.Types)
local Styles = require(TeamComments.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)

local fetchPlayerName = Promise.promisify(function(userId)
	return Players:GetNameFromUserIdAsync(tonumber(userId))
end)

local Props = t.interface({
	message = Types.IMessage,
	size = t.UDim2,
	LayoutOrder = t.integer,
})

local MessageMeta = Roact.Component:extend("MessageMeta")

function MessageMeta:init()
	self.state = {
		name = nil,
	}
end

function MessageMeta:render()
	assert(Props(self.props))

	local date = os.date("*t", self.props.message.createdAt)
	local formattedDate = ("%02i/%02i/%i"):format(date.month, date.day, date.year)

	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = self.props.size,
			LayoutOrder = self.props.LayoutOrder,
		}, {
			Name = Roact.createElement(
				"TextLabel",
				Immutable.join(Styles.Text, {
					Text = self.state.name,
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
	end)
end

function MessageMeta:didMount()
	fetchPlayerName(self.props.message.userId):andThen(function(name)
		self:setState({
			name = name,
		})
	end)
end

return MessageMeta
