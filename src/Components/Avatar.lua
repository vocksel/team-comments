local Players = game:GetService("Players")
local Promise = require(script.Parent.Parent.Packages.Promise)
local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)

local Avatar = Roact.Component:extend("Avatar")

local Props = t.interface({
    userId = t.string,
    maskColor = t.optional(t.Color3),
    LayoutOrder = t.optional(t.integer),
})

function Avatar:init()
    self.state = {
        image = ""
    }

    self.fetchPlayerThumbnail = Promise.promisify(function(userId: string)
        return Players:GetUserThumbnailAsync(
            tonumber(userId),
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)
end

function Avatar:render()
    assert(Props(self.props))

    return Roact.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        LayoutOrder = self.props.LayoutOrder,
    }, {
        AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 1,
        }),

        Mask = Roact.createElement("ImageLabel", {
            Image = "rbxassetid://3214902128",
            ImageColor3 = self.props.maskColor,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 2
        }),

        Icon = Roact.createElement("ImageLabel", {
            Image = self.state.image,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
        })
    })
end

function Avatar:didMount()
    self.fetchPlayerThumbnail(self.props.userId):andThen(function(image)
        self:setState({
            image = image
        })
    end)
end

return Avatar
