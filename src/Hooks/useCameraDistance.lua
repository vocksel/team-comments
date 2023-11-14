local RunService = game:GetService("RunService")

local function useCameraDistance(hooks, origin)
    local distance, set = hooks.useState(math.huge)

    hooks.useEffect(function()
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
