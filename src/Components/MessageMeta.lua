local Players = game:GetService("Players")

local Promise = require(script.Parent.Parent.Packages.Promise)
local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Types = require(script.Parent.Parent.Types)
local Styles = require(script.Parent.Parent.Styles)
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local TextLabel = require(script.Parent.TextLabel)

local fetchPlayerName = Promise.promisify(function(userId)
    return Players:GetNameFromUserIdAsync(tonumber(userId))
end)

local Props = t.interface({
    message = Types.IMessage,
    size = t.UDim2,
    LayoutOrder = t.integer
})

function MessageMeta:init()
    self.state = {
        name = nil
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
            Name = Roact.createElement(TextLabel, {
                Text = self.state.name,
                Font = Styles.HeaderFont,
                TextSize = Styles.HeaderTextSize,
                TextColor3 = theme:GetColor("MainText"),
            }),

            Date = Roact.createElement(TextLabel, {
                Text = formattedDate,
                TextColor3 = theme:GetColor("DimmedText"),
                TextXAlignment = Enum.TextXAlignment.Right,

                -- align right
                Position = UDim2.new(1, 0, 0, 0),
                AnchorPoint = Vector2.new(1, 0)
            })
        })
    end)
end

function MessageMeta:didMount()
    fetchPlayerName(self.props.message.userId):andThen(function(name)
        self:setState({
            name = name
        })
    end)
end

return MessageMeta
