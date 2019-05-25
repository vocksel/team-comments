--[[
	Provides a player's name to other components.

  Usage:

    Roact.createElement(PlayerName, {
        userId = "-1", -- Must be a string
        render = function(name)
            return Roact.createElement("TextLabel", {
                Text = "Hello, " .. name .. "!"
            })
        end
    })
--]]

local Players = game:GetService("Players")

local Promise = require(script.Parent.Parent.Lib.Promise)
local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)

local function fetchPlayerName(userId)
	return Promise.new(function(resolve, reject)
		spawn(function()
			local ok, result = pcall(function()
				return Players:GetNameFromUserIdAsync(tonumber(userId))
			end)

			if ok then
				resolve(result)
			else
				reject(result)
			end
		end)
	end)
end

local PlayerName = Roact.Component:extend("PlayerName")

local Props = t.interface({
    userId = t.string,
    render = t.callback,
})

function PlayerName:init()
    self.state = {
        name = ""
    }
end

function PlayerName:render()
    assert(Props(self.props))
    return self.props.render(self.state.name)
end

function PlayerName:didMount()
    fetchPlayerName(self.props.userId)
		:andThen(function(name)
            self:setState({ name = name })
        end)
end

return PlayerName
