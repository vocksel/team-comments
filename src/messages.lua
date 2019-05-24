local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")

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

function messages.getStorage()
	return CollectionService:GetTagged(config.STORAGE_TAG_NAME)
end

function messages.getAll()
	return CollectionService:GetTagged(config.TAG_NAME)
end

return messages
