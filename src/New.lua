--[[
	Create complicated instance hierarchies easily.

	Usage:

		new("Folder", {
			Name = "Container"
		}, {
			new("Part", {
				Name = "Foo",
				Size = Vector3.new(10, 10, 10)
			}),

			new("Part", {
				Name = "Bar",
				Size = Vector3.new(20, 20, 20)
			})
		})
]]

local function new(className, properties, children)
	local instance = Instance.new(className)

	for prop, value in pairs(properties) do
		instance[prop] = value
	end

	if children then
		for _, child in pairs(children) do
			child.Parent = instance
		end
	end

	return instance
end

return new
