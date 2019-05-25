
local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.t)
local Thumbnail = require(script.Parent.Thumbnail)

local function mirrorX(x, y)
	return Vector2.new(x, 0), Vector2.new(-x, y)
end

local Props = t.interface({
    userId = t.string,
	mirrored = t.optional(t.boolean)
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

            return Roact.createElement("ImageLabel", {
                Image = thumbnail.image,
                BackgroundTransparency = 1,
                SizeConstraint = Enum.SizeConstraint.RelativeXX,
                Size = UDim2.new(1, 0, 1, 0),
                ImageRectOffset = rectOffset,
                ImageRectSize = rectSize
            })
        end
    })
end

return Avatar
