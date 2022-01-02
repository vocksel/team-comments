local TeamComments = script:FindFirstAncestor("TeamComments")

local Flipper = require(TeamComments.Packages.Flipper)

local function getDefaultCameraState()
	return Instance.new("Camera").CameraType
end

--[=[
    Smoothly zooms the camera to a BasePart.

    This is used as a means of focusing comment bubbles. When a comment is
    selected, the user's camera is sent to the position of the comment bubble
    so that the user has context about where the comment was left.
]=]
local function zoom(goal: BasePart)
	local motor = Flipper.SingleMotor.new(0)
	local camera = workspace.CurrentCamera
	local start = camera.CFrame.Position
	local orientation = camera.CFrame - start
	local goalPos = goal.Position - (camera.CFrame.LookVector * 15)

	camera.CameraType = Enum.CameraType.Scriptable
	camera.Focus = goal.CFrame

	motor:onStep(function(alpha)
		camera.CFrame = CFrame.new(start:Lerp(goalPos, alpha)) * orientation
	end)

	motor:setGoal(Flipper.Spring.new(1, {
		frequency = 1.5,
		dampingRatio = 1,
	}))

	motor:onComplete(function()
		camera.CameraType = getDefaultCameraState()
	end)
end

return zoom
