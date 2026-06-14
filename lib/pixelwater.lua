local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("CrownWatermarkPro") then
	PlayerGui.CrownWatermarkPro:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CrownWatermarkPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.AnchorPoint = Vector2.new(1, 1)
Frame.Position = UDim2.new(1, -15, 1, -15)
Frame.AutomaticSize = Enum.AutomaticSize.X
Frame.Size = UDim2.new(0, 0, 0, 24)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(30, 30, 30)
Stroke.Thickness = 1
Stroke.LineJoinMode = Enum.LineJoinMode.Miter
Stroke.Parent = Frame

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)
Padding.Parent = Frame

local TopLine = Instance.new("Frame")
TopLine.Name = "TopLine"
TopLine.Size = UDim2.new(1, 16, 0, 3)
TopLine.Position = UDim2.new(0, -8, 0, 0)
TopLine.BorderSizePixel = 0
TopLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopLine.ZIndex = 2
TopLine.Parent = Frame

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
})
Gradient.Parent = TopLine

local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 1)
TextLabel.AutomaticSize = Enum.AutomaticSize.X
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Crown Softworks"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.TextSize = 12
TextLabel.ZIndex = 2
TextLabel.Parent = Frame

local TweenService = game:GetService("TweenService")
local function animateLine()
	Gradient.Offset = Vector2.new(-1, 0)
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(Gradient, tweenInfo, {Offset = Vector2.new(1, 0)})
	
	tween:Play()
	tween.Completed:Wait()
	animateLine()
end

task.spawn(animateLine)
