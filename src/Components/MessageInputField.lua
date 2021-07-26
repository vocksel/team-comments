local HttpService = game:GetService("HttpService")

local Roact = require(script.Parent.Parent.Packages.Roact)
local Connect = require(script.Parent.Parent.Packages.RoactRodux).connect
local StudioThemeAccessor = require(script.Parent.StudioThemeAccessor)
local Padding = require(script.Parent.Padding)
local Styles = require(script.Parent.Parent.Styles)
local Messages = require(script.Parent.Parent.Messages)
local SetMessageBody = require(script.Parent.Parent.Actions.SetMessageBody)

local MessageInputField = Roact.Component:extend("MessageInputField")

function MessageInputField:init()
	local clientId = tostring(self.props.plugin:GetStudioUserId())

	self.state = {
		text = ""
	}

	self.setText = function(rbx)
		self:setState({ text = rbx.Text })
	end

	self.onFocusLost = function(rbx, enterPressed)
		if enterPressed then
			local messageId = HttpService:GenerateGUID()
			local position = workspace.CurrentCamera.CFrame.p

			Messages.createMessagePart(messageId, clientId, position, self.state.text)
			self.props.setMessageBody(messageId, self.state.text)

			self:setState({ text = "" })
		end
	end
end

function MessageInputField:render()
	return StudioThemeAccessor.withTheme(function(theme)
		return Roact.createElement("TextBox", {
			Text = self.state.text,
			PlaceholderText = "Write a new message...",
			Size = UDim2.new(1, 0, 0, Styles.TextSize*6),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			BackgroundColor3 = theme:GetColor("InputFieldBackground"),
			BorderSizePixel = 0,
			TextColor3 = theme:GetColor("MainText"),
			PlaceholderColor3 = theme:GetColor("SubText"),
			ClearTextOnFocus = false,
			TextWrapped = true,
			LineHeight = Styles.TextSize,

			[Roact.Change.Text] = self.setText,
			[Roact.Event.FocusLost] = self.onFocusLost
		}, {
			Roact = Roact.createElement(Padding)
		})
	end)
end

local function mapDispatchToProps(dispatch)
	return {
		setMessageBody = function(messageId, text)
			dispatch(SetMessageBody(messageId, text))
		end
	}
end

return Connect(nil, mapDispatchToProps)(MessageInputField)
