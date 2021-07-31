local TeamComments = script:FindFirstAncestor("TeamComments")

local RunService = game:GetService("RunService")

local Roact = require(TeamComments.Packages.Roact)
local t = require(TeamComments.Packages.t)

local Props = t.interface({
	origin = t.Vector3,
	render = t.callback,
})

local CameraDistanceProvider = Roact.Component:extend("CameraDistanceProvider")

function CameraDistanceProvider:init()
	self.state = {
		distance = 0,
	}
end

function CameraDistanceProvider:render()
	assert(Props(self.props))
	return self.props.render(self.state.distance)
end

function CameraDistanceProvider:didMount()
	self.connection = RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		local distance = (self.props.origin - camera.CFrame.p).Magnitude
		self:setState({ distance = distance })
	end)
end

function CameraDistanceProvider:willUnmount()
	self.connection:Disconnect()
end

return CameraDistanceProvider
