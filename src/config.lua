return {
	TAG_NAME = "WorldMessage",

	-- Tag given to an object that all world messages will be parented to. This
	-- is optional, and will default to the workspace.
	STORAGE_TAG_NAME = "WorldMessageParent",

	BILLBOARD_MAX_DISTANCE = 400, -- studs

	-- Fake player to use for indexing properties.
	--
	-- We rely on Players.LocalPlayer existing in Team Create, but HotSwap does
	-- not seem to have support for LocalPlayer regardless. So we use this for
	-- debugging.
	MOCK_PLAYER = {
		Name = "Player",
		UserId = 1343930
	}
}
