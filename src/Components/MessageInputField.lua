local TeamComments = script:FindFirstAncestor("TeamComments")

local HttpService = game:GetService("HttpService")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Llama = require(TeamComments.Packages.Llama)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local styles = require(TeamComments.styles)
local assets = require(TeamComments.assets)
local types = require(TeamComments.types)
local ImageButton = require(script.Parent.ImageButton)

local validateProps = t.interface({
	userId = t.string,
	placeholder = t.optional(t.string),
	focusOnMount = t.optional(t.boolean),
	respondTo = t.optional(types.Message),
	LayoutOrder = t.optional(t.number),
})

local defaultProps = {
	focusOnMount = false,
}

local function MessageInputField(props, hooks)
	props = Llama.Dictionary.join(defaultProps, props)

	assert(validateProps(props))

	local input = Roact.createRef()
	local text, setText = hooks.useState("")
	local messages = hooks.useContext(MessageContext)
	local theme = useTheme(hooks)

	local send = hooks.useCallback(function()
		local position = workspace.CurrentCamera.CFrame.Position

		if text == "" then
			return
		end

		local message = {
			id = HttpService:GenerateGUID(),
			userId = props.userId,
			text = text,
			createdAt = os.time(),
			responses = {},
		}

		if props.respondTo then
			messages.respond(props.respondTo, message)
		else
			messages.comment(message, position)
		end

		setText("")
	end, {
		text,
		setText,
		messages,
		props,
	})

	local onFocusLost = hooks.useCallback(function(_rbx, enterPressed)
		if enterPressed then
			send()
		end
	end, {
		send,
	})

	local onTextChanged = hooks.useCallback(function(rbx)
		setText(rbx.Text)
	end, { setText })

	hooks.useEffect(function()
		if props.focusOnMount then
			local field = input:getValue()
			-- why does this work
			spawn(function()
				field:CaptureFocus()
			end)
		end
	end, {
		props.focusOnMount,
	})

	return Roact.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground),
		BorderSizePixel = 0,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),

		Input = Roact.createElement(
			"TextBox",
			Llama.Dictionary.join(styles.TextBox, {
				Text = text,
				Active = true,
				PlaceholderText = props.placeholder,
				TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
				PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
				BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground),
				[Roact.Change.Text] = onTextChanged,
				[Roact.Event.FocusLost] = onFocusLost,
				[Roact.Ref] = input,
			}),
			{
				SizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, styles.Text.TextSize * 2),
				}),

				Padding = Roact.createElement("UIPadding", {
					PaddingTop = styles.Padding,
					PaddingRight = styles.Padding,
					PaddingBottom = styles.Padding,
					PaddingLeft = styles.Padding,
				}),
			}
		),

		Actions = Roact.createElement("Frame", {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = styles.Padding,
			}),

			Padding = Roact.createElement("UIPadding", {
				PaddingRight = styles.PaddingLarge,
				PaddingLeft = styles.Padding,
			}),

			-- TODO: Add emoji support! https://github.com/vocksel/TeamComments/issues/7
			-- Emojis = Roact.createElement(ImageButton, {
			-- 	LayoutOrder = 1,
			-- 	Image = assets.Emojis,
			-- 	[Roact.Event.Activated] = send,
			-- }),

			Send = Roact.createElement(ImageButton, {
				LayoutOrder = 2,
				Image = assets.Send,
				onActivated = send,
			}),
		}),
	})
end

return Hooks.new(Roact)(MessageInputField)
