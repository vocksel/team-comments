local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)
local t = require(TeamComments.Packages.t)
local types = require(TeamComments.Types)
local CameraDistanceProvider = require(script.Parent.CameraDistanceProvider)
local Comment = require(script.Parent.Comment)

local CommentBillboard = Roact.Component:extend("CommentBillboard")

CommentBillboard.validateProps = t.interface({
	messagePart = t.instance("Part"),
	message = types.IMessage,
})

function CommentBillboard:init()
	self.onActivated = function()
		print("focus")
	end
end

function CommentBillboard:render()
	return Roact.createElement(CameraDistanceProvider, {
		origin = self.props.messagePart.Position,
		render = function(distance)
			return Roact.createElement("BillboardGui", {
				MaxDistance = math.huge,
				Size = UDim2.fromOffset(400, 200),
				LightInfluence = 0,
				Adornee = self.props.messagePart,
				Active = true,
			}, {
				Layout = Roact.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
				}),

				Comment = distance <= 100 and Roact.createElement(Comment, {
					message = self.props.message,
				}),

				Bubble = distance > 100 and Roact.createElement("ImageButton", {
					Size = UDim2.fromOffset(64, 64),
					[Roact.Event.Activated] = self.onActivated,
				}),
			})
		end,
	})
end

return CommentBillboard
