local CollectionService = game:GetService("CollectionService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Config = require(script.Parent.Config)

local messages = {}

--[[
    Gets a messagePart by its ID.
]]
function messages.getMessagePartById(messageId)
    for _, messagePart in pairs(CollectionService:GetTagged(Config.TAG_NAME)) do
        if messagePart.Id.Value == messageId then
            return messagePart
        end
    end
end

--[[
    Focuses a message part by its ID.

    This is like the Zoom To action in Studio, which will focus something in
    your selection.
]]
function messages.focus(messageId)
    local messagePart = messages.getMessagePartById(messageId)
    local camera = workspace.CurrentCamera
    local orientation = camera.CFrame-camera.CFrame.p
    local newCFrame = CFrame.new(messagePart.Position) * orientation

    camera.Focus = messagePart.CFrame
    camera.CFrame = newCFrame * CFrame.new(-Config.PUSHBACK_FROM_FOCUS, 0, 0)
end

function messages.delete(messageId)
    -- We can just remove TeamComment parts because the state is
    -- controlled by them being added/removed from the game.
    local messagePart = messages.getMessagePartById(messageId)
    messagePart.Parent = nil
    ChangeHistoryService:SetWaypoint("Deleted TeamComment")
end

return messages
