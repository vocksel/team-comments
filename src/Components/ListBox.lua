--[[
	Creates an automatically sized frame from its children.

	Usage:

		Roact.createElement(ListBox, {
			width = UDim.new(0, 100),
			transparency = 0,
			listPadding = 8,
		}, {
			Red = Roact.createElement("Frame", {
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, 100),
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			}),

			Green = Roact.createElement("Frame", {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 200),
				BackgroundColor3 = Color3.fromRGB(0, 255, 0),
			}),

			Blue = Roact.createElement("Frame", {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 300),
				BackgroundColor3 = Color3.fromRGB(0, 0, 255),
			})
		})

	You can also supply a custom width if you don't want the frame to fill the
	whole width of its parent element.

		Roact.createElement(ListBox, {
			-- Only 400 pixels wide, but will still expand vertically to fit content.
			width = UDim.new(0, 400)
		})

	As well, you can supply padding in two ways. On all sides:

		Roact.createElement(ListBox, {
			-- Creates a UIPadding with 8 pixels of padding on all sides
			padding = 8
		})

	Or individually:

		Roact.createElement(ListBox, {
			-- This will leave PaddingLeft and PaddingRight as 0.
			paddingTop = 8,
			paddingBottom = 8,
		})
]]

local Immutable = require(script.Parent.Parent.Lib.Immutable)
local Roact = require(script.Parent.Parent.Lib.Roact)
local t = require(script.Parent.Parent.Lib.t)

local Props = t.interface({
	backgroundColor = t.optional(t.Color3),
	borderColor = t.optional(t.Color3),
	borderSize = t.optional(t.integer),
	fillDirection = t.optional(t.enum(Enum.FillDirection)),
	layoutOrder = t.optional(t.integer),
	listPadding = t.optional(t.integer),
	padding = t.optional(t.integer),
	paddingBottom = t.optional(t.integer),
	paddingLeft = t.optional(t.integer),
	paddingRight = t.optional(t.integer),
	paddingTop = t.optional(t.integer),
	width = t.optional(t.UDim),
	transparency = t.optional(t.number),
})

local ListBox = Roact.Component:extend("ListBox")

ListBox.defaultProps = {
	paddingTop = 0,
	paddingRight = 0,
	paddingBottom = 0,
	paddingLeft = 0,
	transparency = 1,
}

function ListBox:init()
	self.height, self.setHeight = Roact.createBinding(0)

	self.onSizeChange = function(rbx)
		self.setHeight(rbx.AbsoluteContentSize.Y)
	end

	self.mapHeight = function(height)
		local padding = self:getPaddingProps()
		local widthUDim = self.props.width or UDim.new(1, 0)
		local heightUDim = UDim.new(0, height + padding.PaddingTop.Offset + padding.PaddingBottom.Offset)
		return UDim2.new(widthUDim, heightUDim)
	end
end

function ListBox:getPaddingProps()
	local padding = self.props.padding

	if padding then
		return {
			PaddingBottom = UDim.new(0, padding),
			PaddingLeft = UDim.new(0, padding),
			PaddingRight = UDim.new(0, padding),
			PaddingTop = UDim.new(0, padding),
		}
	else
		return {
			PaddingBottom = UDim.new(0, self.props.paddingBottom),
			PaddingLeft = UDim.new(0, self.props.paddingLeft),
			PaddingRight = UDim.new(0, self.props.paddingRight),
			PaddingTop = UDim.new(0, self.props.paddingTop),
		}
	end
end

function ListBox:render()
	assert(Props(self.props))

	local children = Immutable.join(self.props[Roact.Children], {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = self.props.fillDirection,
			Padding = UDim.new(0, self.props.listPadding),
			[Roact.Change.AbsoluteContentSize] = self.onSizeChange,
		}),

		Padding = Roact.createElement("UIPadding", self:getPaddingProps())
	})

	return Roact.createElement("Frame", {
		LayoutOrder = self.props.layoutOrder,
		Size = self.height:map(self.mapHeight),
		BackgroundTransparency = self.props.transparency,
		BackgroundColor3 = self.props.backgroundColor,
		BorderColor3 = self.props.borderColor,
		BorderSizePixel = self.props.borderSize,
	}, children)
end

return ListBox
