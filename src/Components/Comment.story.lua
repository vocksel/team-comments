local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local MessageContext = require(TeamComments.Context.MessageContext)
local Comment = require(script.Parent.Comment)

return {
    story = function()
        return Roact.createElement(MessageContext.Provider, nil, {
            Wrapper = Roact.createElement("Frame", {
                Size = UDim2.fromScale(0.5, 0.8),
                BackgroundTransparency = 1,
            }, {
                Comment = Roact.createElement(Comment, {
                    message = {
                        id = "1",
                        userId = "1343930",
                        text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel leo bibendum, efficitur eros vel, tincidunt est. Aenean augue velit, volutpat et posuere quis, fermentum quis purus. Etiam est risus, fringilla sit amet elementum eget, elementum eu tellus. Vestibulum vehicula nibh felis, at gravida metus rhoncus eu. Curabitur ornare sodales varius.",
                        createdAt = os.time(),
                        position = Vector3.new(),
                        responses = {},
                    },
                }),
            }),
        })
    end,
}
