local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Character
local Humanoid
local RootPart

local moveMain = false
local moveIntro = false
local moveCommon = false
local moveSew = false
local moveAuthor = false
local flyEnabled = false
local wallEnabled = false
local antiAFKEnabled = true
local noGravity = true
local joystickActive = false
local joystickStartPos = Vector2.new()
local speedValue = 16
local jumpValue = 50
local healthValue = 100

local function setupCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    
    Humanoid.WalkSpeed = speedValue
    Humanoid.JumpPower = jumpValue
    Humanoid.MaxHealth = healthValue
    Humanoid.Health = healthValue
    
    if wallEnabled then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end

local UI = Instance.new("ScreenGui")
UI.Name = "MancProUI"
UI.Parent = PlayerGui
UI.IgnoreGuiInset = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 350)
MainFrame.Position = UDim2.new(0, 20, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BackgroundTransparency = 0.5
MainFrame.BorderSizePixel = 2
MainFrame.Parent = UI

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TitleLabel.BackgroundTransparency = 0.5
TitleLabel.Text = "MancPro Script"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextScaled = true
TitleLabel.Parent = MainFrame

local MoveButton = Instance.new("TextButton")
MoveButton.Name = "MoveButton"
MoveButton.Size = UDim2.new(0, 60, 0, 30)
MoveButton.Position = UDim2.new(1, -65, 0, 45)
MoveButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
MoveButton.BackgroundTransparency = 0.5
MoveButton.Text = "Off"
MoveButton.TextColor3 = Color3.new(1, 1, 1)
MoveButton.TextScaled = true
MoveButton.Parent = MainFrame

local MoveLabel = Instance.new("TextLabel")
MoveLabel.Name = "MoveLabel"
MoveLabel.Size = UDim2.new(0, 80, 0, 30)
MoveLabel.Position = UDim2.new(0, 10, 0, 45)
MoveLabel.BackgroundTransparency = 1
MoveLabel.Text = "移动:"
MoveLabel.TextColor3 = Color3.new(1, 1, 1)
MoveLabel.TextScaled = true
MoveLabel.TextXAlignment = Enum.TextXAlignment.Left
MoveLabel.Parent = MainFrame

local buttons = {}
for i = 1, 4 do
    local button = Instance.new("TextButton")
    button.Name = "Button" .. i
    button.Size = UDim2.new(1, -20, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 85 + (i-1)*60)
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.BackgroundTransparency = 0.5
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Parent = MainFrame
    buttons[i] = button
end

buttons[1].Text = "介绍"
buttons[2].Text = "常用"
buttons[3].Text = "缝合"
buttons[4].Text = "关于作者"

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
CloseButton.BackgroundTransparency = 0.5
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextScaled = true
CloseButton.Parent = MainFrame

local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UDim2.new(0, 300, 0, 200)
IntroFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
IntroFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
IntroFrame.BackgroundTransparency = 0.5
IntroFrame.BorderSizePixel = 2
IntroFrame.Visible = false
IntroFrame.Parent = UI

local IntroCloseButton = Instance.new("TextButton")
IntroCloseButton.Name = "IntroCloseButton"
IntroCloseButton.Size = UDim2.new(0, 30, 0, 30)
IntroCloseButton.Position = UDim2.new(1, -35, 0, 5)
IntroCloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
IntroCloseButton.BackgroundTransparency = 0.5
IntroCloseButton.Text = "X"
IntroCloseButton.TextColor3 = Color3.new(1, 1, 1)
IntroCloseButton.TextScaled = true
IntroCloseButton.Parent = IntroFrame

local CommonFrame = Instance.new("Frame")
CommonFrame.Name = "CommonFrame"
CommonFrame.Size = UDim2.new(0, 350, 0, 300)
CommonFrame.Position = UDim2.new(0.5, -175, 0.3, 0)
CommonFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
CommonFrame.BackgroundTransparency = 0.5
CommonFrame.BorderSizePixel = 2
CommonFrame.Visible = false
CommonFrame.Parent = UI

local CommonCloseButton = Instance.new("TextButton")
CommonCloseButton.Name = "CommonCloseButton"
CommonCloseButton.Size = UDim2.new(0, 30, 0, 30)
CommonCloseButton.Position = UDim2.new(1, -35, 0, 5)
CommonCloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
CommonCloseButton.BackgroundTransparency = 0.5
CommonCloseButton.Text = "X"
CommonCloseButton.TextColor3 = Color3.new(1, 1, 1)
CommonCloseButton.TextScaled = true
CommonCloseButton.Parent = CommonFrame

local SewFrame = Instance.new("Frame")
SewFrame.Name = "SewFrame"
SewFrame.Size = UDim2.new(0, 300, 0, 150)
SewFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
SewFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
SewFrame.BackgroundTransparency = 0.5
SewFrame.BorderSizePixel = 2
SewFrame.Visible = false
SewFrame.Parent = UI

local SewCloseButton = Instance.new("TextButton")
SewCloseButton.Name = "SewCloseButton"
SewCloseButton.Size = UDim2.new(0, 30, 0, 30)
SewCloseButton.Position = UDim2.new(1, -35, 0, 5)
SewCloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
SewCloseButton.BackgroundTransparency = 0.5
SewCloseButton.Text = "X"
SewCloseButton.TextColor3 = Color3.new(1, 1, 1)
SewCloseButton.TextScaled = true
SewCloseButton.Parent = SewFrame

local AuthorFrame = Instance.new("Frame")
AuthorFrame.Name = "AuthorFrame"
AuthorFrame.Size = UDim2.new(0, 300, 0, 200)
AuthorFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
AuthorFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
AuthorFrame.BackgroundTransparency = 0.5
AuthorFrame.BorderSizePixel = 2
AuthorFrame.Visible = false
AuthorFrame.Parent = UI

local AuthorCloseButton = Instance.new("TextButton")
AuthorCloseButton.Name = "AuthorCloseButton"
AuthorCloseButton.Size = UDim2.new(0, 30, 0, 30)
AuthorCloseButton.Position = UDim2.new(1, -35, 0, 5)
AuthorCloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
AuthorCloseButton.BackgroundTransparency = 0.5
AuthorCloseButton.Text = "X"
AuthorCloseButton.TextColor3 = Color3.new(1, 1, 1)
AuthorCloseButton.TextScaled = true
AuthorCloseButton.Parent = AuthorFrame

local FlyFrame = Instance.new("Frame")
FlyFrame.Name = "FlyFrame"
FlyFrame.Size = UDim2.new(0, 280, 0, 180)
FlyFrame.Position = UDim2.new(0.5, -140, 0.5, -90)
FlyFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
FlyFrame.BackgroundTransparency = 0.5
FlyFrame.BorderSizePixel = 2
FlyFrame.Visible = false
FlyFrame.Parent = UI

local FlyCloseButton = Instance.new("TextButton")
FlyCloseButton.Name = "FlyCloseButton"
FlyCloseButton.Size = UDim2.new(0, 30, 0, 30)
FlyCloseButton.Position = UDim2.new(1, -35, 0, 5)
FlyCloseButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
FlyCloseButton.BackgroundTransparency = 0.5
FlyCloseButton.Text = "X"
FlyCloseButton.TextColor3 = Color3.new(1, 1, 1)
FlyCloseButton.TextScaled = true
FlyCloseButton.Parent = FlyFrame

local Joystick = Instance.new("Frame")
Joystick.Name = "Joystick"
Joystick.Size = UDim2.new(0, 100, 0, 100)
Joystick.Position = UDim2.new(0.1, 0, 0.7, -50)
Joystick.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
Joystick.BackgroundTransparency = 0.5
Joystick.BorderSizePixel = 2
Joystick.ClipsDescendants = true
Joystick.Visible = false
Joystick.Parent = UI

local JoystickKnob = Instance.new("Frame")
JoystickKnob.Name = "JoystickKnob"
JoystickKnob.Size = UDim2.new(0, 40, 0, 40)
JoystickKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
JoystickKnob.BackgroundColor3 = Color3.new(0, 1, 1)
JoystickKnob.BackgroundTransparency = 0.3
JoystickKnob.BorderSizePixel = 0
JoystickKnob.Parent = Joystick

local function updateBorderColor(frame)
    coroutine.wrap(function()
        while frame.Parent do
            local hue = tick() % 1
            local color = Color3.fromHSV(hue, 1, 1)
            frame.BorderColor3 = color
            RunService.RenderStepped:Wait()
        end
    end)()
end

for _, frame in pairs({MainFrame, IntroFrame, CommonFrame, FlyFrame, SewFrame, AuthorFrame, Joystick}) do
    updateBorderColor(frame)
end

local function setupDrag(frame, moveVar)
    local dragStart = Vector2.new()
    local startPos = UDim2.new()
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if _G[moveVar] then
                dragStart = input.Position
                startPos = frame.Position
                _G["dragging"..moveVar] = true
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if _G["dragging"..moveVar] then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            _G["dragging"..moveVar] = false
        end
    end)
end

setupDrag(MainFrame, "moveMain")
setupDrag(IntroFrame, "moveIntro")
setupDrag(CommonFrame, "moveCommon")
setupDrag(SewFrame, "moveSew")
setupDrag(AuthorFrame, "moveAuthor")
setupDrag(FlyFrame, "moveFly")

MoveButton.MouseButton1Click:Connect(function()
    moveMain = not moveMain
    MoveButton.Text = moveMain and "On" or "Off"
end)

local function hideAllFrames()
    IntroFrame.Visible = false
    CommonFrame.Visible = false
    SewFrame.Visible = false
    AuthorFrame.Visible = false
    FlyFrame.Visible = false
    Joystick.Visible = false
end

buttons[1].MouseButton1Click:Connect(function()
    hideAllFrames()
    IntroFrame.Visible = true
end)

buttons[2].MouseButton1Click:Connect(function()
    hideAllFrames()
    CommonFrame.Visible = true
    Joystick.Visible = flyEnabled
end)

buttons[3].MouseButton1Click:Connect(function()
    hideAllFrames()
    SewFrame.Visible = true
end)

buttons[4].MouseButton1Click:Connect(function()
    hideAllFrames()
    AuthorFrame.Visible = true
end)

CloseButton.MouseButton1Click:Connect(function()
    hideAllFrames()
end)

IntroCloseButton.MouseButton1Click:Connect(function()
    IntroFrame.Visible = false
end)

CommonCloseButton.MouseButton1Click:Connect(function()
    CommonFrame.Visible = false
    Joystick.Visible = false
end)

SewCloseButton.MouseButton1Click:Connect(function()
    SewFrame.Visible = false
end)

AuthorCloseButton.MouseButton1Click:Connect(function()
    AuthorFrame.Visible = false
end)

FlyCloseButton.MouseButton1Click:Connect(function()
    FlyFrame.Visible = false
end)

local FlyBtn = Instance.new("TextButton")
FlyBtn.Name = "FlyBtn"
FlyBtn.Size = UDim2.new(0, 120, 0, 35)
FlyBtn.Position = UDim2.new(0, 20, 0, 170)
FlyBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
FlyBtn.BackgroundTransparency = 0.5
FlyBtn.Text = "飞行 [关闭]"
FlyBtn.TextColor3 = Color3.new(1, 1, 1)
FlyBtn.TextScaled = true
FlyBtn.Parent = CommonFrame

local SpeedBtn = Instance.new("TextButton")
SpeedBtn.Name = "SpeedBtn"
SpeedBtn.Size = UDim2.new(0, 120, 0, 35)
SpeedBtn.Position = UDim2.new(0, 150, 0, 170)
SpeedBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SpeedBtn.BackgroundTransparency = 0.5
SpeedBtn.Text = "加速"
SpeedBtn.TextColor3 = Color3.new(1, 1, 1)
SpeedBtn.TextScaled = true
SpeedBtn.Parent = CommonFrame

local JumpBtn = Instance.new("TextButton")
JumpBtn.Name = "JumpBtn"
JumpBtn.Size = UDim2.new(0, 120, 0, 35)
JumpBtn.Position = UDim2.new(0, 20, 0, 220)
JumpBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
JumpBtn.BackgroundTransparency = 0.5
JumpBtn.Text = "超级跳"
JumpBtn.TextColor3 = Color3.new(1, 1, 1)
JumpBtn.TextScaled = true
JumpBtn.Parent = CommonFrame

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Name = "NoclipBtn"
NoclipBtn.Size = UDim2.new(0, 120, 0, 35)
NoclipBtn.Position = UDim2.new(0, 150, 0, 220)
NoclipBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
NoclipBtn.BackgroundTransparency = 0.5
NoclipBtn.Text = "穿墙 [关闭]"
NoclipBtn.TextColor3 = Color3.new(1, 1, 1)
NoclipBtn.TextScaled = true
NoclipBtn.Parent = CommonFrame

FlyBtn.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    FlyFrame.Visible = flyEnabled
    Joystick.Visible = flyEnabled
    FlyBtn.Text = flyEnabled and "飞行 [开启]" or "飞行 [关闭]"
    
    if Character and Humanoid and RootPart then
        if flyEnabled then
            Humanoid.PlatformStand = true
            if noGravity then
                workspace.Gravity = 0
            end
        else
            Humanoid.PlatformStand = false
            workspace.Gravity = 196.2
        end
    end
end)

SpeedBtn.MouseButton1Click:Connect(function()
    if Character and Humanoid then
        Humanoid.WalkSpeed = Humanoid.WalkSpeed + 10
        if Humanoid.WalkSpeed > 100 then
            Humanoid.WalkSpeed = 16
        end
    end
end)

JumpBtn.MouseButton1Click:Connect(function()
    if Character and Humanoid then
        Humanoid.JumpPower = Humanoid.JumpPower + 20
        if Humanoid.JumpPower > 200 then
            Humanoid.JumpPower = 50
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    wallEnabled = not wallEnabled
    NoclipBtn.Text = wallEnabled and "穿墙 [开启]" or "穿墙 [关闭]"
    
    if Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = not wallEnabled
            end
        end
    end
end)

Joystick.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and flyEnabled then
        joystickActive = true
        joystickStartPos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and joystickActive and flyEnabled and RootPart then
        local delta = input.Position - joystickStartPos
        local maxDist = Joystick.AbsoluteSize.X / 2 - JoystickKnob.AbsoluteSize.X / 2
        local dist = math.clamp(delta.Magnitude, 0, maxDist)
        local dir = delta.Unit
        
        JoystickKnob.Position = UDim2.new(0.5, dir.X * dist - 20, 0.5, dir.Y * dist - 20)
        
        local moveDir = Vector3.new(dir.X, 0, dir.Y) * 50
        RootPart.AssemblyLinearVelocity = Vector3.new(moveDir.X, RootPart.AssemblyLinearVelocity.Y, moveDir.Z)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        joystickActive = false
        JoystickKnob.Position = UDim2.new(0.5, -20, 0.5, -20)
        if flyEnabled and RootPart then
            RootPart.AssemblyLinearVelocity = Vector3.new(0, RootPart.AssemblyLinearVelocity.Y, 0)
        end
    end
end)

local flyConnection
flyConnection = RunService.Heartbeat:Connect(function()
    if flyEnabled and RootPart then
        local moveDir = Vector3.new(0, RootPart.AssemblyLinearVelocity.Y, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + RootPart.CFrame.LookVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - RootPart.CFrame.LookVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - RootPart.CFrame.RightVector * 50
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + RootPart.CFrame.RightVector * 50
        end
        
        RootPart.AssemblyLinearVelocity = moveDir
    end
end)

local antiAFKConnection
antiAFKConnection = RunService.Heartbeat:Connect(function()
    if antiAFKEnabled and Character and RootPart then
        if tick() % 900 < 0.1 then
            local originalPosition = RootPart.Position
            RootPart.CFrame = RootPart.CFrame + Vector3.new(0, 0, 1)
            wait(0.1)
            RootPart.CFrame = CFrame.new(originalPosition)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(newChar)
    setupCharacter()
end)

setupCharacter()

UI.Destroying:Connect(function()
    if flyConnection then
        flyConnection:Disconnect()
    end
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
    end
end)
