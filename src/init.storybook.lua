local Root = script:FindFirstAncestor("TeamComments")
local React = require(Root.Packages.React)
local ReactRoblox = require(Root.Packages.ReactRoblox)

return {
    name = Root.Name,
    react = React,
    reactRoblox = ReactRoblox,
    storyRoots = {
        Root.Components,
    },
}
