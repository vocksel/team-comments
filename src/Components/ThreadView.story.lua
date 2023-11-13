local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local MessageContext = require(TeamComments.Context.MessageContext)
local ThreadView = require(script.Parent.ThreadView)

local MESSAGES = {
    ["1"] = {
        id = "1",
        userId = "1343930",
        text = "Hello World!",
        createdAt = os.time(),
        responses = {
            "2",
            "3",
        },
    },
    ["2"] = {
        id = "2",
        userId = "29819622",
        text = "A response to the comment",
        createdAt = os.time() + 100000,
        responses = {},
        parentId = "1",
    },
    ["3"] = {
        id = "3",
        userId = "103649798",
        text = "Another response in the thread",
        createdAt = os.time() + 200000,
        responses = {},
        parentId = "1",
    },
}

return {
    story = function()
        return Roact.createElement(MessageContext.Provider, nil, {
            Wrapper = Roact.createElement("Frame", {
                Size = UDim2.new(0, 500, 1, 0),
                BackgroundTransparency = 1,
            }, {
                ThreadView = Roact.createElement(ThreadView, {
                    userId = "1343930",
                    message = MESSAGES["1"],
                    messages = MESSAGES,
                }),
            }),
        })
    end,
}
