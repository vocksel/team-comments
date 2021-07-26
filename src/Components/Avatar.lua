
local Roact = require(script.Parent.Parent.Packages.Roact)
local t = require(script.Parent.Parent.Packages.t)
local Thumbnail = require(script.Parent.Thumbnail)

local function mirrorX(x, y)
    return Vector2.new(x, 0), Vector2.new(-x, y)
end

local Props = t.interface({
    userId = t.string,
    size = t.optional(t.UDim2),
    sizeConstraint = t.optional(t.enum(Enum.SizeConstraint)),
    maskColor = t.optional(t.Color3),
    LayoutOrder = t.optional(t.integer),
    mirrored = t.optional(t.boolean),
})

local function Avatar(props)
    assert(Props(props))

    return Roact.createElement(Thumbnail, {
        userId = props.userId,
        render = function(thumbnail)
            local rectOffset, rectSize
            if props.mirrored then
                rectOffset, rectSize = mirrorX(thumbnail.size.X, thumbnail.size.Y)
            end

            return Roact.createElement("Frame", {
                SizeConstraint = props.sizeConstraint or Enum.SizeConstraint.RelativeXX,
                Size = props.size or UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                LayoutOrder = props.LayoutOrder,
            }, {
                Mask = Roact.createElement("ImageLabel", {
                    Image = "rbxassetid://3214902128",
                    ImageColor3 = props.maskColor,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 2
                }),

                Icon = Roact.createElement("ImageLabel", {
                    Image = thumbnail.image,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    ImageRectOffset = rectOffset,
                    ImageRectSize = rectSize
                })
            })

        end
    })
end

return Avatar
