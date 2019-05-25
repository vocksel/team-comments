local CollectionService = game:GetService("CollectionService")

local t = require(script.Parent.Lib.t)
local Config = require(script.Parent.Config)
local New = require(script.Parent.New)

local messages = {}

function messages.createMessagePart(messageId, userId, position)
	local messagePart = New("Part", {
		Name = "WorldMessage",
		Anchored = true,
		Locked = true,
		CanCollide = false,
		Transparency = 1,
		-- Normally we would use Position, but this forces the Part to exist
		-- inside another, without being pushed up on top.
		CFrame = CFrame.new(position),
		Size = Vector3.new(0, 0, 0),
		Parent = workspace
	}, {
		New("StringValue", { Name = "Id", Value = messageId }),
		New("StringValue", { Name = "AuthorId", Value = userId, }),
		New("StringValue", { Name = "Body" }),
		New("NumberValue", { Name = "Time", Value = os.time() }),
	})

	CollectionService:AddTag(messagePart, Config.TAG_NAME)

	return messagePart
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
		Body = t.instance("StringValue"),
		Time = t.instance("NumberValue"),
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

--[[
	Gets a messagePart by its ID.
]]
function messages.getMessagePartById(messageId)
	for _, messagePart in pairs(CollectionService:GetTagged(Config.TAG_NAME)) do
		if messagePart.Id.Value == messageId then
			return messagePart
		end
	end
end

return messages
