return {
	Padding = UDim.new(0, 8),
	PaddingLarge = UDim.new(0, 16),

	Header = {
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextTruncate = Enum.TextTruncate.None,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
	},

	Text = {
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		LineHeight = 1.25,
	},

	TextBox = {
		Font = Enum.Font.Gotham,
		TextSize = 14,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		TextWrapped = true,
		LineHeight = 1.25,
	},

	ScrollingFrame = {
		Size = UDim2.fromScale(1, 1),
		CanvasSize = UDim2.fromScale(1, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 6,
		HorizontalScrollBarInset = Enum.ScrollBarInset.Always,
	},
}
