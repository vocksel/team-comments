local Root = script:FindFirstAncestor("TeamComments")
local Roact = require(Root.Packages.Roact)

return {
    name = Root.Name,
    roact = Roact,
    storyRoots = {
        Root.Components,
    },
}
