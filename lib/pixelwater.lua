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
Frame.Size = UDim2.new(0, 0, 0, 28)
Frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Frame.BackgroundTransparency = 0.15 
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui


local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 5)
Corner.Parent = Frame


local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Thickness = 1.2
Stroke.LineJoinMode = Enum.LineJoinMode.Round 
Stroke.Parent = Frame


local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
	ColorSequenceKeypoint.new(0.3, Color3.fromRGB(0, 200, 255)), 
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 200, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
})
Gradient.Parent = Stroke


local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 12) 
Padding.PaddingRight = UDim.new(0, 12)
Padding.Parent = Frame


local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(0, 0, 1, 0)
TextLabel.Position = UDim2.new(0, 0, 0, 0)
TextLabel.AutomaticSize = Enum.AutomaticSize.X
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Crown Softworks"
TextLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
TextLabel.Font = Enum.Font.GothamMedium
TextLabel.TextSize = 13
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
