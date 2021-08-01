local TeamComments = script:FindFirstAncestor("TeamComments")

local HttpService = game:GetService("HttpService")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local Styles = require(TeamComments.Styles)

local validateProps = t.interface({
	userId = t.string,
	respondTo = t.optional(t.string),
	LayoutOrder = t.optional(t.number),
})

local function MessageInputField(props, hooks)
	assert(validateProps(props))

	local text, setText = hooks.useState("")
	local messages = hooks.useContext(MessageContext)
	local theme = useTheme(hooks)

	local onFocusLost = hooks.useCallback(function(_rbx, enterPressed)
		if enterPressed then
			local position = workspace.CurrentCamera.CFrame.p
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
				messages.createMessage(message, position)
			end

			setText("")
		end
	end, {
		messages,
		props.userId,
		text,
		setText,
	})

	return Roact.createElement("TextBox", {
		LayoutOrder = props.LayoutOrder,
		Text = text,
		PlaceholderText = "Write a new message...",
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground),
		BorderSizePixel = 0,
		TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
		PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
		ClearTextOnFocus = false,
		TextWrapped = true,
		LineHeight = Styles.Text.TextSize,

		[Roact.Change.Text] = function(rbx)
			setText(rbx.Text)
		end,
		[Roact.Event.FocusLost] = onFocusLost,
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = Styles.Padding,
			PaddingRight = Styles.Padding,
			PaddingBottom = Styles.Padding,
			PaddingLeft = Styles.Padding,
		}),
	})
end

return Hooks.new(Roact)(MessageInputField)
