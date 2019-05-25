local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

local t = require(script.Parent.t)
local config = require(script.Parent.config)
local new = require(script.Parent.new)

local messages = {}

function messages.newMessagePart(userId)
	local id = HttpService:GenerateGUID()

	local part = new("Part", {
		Name = "WorldMessage",
		Anchored = true,
		Transparency = 1,
		Size = Vector3.new(1, 1, 1)
	}, {
		new("StringValue", { Name = "Id", Value = id }),
		new("IntValue", { Name = "AuthorId", Value = userId }),
		new("StringValue", { Name = "Body" }),
		new("NumberValue", { Name = "Time" })
	})

	CollectionService:AddTag(part, config.TAG_NAME)

	return part
end


--[[
	Exactly like GetChildren(), but returns a dictionary where the key is each
	child's name.
]]
local function getNamedChildren(parent)
	assert(typeof(parent) == "Instance")

	local children = {}

	for _, child in pairs(parent:GetChildren()) do
		children[child.Name] = child
	end

	return children
end

--[[
	Validates that a message part has all the required instances.
]]
function messages.validateMessagePart(messagePart)
	local check = t.interface({
		Id = t.instance("StringValue"),
		AuthorId = t.instance("StringValue"),
	})

	local children = getNamedChildren(messagePart)

	assert(check(children))
end

--[[
	Only runs the given callback if messagePart is valid.

	Otherwise warns what went wrong.
]]
function messages.runIfValid(messagePart, callback)
	local ok, result = pcall(messages.validateMessagePart, messagePart)

	if ok then
		callback()
	else
		warn(result)
	end
end

return messages
