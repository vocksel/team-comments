local CollectionService = game:GetService("CollectionService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local t = require(script.Parent.Lib.t)
local Config = require(script.Parent.Config)
local New = require(script.Parent.New)

local messages = {}

-- This is where all WorldMessages end up initially, but they can be moved
-- whereever the user wants.
--
-- Once created, the storage folder can be moved whereever the user wants as
-- well. We just find it via a tag and create it in the Workspace if it doesn't
-- exist.
--
-- WorldMessage parts are not gauranteed to exist here, this is just the default
-- location where they're stored. The user can move the parts wherever they
-- want, as it can be beneficial to group messages under a single build.
--
-- With this in mind, you can never assume where the WorldMessage storage or
-- parts will be, which is why we use tags.
function messages.getOrCreateStorage()
	local storage = CollectionService:GetTagged(Config.STORAGE_TAG_NAME)[1]

	if not storage then
		storage = New("Folder", {
			Name = "WorldMessages",
			Parent = workspace
		})

		CollectionService:AddTag(storage, Config.STORAGE_TAG_NAME)
	end

	return storage
end

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
		Parent = messages.getOrCreateStorage()
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

--[[
	Focuses a message part by its ID.

	This is like the Zoom To action in Studio, which will focus something in
	your selection.
]]
function messages.focus(messageId)
	local messagePart = messages.getMessagePartById(messageId)
	local camera = workspace.CurrentCamera
	local orientation = camera.CFrame-camera.CFrame.p
	local newCFrame = CFrame.new(messagePart.Position) * orientation

	camera.Focus = messagePart.CFrame
	camera.CFrame = newCFrame * CFrame.new(-Config.PUSHBACK_FROM_FOCUS, 0, 0)
end

function messages.delete(messageId)
	-- We can just remove WorldMessage parts because the state is
	-- controlled by them being added/removed from the game.
	local messagePart = messages.getMessagePartById(messageId)
	messagePart.Parent = nil
	ChangeHistoryService:SetWaypoint("Deleted WorldMessage")
end

return messages
