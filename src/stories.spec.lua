local TeamComments = script:FindFirstAncestor("TeamComments")

local Roact = require(TeamComments.Packages.Roact)

return function()
	Roact.setGlobalConfig({
		propValidation = true,
		elementTracing = true,
	})

	for _, descendant in ipairs(TeamComments:GetDescendants()) do
		if descendant:IsA("ModuleScript") and descendant.Name:match(".story$") then
			it("should mount and unmount " .. descendant.Name, function()
				local story = require(descendant)
				local unmount

				expect(function()
					unmount = story()
				end).to.never.throw()

				expect(function()
					unmount()
				end).to.never.throw()
			end)
		end
	end
end
