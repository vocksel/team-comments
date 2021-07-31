local Players = game:GetService("Players")

local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local useAvatar = require(TeamComments.Hooks.useAvatar)

local validateProps = t.interface({
	LayoutOrder = t.optional(t.number),
	userId = t.string,
	maskColor = t.optional(t.Color3),
})

local function Avatar(props, hooks)
	assert(validateProps(props))

	local avatar = useAvatar(hooks, props.userId)

	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
	}, {
		AspectRatio = Roact.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1,
		}),

		Mask = Roact.createElement("ImageLabel", {
			Image = "rbxassetid://3214902128",
			ImageColor3 = props.maskColor,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
		}),

		Icon = Roact.createElement("ImageLabel", {
			Image = avatar,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
		}),
	})
end

return Hooks.new(Roact)(Avatar)
