local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestEZ = require(ReplicatedStorage.DevPackages.TestEZ)

local results = TestEZ.TestBootstrap:run({
	ServerScriptService.TeamComments,
})

if results.failureCount > 0 then
	print("❌ Test run failed")
else
	print("✔️ All tests passed")
end
