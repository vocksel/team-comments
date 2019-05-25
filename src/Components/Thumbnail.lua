--[[
  Provides a player's thumbnail to other components.

  Usage:

    Roact.createElement(Thumbnail, {
        userId = "-1", -- Must be a string
        render = function(thumbnail)

            return Roact.createElement("ImageLabel", {
                Image = thumbnail.image
            })

        end
    })
--]]

local Players = game:GetService("Players")

local Promise = require(script.Parent.Parent.Lib.Promise)
local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)

-- Must be one of the values from here:
-- http://wiki.roblox.com/index.php?title=API:Enum/ThumbnailSize
local AVATAR_SIZE = 420

local function fetchUserThumbnail(userId, thumbnailType)
	thumbnailType = thumbnailType or Enum.ThumbnailType.AvatarBust

	local size = ("Size{size}x{size}"):gsub("{size}", AVATAR_SIZE)

	return Promise.new(function(resolve, reject)
		spawn(function()
			local ok, result = pcall(function()
				return Players:GetUserThumbnailAsync(tonumber(userId),
					thumbnailType, Enum.ThumbnailSize[size])
			end)

			if ok then
				resolve(result)
			else
				reject(result)
			end
		end)
	end)
end

local Thumbnail = Roact.Component:extend("Thumbnail")

local Props = t.interface({
    userId = t.string,
    render = t.callback,
    type = t.optional(t.enum(Enum.ThumbnailType))
})

function Thumbnail:init()
    self.state = {
        image = ""
    }
end

function Thumbnail:render()
    assert(Props(self.props))

    return self.props.render({
        image = self.state.image,
        size = Vector2.new(AVATAR_SIZE, AVATAR_SIZE)
    })
end

function Thumbnail:didMount()
    fetchUserThumbnail(self.props.userId, self.props.thumbnailType)
		:andThen(function(image)
            self:setState({ image = image })
        end)
end

return Thumbnail
