local TeamComments = script:FindFirstAncestor("TeamComments")

local Flipper = require(TeamComments.Packages.Flipper)

local function zoom(goal: Part)
	local motor = Flipper.SingleMotor.new(0)
	local camera = workspace.CurrentCamera
	local start = camera.CFrame.Position
	local orientation = camera.CFrame - start
	local goalPos = goal.Position - (goal.Position - start).Unit * 10
	local lastState = camera.CameraType

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
		camera.CameraType = lastState
	end)
end

return zoom
