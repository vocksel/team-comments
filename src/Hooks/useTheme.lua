local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)

local function useTheme()
    local studio = React.useMemo(function()
        return settings().Studio
    end, {})

    local theme, set = React.useState(studio.Theme)

    React.useEffect(function()
        local conn = studio.ThemeChanged:Connect(function()
            set(studio.Theme)
        end)

        return function()
            conn:Disconnect()
        end
    end, {})

    return theme
end

return useTheme
