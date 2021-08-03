local TeamComments = script:FindFirstAncestor("TeamComments")

local HttpService = game:GetService("HttpService")

local Roact = require(TeamComments.Packages.Roact)
local Hooks = require(TeamComments.Packages.Hooks)
local t = require(TeamComments.Packages.t)
local Immutable = require(TeamComments.Lib.Immutable)
local MessageContext = require(TeamComments.Context.MessageContext)
local useTheme = require(TeamComments.Hooks.useTheme)
local Styles = require(TeamComments.Styles)
local types = require(TeamComments.Types)

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
	props = Immutable.join(defaultProps, props)

	assert(validateProps(props))

	local input = Roact.createRef()
	local text, setText = hooks.useState("")
	local messages = hooks.useContext(MessageContext)
	local theme = useTheme(hooks)

	local onFocusLost = hooks.useCallback(function(_rbx, enterPressed)
		if enterPressed then
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
		end
	end, {
		messages,
		props.userId,
		text,
		setText,
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

	return Roact.createElement(
		"TextBox",
		Immutable.join(Styles.TextBox, {
			LayoutOrder = props.LayoutOrder,
			Text = text,
			PlaceholderText = props.placeholder,
			TextColor3 = theme:GetColor(Enum.StudioStyleGuideColor.MainText),
			PlaceholderColor3 = theme:GetColor(Enum.StudioStyleGuideColor.SubText),
			BackgroundColor3 = theme:GetColor(Enum.StudioStyleGuideColor.InputFieldBackground),
			[Roact.Change.Text] = onTextChanged,
			[Roact.Event.FocusLost] = onFocusLost,
			[Roact.Ref] = input,
		}),
		{
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = Styles.Padding,
				PaddingRight = Styles.Padding,
				PaddingBottom = Styles.Padding,
				PaddingLeft = Styles.Padding,
			}),

			SizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, Styles.Text.TextSize * 3),
			}),
		}
	)
end

return Hooks.new(Roact)(MessageInputField)
