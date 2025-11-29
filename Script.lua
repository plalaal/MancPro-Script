local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
assert(LocalPlayer, "无法获取本地玩家")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local Config = {
    Width = isMobile and 280 or 220,
    Height = isMobile and 70 or 60,
    Spacing = isMobile and 80 or 70,
    ToggleSize = isMobile and UDim2.new(0,70,0,35) or UDim2.new(0,60,0,30),
    SwitchSize = isMobile and UDim2.new(0,30,0,30) or UDim2.new(0,26,0,26),
    TitleTextSize = isMobile and 30 or 26,
    OptionTextSize = isMobile and 22 or 20,
    ButtonSize = isMobile and UDim2.new(0.8,0,0,45) or UDim2.new(0.8,0,0,40),
    ButtonTextSize = isMobile and 20 or 18,
    InputTextSize = isMobile and 20 or 18,
    ProgressBarHeight = isMobile and 8 or 6
}
local State = {
    IsValid = false,
    CurrentPage = "功能开关",
    DefaultWalkSpeed = Humanoid.WalkSpeed,
    DefaultJumpPower = Humanoid.JumpPower,
    VerifyKey = "MancPro196542",
    MobileButtonName = "功能切换",
    TouchGuiName = "TouchGui"
}
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "MancProGui"
MainGui.IgnoreGuiInset = true
MainGui.Parent = PlayerGui
local DarkMask = Instance.new("Frame")
DarkMask.Name = "DarkMask"
DarkMask.Size = UDim2.new(1,0,1,0)
DarkMask.BackgroundColor3 = Color3.new(0,0,0)
DarkMask.BackgroundTransparency = 0.7
DarkMask.Visible = false
DarkMask.Parent = MainGui
local VerifyWindow = Instance.new("Frame")
VerifyWindow.Name = "VerifyWindow"
VerifyWindow.Size = isMobile and UDim2.new(0,320,0,240) or UDim2.new(0,280,0,200)
VerifyWindow.Position = UDim2.new(0.5, -VerifyWindow.Size.X.Offset/2, 0.5, -VerifyWindow.Size.Y.Offset/2)
VerifyWindow.BackgroundColor3 = Color3.fromRGB(23,28,36)
VerifyWindow.Parent = MainGui
local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0,12)
VerifyCorner.Parent = VerifyWindow
local VerifyBorder = Instance.new("UIStroke")
VerifyBorder.Color = Color3.fromRGB(60,130,246)
VerifyBorder.Thickness = 1
VerifyBorder.Transparency = 0.5
VerifyBorder.Parent = VerifyWindow
local VerifyTitle = Instance.new("TextLabel")
VerifyTitle.Name = "VerifyTitle"
VerifyTitle.Size = UDim2.new(1,0,0, isMobile and 60 or 50)
VerifyTitle.BackgroundTransparency = 1
VerifyTitle.Text = "功能验证"
VerifyTitle.Font = Enum.Font.GothamBold
VerifyTitle.TextSize = Config.TitleTextSize
VerifyTitle.TextColor3 = Color3.fromRGB(255,255,255)
VerifyTitle.TextXAlignment = Enum.TextXAlignment.Center
VerifyTitle.TextYAlignment = Enum.TextYAlignment.Center
VerifyTitle.Parent = VerifyWindow
local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(0.8,0,0, isMobile and 45 or 40)
KeyInput.Position = UDim2.new(0.1,0,0, isMobile and 70 or 60)
KeyInput.BackgroundColor3 = Color3.fromRGB(36,46,62)
KeyInput.PlaceholderText = "输入验证密钥"
KeyInput.PlaceholderColor3 = Color3.fromRGB(150,150,150)
KeyInput.Font = Enum.Font.GothamMedium
KeyInput.TextSize = Config.InputTextSize
KeyInput.TextColor3 = Color3.fromRGB(255,255,255)
KeyInput.TextXAlignment = Enum.TextXAlignment.Center
KeyInput.ClearTextOnFocus = true
KeyInput.Parent = VerifyWindow
local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0,8)
InputCorner.Parent = KeyInput
local VerifyButton = Instance.new("TextButton")
VerifyButton.Name = "VerifyButton"
VerifyButton.Size = UDim2.new(0.6,0,0, isMobile and 45 or 40)
VerifyButton.Position = UDim2.new(0.2,0,0, isMobile and 130 or 115)
VerifyButton.BackgroundColor3 = Color3.fromRGB(60,130,246)
VerifyButton.Text = "验证并启用"
VerifyButton.Font = Enum.Font.GothamMedium
VerifyButton.TextSize = Config.ButtonTextSize
VerifyButton.TextColor3 = Color3.fromRGB(255,255,255)
VerifyButton.Parent = VerifyWindow
VerifyButton.Active = true
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0,8)
ButtonCorner.Parent = VerifyButton
local StatusText = Instance.new("TextLabel")
StatusText.Name = "StatusText"
StatusText.Size = UDim2.new(1,0,0, isMobile and 30 or 25)
StatusText.Position = UDim2.new(0,0,1, -isMobile and 30 or 25)
StatusText.BackgroundTransparency = 1
StatusText.Text = "请输入密钥以启用功能（测试密钥：MancPro123）"
StatusText.Font = Enum.Font.GothamLight
StatusText.TextSize = isMobile and 16 or 14
StatusText.TextColor3 = Color3.fromRGB(200,200,200)
StatusText.TextXAlignment = Enum.TextXAlignment.Center
StatusText.Parent = VerifyWindow
local FunctionWindow = Instance.new("Frame")
FunctionWindow.Name = "FunctionWindow"
FunctionWindow.Size = UDim2.new(0, Config.Width, 1, 0)
FunctionWindow.Position = UDim2.new(-0.1,0,0,0)
FunctionWindow.BackgroundColor3 = Color3.fromRGB(23,28,36)
FunctionWindow.Visible = false
FunctionWindow.Parent = MainGui
local FunctionCorner = Instance.new("UICorner")
FunctionCorner.CornerRadius = UDim.new(0,12)
FunctionCorner.Parent = FunctionWindow
local FunctionBorder = Instance.new("UIStroke")
FunctionBorder.Color = Color3.fromRGB(60,130,246)
FunctionBorder.Thickness = 1
FunctionBorder.Transparency = 0.5
FunctionBorder.Parent = FunctionWindow
local FunctionTitle = Instance.new("TextLabel")
FunctionTitle.Name = "FunctionTitle"
FunctionTitle.Size = UDim2.new(1,0,0, isMobile and 90 or 80)
FunctionTitle.BackgroundTransparency = 1
FunctionTitle.Text = "功能面板"
FunctionTitle.Font = Enum.Font.GothamBold
FunctionTitle.TextSize = Config.TitleTextSize
FunctionTitle.TextColor3 = Color3.fromRGB(255,255,255)
FunctionTitle.TextXAlignment = Enum.TextXAlignment.Center
FunctionTitle.TextYAlignment = Enum.TextYAlignment.Center
FunctionTitle.Parent = FunctionWindow
local FunctionContainer = Instance.new("Frame")
FunctionContainer.Name = "FunctionContainer"
FunctionContainer.Size = UDim2.new(0.9,0,0, isMobile and 520 or 450)
FunctionContainer.Position = UDim2.new(0.05,0,0, isMobile and 110 or 100)
FunctionContainer.BackgroundTransparency = 1
FunctionContainer.Parent = FunctionWindow
local SwitchPage = Instance.new("Frame")
SwitchPage.Name = "SwitchPage"
SwitchPage.Size = UDim2.new(1,0,1,0)
SwitchPage.BackgroundTransparency = 1
SwitchPage.Visible = true
SwitchPage.Parent = FunctionContainer
local SliderPage = Instance.new("Frame")
SliderPage.Name = "SliderPage"
SliderPage.Size = UDim2.new(1,0,1,0)
SliderPage.BackgroundTransparency = 1
SliderPage.Visible = false
SliderPage.Parent = FunctionContainer
local InfoPage = Instance.new("Frame")
InfoPage.Name = "InfoPage"
InfoPage.Size = UDim2.new(1,0,1,0)
InfoPage.BackgroundTransparency = 1
InfoPage.Visible = false
InfoPage.Parent = FunctionContainer
local SwitchList = {
    {Name = "自动奔跑", Default = true},
    {Name = "自动跳跃", Default = true},
    {Name = "无限耐力", Default = false},
    {Name = "速度提升", Default = true},
    {Name = "跳跃增强", Default = false},
    {Name = "防跌落伤害", Default = true}
}
for i, switch in ipairs(SwitchList) do
    local SwitchItem = Instance.new("Frame")
    SwitchItem.Name = "SwitchItem_" .. switch.Name
    SwitchItem.Size = UDim2.new(1,0,0, Config.Height)
    SwitchItem.Position = UDim2.new(0,0,0, (i-1)*Config.Spacing)
    SwitchItem.BackgroundTransparency = 1
    SwitchItem.Parent = SwitchPage
    local SwitchName = Instance.new("TextLabel")
    SwitchName.Name = "SwitchName"
    SwitchName.Size = UDim2.new(0.6,0,1,0)
    SwitchName.BackgroundTransparency = 1
    SwitchName.Text = switch.Name
    SwitchName.Font = Enum.Font.GothamMedium
    SwitchName.TextSize = Config.OptionTextSize
    SwitchName.TextColor3 = Color3.fromRGB(220,220,220)
    SwitchName.TextYAlignment = Enum.TextYAlignment.Center
    SwitchName.Parent = SwitchItem
    local SwitchButton = Instance.new("Frame")
    SwitchButton.Name = "SwitchButton"
    SwitchButton.Size = Config.ToggleSize
    SwitchButton.Position = UDim2.new(1, -Config.ToggleSize.X.Offset - (isMobile and 5 or 3), 0.5, -Config.ToggleSize.Y.Offset/2)
    SwitchButton.BackgroundColor3 = switch.Default and Color3.fromRGB(60,130,246) or Color3.fromRGB(70,75,85)
    SwitchButton.Parent = SwitchItem
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0, Config.ToggleSize.Y.Offset/2)
    SwitchCorner.Parent = SwitchButton
    local SwitchSlider = Instance.new("Frame")
    SwitchSlider.Name = "SwitchSlider"
    SwitchSlider.Size = Config.SwitchSize
    SwitchSlider.BackgroundColor3 = Color3.fromRGB(255,255,255)
    SwitchSlider.ZIndex = 2
    SwitchSlider.Parent = SwitchButton
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(1,0)
    SliderCorner.Parent = SwitchSlider
    local SliderShadow = Instance.new("UIStroke")
    SliderShadow.Color = Color3.new(0,0,0)
    SliderShadow.Transparency = 0.6
    SliderShadow.Thickness = isMobile and 5 or 4
    SliderShadow.Parent = SwitchSlider
    local sliderPos = switch.Default and UDim2.new(0, Config.ToggleSize.X.Offset - Config.SwitchSize.X.Offset - (isMobile and 3 or 2), 0.5, -Config.SwitchSize.Y.Offset/2) or UDim2.new(0, (isMobile and 3 or 2), 0.5, -Config.SwitchSize.Y.Offset/2)
    SwitchSlider.Position = sliderPos
    SwitchButton:SetAttribute("IsEnabled", switch.Default)
    local isDragging = false
    SwitchSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            SwitchSlider.BackgroundColor3 = Color3.fromRGB(220,220,220)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not isDragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local buttonPos = SwitchButton.AbsolutePosition
        local inputX = input.Position.X
        local relativeX = inputX - buttonPos.X
        local minX = isMobile and 3 or 2
        local maxX = SwitchButton.AbsoluteSize.X - Config.SwitchSize.X.Offset - (isMobile and 3 or 2)
        local clampedX = math.clamp(relativeX, minX, maxX)
        SwitchSlider.Position = UDim2.new(0, clampedX, 0.5, -Config.SwitchSize.Y.Offset/2)
    end)
    local function endDrag()
        if not isDragging then return end
        isDragging = false
        SwitchSlider.BackgroundColor3 = Color3.fromRGB(255,255,255)
        local buttonCenter = SwitchButton.AbsolutePosition.X + SwitchButton.AbsoluteSize.X/2
        local sliderCenter = SwitchSlider.AbsolutePosition.X + SwitchSlider.AbsoluteSize.X/2
        local shouldEnable = sliderCenter > buttonCenter
        local currentState = SwitchButton:GetAttribute("IsEnabled")
        if shouldEnable ~= currentState then
            SwitchButton:SetAttribute("IsEnabled", shouldEnable)
            local newColor = shouldEnable and Color3.fromRGB(60,130,246) or Color3.fromRGB(70,75,85)
            local newPos = shouldEnable and UDim2.new(0, Config.ToggleSize.X.Offset - Config.SwitchSize.X.Offset - (isMobile and 3 or 2), 0.5, -Config.SwitchSize.Y.Offset/2) or UDim2.new(0, (isMobile and 3 or 2), 0.5, -Config.SwitchSize.Y.Offset/2)
            TweenService:Create(SwitchButton, TweenInfo.new(0.15), {BackgroundColor3 = newColor}):Play()
            TweenService:Create(SwitchSlider, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {Position = newPos}):Play()
            print(switch.Name .. " " .. (shouldEnable and "已启用" or "已禁用"))
        end
    end
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isDragging then
            endDrag()
        end
    end)
    SwitchButton.InputEnded:Connect(endDrag)
    SwitchItem.MouseEnter:Connect(function()
        SwitchName.TextColor3 = Color3.fromRGB(60,130,246)
    end)
    SwitchItem.MouseLeave:Connect(function()
        SwitchName.TextColor3 = Color3.fromRGB(220,220,220)
    end)
end
local PageButtonContainer = Instance.new("Frame")
PageButtonContainer.Name = "PageButtonContainer"
PageButtonContainer.Size = UDim2.new(1,0,0, isMobile and 240 or 210)
PageButtonContainer.Position = UDim2.new(0,0,1, -isMobile and 240 or 210)
PageButtonContainer.BackgroundTransparency = 1
PageButtonContainer.Parent = FunctionWindow
local PageList = {
    {Name = "功能开关", TargetPage = SwitchPage},
    {Name = "属性调节", TargetPage = SliderPage},
    {Name = "关于脚本", TargetPage = InfoPage}
}
for i, page in ipairs(PageList) do
    local PageButton = Instance.new("TextButton")
    PageButton.Name = "PageButton_" .. page.Name
    PageButton.Size = UDim2.new(0.8,0,0, isMobile and 55 or 50)
    PageButton.Position = UDim2.new(0.1,0,0, (i-1)*(isMobile and 65 or 60))
    PageButton.BackgroundColor3 = Color3.fromRGB(36,46,62)
    PageButton.Text = page.Name
    PageButton.Font = Enum.Font.GothamMedium
    PageButton.TextSize = Config.OptionTextSize
    PageButton.TextColor3 = Color3.fromRGB(220,220,220)
    PageButton.Parent = PageButtonContainer
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0,8)
    ButtonCorner.Parent = PageButton
    PageButton.MouseButton1Click:Connect(function()
        for _, p in ipairs(PageList) do
            p.TargetPage.Visible = false
        end
        page.TargetPage.Visible = true
        State.CurrentPage = page.Name
        for _, btn in ipairs(PageButtonContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.BackgroundColor3 = Color3.fromRGB(36,46,62)
                btn.TextColor3 = Color3.fromRGB(220,220,220)
            end
        end
        PageButton.BackgroundColor3 = Color3.fromRGB(60,130,246)
        PageButton.TextColor3 = Color3.fromRGB(255,255,255)
    end)
    PageButton.MouseEnter:Connect(function()
        if State.CurrentPage ~= page.Name then
            TweenService:Create(PageButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(46,58,78)}):Play()
        end
    end)
    PageButton.MouseLeave:Connect(function()
        if State.CurrentPage ~= page.Name then
            TweenService:Create(PageButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(36,46,62)}):Play()
        end
    end)
end
if isMobile then
    local MobileToggle = Instance.new("TextButton")
    MobileToggle.Name = State.MobileButtonName
    MobileToggle.Size = UDim2.new(0,60,0,60)
    MobileToggle.Position = UDim2.new(0,20,0.5,-30)
    MobileToggle.BackgroundColor3 = Color3.fromRGB(60,130,246)
    MobileToggle.Text = "显示面板"
    MobileToggle.Font = Enum.Font.GothamBold
    MobileToggle.TextSize = 16
    MobileToggle.TextColor3 = Color3.fromRGB(255,255,255)
    MobileToggle.ZIndex = 10
    MobileToggle.Parent = MainGui
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1,0)
    ToggleCorner.Parent = MobileToggle
    local isPanelShow = false
    MobileToggle.MouseButton1Click:Connect(function()
        isPanelShow = not isPanelShow
        if isPanelShow then
            FunctionWindow.Visible = true
            DarkMask.Visible = true
            TweenService:Create(FunctionWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(0,0,0,0), Transparency = 0}):Play()
            MobileToggle.Text = "隐藏面板"
            GuiService:SetCoreGuiEnabled(Enum.CoreGuiType.TouchGui, false)
        else
            TweenService:Create(FunctionWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Position = UDim2.new(-0.1,0,0,0), Transparency = 1}):Play()
            TweenService:Create(DarkMask, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            FunctionWindow.Visible = false
            DarkMask.Visible = false
            MobileToggle.Text = "显示面板"
            GuiService:SetCoreGuiEnabled(Enum.CoreGuiType.TouchGui, true)
        end
    end)
end
if not isMobile then
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Escape and State.IsValid then
            local isShow = FunctionWindow.Visible
            if isShow then
                TweenService:Create(FunctionWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-0.1,0,0,0), Transparency = 1}):Play()
                TweenService:Create(DarkMask, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                task.wait(0.3)
                FunctionWindow.Visible = false
                DarkMask.Visible = false
            else
                FunctionWindow.Visible = true
                DarkMask.Visible = true
                TweenService:Create(FunctionWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0), Transparency = 0}):Play()
                TweenService:Create(DarkMask, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
            end
        end
    end)
end
DarkMask.MouseButton1Click:Connect(function()
    if State.IsValid and FunctionWindow.Visible then
        TweenService:Create(FunctionWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-0.1,0,0,0), Transparency = 1}):Play()
        TweenService:Create(DarkMask, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        FunctionWindow.Visible = false
        DarkMask.Visible = false
        if isMobile then
            local mobileBtn = MainGui:FindFirstChild(State.MobileButtonName)
            if mobileBtn then
                mobileBtn.Text = "显示面板"
                GuiService:SetCoreGuiEnabled(Enum.CoreGuiType.TouchGui, true)
            end
        end
    end
end)
local function verifyKey(key)
    return key == State.VerifyKey
end
VerifyButton.MouseButton1Click:Connect(function()
    local inputKey = KeyInput.Text
    if inputKey == "" then
        StatusText.Text = "请输入密钥后重试！"
        StatusText.TextColor3 = Color3.fromRGB(255,0,0)
        return
    end
    if verifyKey(inputKey) then
        State.IsValid = true
        StatusText.Text = "验证成功！正在加载功能面板..."
        StatusText.TextColor3 = Color3.fromRGB(0,255,0)
        VerifyButton.BackgroundColor3 = Color3.fromRGB(100,160,255)
        VerifyButton.Text = "已验证"
        VerifyButton.Active = false
        TweenService:Create(VerifyWindow, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1, Size = UDim2.new(VerifyWindow.Size.X.Scale, VerifyWindow.Size.X.Offset * 0.9, VerifyWindow.Size.Y.Scale, VerifyWindow.Size.Y.Offset * 0.9)}):Play()
        task.wait(0.3)
        VerifyWindow:Destroy()
        DarkMask.Visible = true
        FunctionWindow.Visible = true
        TweenService:Create(FunctionWindow, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0), Transparency = 0}):Play()
        if isMobile then
            GuiService:SetCoreGuiEnabled(Enum.CoreGuiType.TouchGui, false)
        end
    else
        StatusText.Text = "密钥错误！请重新输入"
        StatusText.TextColor3 = Color3.fromRGB(255,0,0)
        KeyInput.Text = ""
    end
end)
KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyButton.MouseButton1Click:Fire()
    end
end)
VerifyButton.MouseEnter:Connect(function()
    if VerifyButton.Active then
        TweenService:Create(VerifyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1, Size = UDim2.new(VerifyButton.Size.X.Scale, VerifyButton.Size.X.Offset * 1.02, VerifyButton.Size.Y.Scale, VerifyButton.Size.Y.Offset * 1.02)}):Play()
    end
end)
VerifyButton.MouseLeave:Connect(function()
    if VerifyButton.Active then
        TweenService:Create(VerifyButton, TweenInfo.new(0.2), {BackgroundTransparency = 0, Size = UDim2.new(VerifyButton.Size.X.Scale, VerifyButton.Size.X.Offset, VerifyButton.Size.Y.Scale, VerifyButton.Size.Y.Offset)}):Play()
    end
end)
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    State.DefaultWalkSpeed = Humanoid.WalkSpeed
    State.DefaultJumpPower = Humanoid.JumpPower
end)
local function randomFunc()
    local nums = {9,3,7,2,5}
    table.sort(nums, function(a,b) return math.random()>0.5 end)
    return nums[1]
end
coroutine.wrap(function()
    while task.wait(27) do
        if State.IsValid then
            randomFunc()
        end
    end
end)()
local function randomXor()
    local a,b = math.random(1,999), math.random(1,999)
    if bit32 then
        return bit32.bxor(a,b)
    else
        -- Fallback XOR implementation if bit32 is not available
        local result = 0
        local bit = 1
        while a > 0 or b > 0 do
            local aBit = a % 2
            local bBit = b % 2
            if aBit ~= bBit then
                result = result + bit
            end
            a = math.floor(a / 2)
            b = math.floor(b / 2)
            bit = bit * 2
        end
        return result
    end
end
local xorCoroutine = coroutine.create(function()
    while true do
        task.wait(15)
        if State.IsValid then
            randomXor()
        end
    end
end)
coroutine.resume(xorCoroutine)
