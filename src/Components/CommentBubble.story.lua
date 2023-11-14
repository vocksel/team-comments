--!strict
local TeamComments = script:FindFirstAncestor("TeamComments")

local React = require(TeamComments.Packages.React)
local CommentBubble = require(script.Parent.CommentBubble)

local function Story()
    local isShown, set = React.useState(true)

    React.useEffect(function()
        local isLooping = true

        coroutine.wrap(function()
            while isLooping do
                set(function(prev)
                    return not prev
                end)

                wait(2)
            end
        end)()

        return function()
            isLooping = false
        end
    end, {})

    return React.createElement("Frame", {
        Size = UDim2.fromScale(1, 1),
    }, {
        React.createElement(CommentBubble, {
            isShown = isShown,
            message = {
                id = "1",
                userId = "1343930",
                text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean vel leo bibendum, efficitur eros vel, tincidunt est. Aenean augue velit, volutpat et posuere quis, fermentum quis purus. Etiam est risus, fringilla sit amet elementum eget, elementum eu tellus. Vestibulum vehicula nibh felis, at gravida metus rhoncus eu. Curabitur ornare sodales varius.",
                createdAt = os.time(),
                position = Vector3.new(),
                responses = {},
            },
            onActivated = function()
                print("clicked")
            end,
        }),
    })
end

return {
    story = function()
        return React.createElement(Story)
    end,
}
