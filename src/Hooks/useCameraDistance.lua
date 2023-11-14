local TeamComments = script:FindFirstAncestor("TeamComments")

local RunService = game:GetService("RunService")

local React = require(TeamComments.Packages.React)

local function useCameraDistance(origin: Vector3)
    local distance, set = React.useState(math.huge)

    React.useEffect(function()
        local conn = RunService.Heartbeat:Connect(function()
            local camera = workspace.CurrentCamera

            if camera then
                set((origin - camera.CFrame.p).Magnitude)
            end
        end)

        return function()
            conn:Disconnect()
        end
    end, {
        origin,
    })

    return distance
end

return useCameraDistance
