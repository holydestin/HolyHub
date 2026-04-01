local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- // State
local isLocked = false
local hasSwung = false
local trackedBall = nil
local trackedZone = nil
local trackedStrikeBounds = nil
local ballESPDrawing = nil
local connections = {}

-- // Config
local Config = {
    BallESP = false,
    AutoSwing = false,
    AutoAim = true,
    ZoneESP = true,
    PitchUI = true
}

-- // ORION-STYLE UI LIBRARY (Built-in)
local OrionLib = {}

function OrionLib:MakeWindow(config)
    config = config or {}
    local Window = {}
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = config.Name or "Orion"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player.PlayerGui
    Window.ScreenGui = ScreenGui
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 220, 0, 350)
    Main.Position = UDim2.new(0, 20, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    Window.Main = Main
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = Main
    
    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Color3.fromRGB(60, 60, 60)
    MainStroke.Thickness = 1
    MainStroke.Parent = Main
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 38)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar
    
    local Fix = Instance.new("Frame")
    Fix.Size = UDim2.new(1, 0, 0, 10)
    Fix.Position = UDim2.new(0, 0, 1, -10)
    Fix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Fix.BorderSizePixel = 0
    Fix.Parent = TopBar
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name or "Orion"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 28, 0, 28)
    Close.Position = UDim2.new(1, -33, 0, 5)
    Close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 255, 255)
    Close.TextSize = 13
    Close.Font = Enum.Font.GothamBold
    Close.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = Close
    
    -- Content
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -16, 1, -54)
    Content.Position = UDim2.new(0, 8, 0, 46)
    Content.BackgroundTransparency = 1
    Content.Parent = Main
    
    local UIList = Instance.new("UIListLayout")
    UIList.Padding = UDim.new(0, 6)
    UIList.Parent = Content
    
    -- Methods
    function Window:MakeTab(tabConfig)
        tabConfig = tabConfig or {}
        local Tab = {}
        
        -- Section
        local Section = Instance.new("Frame")
        Section.Size = UDim2.new(1, 0, 0, 30)
        Section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Section.BorderSizePixel = 0
        Section.Parent = Content
        
        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 6)
        SectionCorner.Parent = Section
        
        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Size = UDim2.new(1, -10, 1, 0)
        SectionTitle.Position = UDim2.new(0, 10, 0, 0)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Text = tabConfig.Name or "Tab"
        SectionTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        SectionTitle.TextSize = 12
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        SectionTitle.Parent = Section
        
        function Tab:AddToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local Toggle = {}
            local Default = toggleConfig.Default or false
            local Callback = toggleConfig.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = Content
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = ToggleFrame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = toggleConfig.Name or "Toggle"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(0, 44, 0, 22)
            ToggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
            ToggleBtn.BackgroundColor3 = Default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 70)
            ToggleBtn.Text = Default and "ON" or "OFF"
            ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleBtn.TextSize = 11
            ToggleBtn.Font = Enum.Font.GothamBold
            ToggleBtn.Parent = ToggleFrame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 11)
            BtnCorner.Parent = ToggleBtn
            
            local Value = Default
            
            ToggleBtn.MouseButton1Click:Connect(function()
                Value = not Value
                ToggleBtn.BackgroundColor3 = Value and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 70)
                ToggleBtn.Text = Value and "ON" or "OFF"
                pcall(Callback, Value)
            end)
            
            function Toggle:Set(val)
                Value = val
                ToggleBtn.BackgroundColor3 = Value and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(70, 70, 70)
                ToggleBtn.Text = Value and "ON" or "OFF"
                pcall(Callback, Value)
            end
            
            return Toggle
        end
        
        function Tab:AddButton(btnConfig)
            btnConfig = btnConfig or {}
            
            local Btn = Instance.new("TextButton")
            Btn.Size = UDim2.new(1, 0, 0, 34)
            Btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
            Btn.Text = btnConfig.Name or "Button"
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 13
            Btn.Font = Enum.Font.GothamBold
            Btn.Parent = Content
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 6)
            Corner.Parent = Btn
            
            Btn.MouseButton1Click:Connect(function()
                pcall(btnConfig.Callback)
            end)
        end
        
        function Tab:AddLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.BackgroundTransparency = 1
            Label.Text = text or ""
            Label.TextColor3 = Color3.fromRGB(180, 180, 180)
            Label.TextSize = 11
            Label.Font = Enum.Font.Gotham
            Label.Parent = Content
        end
        
        return Tab
    end
    
    function Window:Toggle()
        Main.Visible = not Main.Visible
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    Close.MouseButton1Click:Connect(function()
        Window:Toggle()
    end)
    
    return Window
end

-- // Create Orion Window
local Window = OrionLib:MakeWindow({
    Name = " Lock On System",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "LockOn"
})

-- // Create Tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- // Status UI (Pitch UI) - Separate from main UI
local statusGui = Instance.new("ScreenGui")
statusGui.Name = "PitchStatus"
statusGui.ResetOnSpawn = false
statusGui.Parent = player.PlayerGui

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(0, 180, 0, 50)
statusFrame.Position = UDim2.new(0.5, -90, 0, 20)
statusFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusFrame.BackgroundTransparency = 0.3
statusFrame.BorderSizePixel = 0
statusFrame.Parent = statusGui

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Parent = statusFrame

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(0, 10, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusFrame

local statusDotCorner = Instance.new("UICorner")
statusDotCorner.CornerRadius = UDim.new(1, 0)
statusDotCorner.Parent = statusDot

-- // Add Toggles to UI
MainTab:AddToggle({
    Name = "Ball ESP",
    Default = Config.BallESP,
    Callback = function(Value)
        Config.BallESP = Value
    end
})

MainTab:AddToggle({
    Name = "Auto Swing",
    Default = Config.AutoSwing,
    Callback = function(Value)
        Config.AutoSwing = Value
    end
})

MainTab:AddToggle({
    Name = "Auto Aim",
    Default = Config.AutoAim,
    Callback = function(Value)
        Config.AutoAim = Value
    end
})

MainTab:AddToggle({
    Name = "Zone ESP",
    Default = Config.ZoneESP,
    Callback = function(Value)
        Config.ZoneESP = Value
    end
})

MainTab:AddToggle({
    Name = "Pitch UI",
    Default = Config.PitchUI,
    Callback = function(Value)
        Config.PitchUI = Value
        statusGui.Enabled = Value
    end
})

MainTab:AddLabel("Press K to toggle this menu")

MainTab:AddButton({
    Name = "Unload Script",
    Callback = function()
        -- Cleanup
        for _, conn in ipairs(connections) do
            if conn then conn:Disconnect() end
        end
        if ballESPDrawing then ballESPDrawing:Remove() end
        if zoneESPDrawOuter then zoneESPDrawOuter:Remove() end
        if zoneESPDrawMid then zoneESPDrawMid:Remove() end
        if zoneESPDrawCore then zoneESPDrawCore:Remove() end
        Window:Destroy()
        statusGui:Destroy()
        print("Script unloaded")
    end
})

local zoneESPDrawOuter = Drawing.new("Square")
zoneESPDrawOuter.Thickness = 8
zoneESPDrawOuter.Transparency = 0.25
zoneESPDrawOuter.Filled = false
zoneESPDrawOuter.Visible = false
zoneESPDrawOuter.Color = Color3.fromRGB(170, 70, 255)

local zoneESPDrawMid = Drawing.new("Square")
zoneESPDrawMid.Thickness = 4
zoneESPDrawMid.Transparency = 0.55
zoneESPDrawMid.Filled = false
zoneESPDrawMid.Visible = false
zoneESPDrawMid.Color = Color3.fromRGB(170, 70, 255)

local zoneESPDrawCore = Drawing.new("Square")
zoneESPDrawCore.Thickness = 2
zoneESPDrawCore.Transparency = 1
zoneESPDrawCore.Filled = false
zoneESPDrawCore.Visible = false
zoneESPDrawCore.Color = Color3.fromRGB(170, 70, 255)

-- // State
local isLocked = false
local hasSwung = false
local trackedBall = nil
local trackedZone = nil
local trackedStrikeBounds = nil
local ballESPDrawing = nil
local connections = {}
local autoAimEnabled = true
local zoneESPEnabled = true
local SWING_DISTANCE = 10

-- // Strike Zone Finders
local function findLikelyStrikeZone()
    local batting = workspace:FindFirstChild("Batting")
    if batting then
        local exact = batting:FindFirstChild("StrikeZone")
        if exact and exact:IsA("BasePart") then return exact end
    end
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("BasePart") then
            local n = string.lower(desc.Name)
            for _, hint in ipairs({"strike", "zone"}) do
                if string.find(n, hint) then return desc end
            end
        end
    end
    return nil
end

local function findLikelyStrikeBounds()
    local ignore = workspace:FindFirstChild("Ignore")
    if ignore then
        local bgui = ignore:FindFirstChild("BGUI") or ignore:FindFirstChild("BGui") or ignore:FindFirstChild("Bgui")
        if bgui then
            local exact = bgui:FindFirstChild("BlackBoarder") or bgui:FindFirstChild("BlackBorder")
            if exact and exact:IsA("BasePart") then return exact end
        end
    end

    local hints = {"blackboarder","blackborder","boarder","strikeborder","strikebox","strike","zone","bgui","border"}
    local best, bestScore = nil, -math.huge

    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc:IsA("BasePart") then
            if player.Character and desc:IsDescendantOf(player.Character) then continue end
            if desc:FindFirstAncestorOfClass("Tool") then continue end

            local name = string.lower(desc.Name)
            local score = 0
            for _, h in ipairs(hints) do
                if name == h then score += 100
                elseif string.find(name, h) then score += 25
                end
            end
            if string.find(name,"glove") or string.find(name,"mitt") or string.find(name,"hand") then score -= 100 end
            score += desc.Anchored and 10 or -15
            if not desc.CanCollide then score += 5 end
            if ignore and desc:IsDescendantOf(ignore) then score += 60 end
            if desc:FindFirstAncestor("BGUI") or desc:FindFirstAncestor("BGui") or desc:FindFirstAncestor("Bgui") then score += 40 end
            local s = desc.Size
            if math.min(s.X,s.Y,s.Z) < 0.8 and math.max(s.X,s.Y,s.Z) > 2 then score += 25 end
            if score > bestScore then bestScore = score; best = desc end
        end
    end
    return bestScore > 0 and best or nil
end

local function ensureZoneTargets()
    if not trackedZone or not trackedZone.Parent then
        trackedZone = findLikelyStrikeZone()
    end
    if not trackedStrikeBounds or not trackedStrikeBounds.Parent then
        trackedStrikeBounds = findLikelyStrikeBounds()
    end
end

-- // Ball helpers
local function getBallPart()
    if not trackedBall then return nil end
    if trackedBall:IsA("BasePart") then return trackedBall end
    if trackedBall.PrimaryPart then return trackedBall.PrimaryPart end
    return trackedBall:FindFirstChildWhichIsA("BasePart", true)
end

local function getBallPosition()
    local p = getBallPart()
    return p and p.Position or nil
end

local function getBallScreenPos()
    local pos = getBallPosition()
    if not pos then return nil end
    local sp, onScreen = camera:WorldToScreenPoint(pos)
    return onScreen and Vector2.new(sp.X, sp.Y) or nil
end

-- // Zone check
local function isBallInZone()
    if not trackedBall then return false end
    local zone = trackedStrikeBounds or trackedZone
    if not zone then return false end

    local ballPart = getBallPart()
    if not ballPart then return false end

    local ballPos  = ballPart.Position
    local vel      = ballPart.AssemblyLinearVelocity
    local checkPos = vel.Magnitude > 1 and (ballPos + vel * 0.15) or ballPos

    local localPos = zone.CFrame:PointToObjectSpace(checkPos)
    local half     = zone.Size * 0.5

    return math.abs(localPos.X) <= half.X
       and math.abs(localPos.Y) <= half.Y
       and math.abs(localPos.Z) <= (half.Z + 2)
end

-- // Zone ESP
local function drawZoneESP()
    if not Config.ZoneESP then
        zoneESPDrawOuter.Visible = false
        zoneESPDrawMid.Visible   = false
        zoneESPDrawCore.Visible  = false
        return
    end
    local zone = trackedStrikeBounds or trackedZone
    if not zone then
        zoneESPDrawOuter.Visible = false
        zoneESPDrawMid.Visible   = false
        zoneESPDrawCore.Visible  = false
        return
    end

    local cf       = zone.CFrame
    local size     = zone.Size * Vector3.new(0.92, 0.88, 1)
    local viewport = camera.ViewportSize
    local margin   = 60

    local corners = {
        (cf * CFrame.new(-size.X/2,  size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new( size.X/2,  size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new( size.X/2, -size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new(-size.X/2,  size.Y/2,  size.Z/2)).Position,
        (cf * CFrame.new( size.X/2,  size.Y/2,  size.Z/2)).Position,
        (cf * CFrame.new(-size.X/2, -size.Y/2,  size.Z/2)).Position,
        (cf * CFrame.new( size.X/2, -size.Y/2,  size.Z/2)).Position,
    }

    local projected = {}
    for _, c in ipairs(corners) do
        local v, visible = camera:WorldToViewportPoint(c)
        if visible and v.Z > 0
            and v.X >= -margin and v.X <= viewport.X + margin
            and v.Y >= -margin and v.Y <= viewport.Y + margin then
            projected[#projected + 1] = Vector2.new(v.X, v.Y)
        end
    end

    if #projected < 2 then
        zoneESPDrawOuter.Visible = false
        zoneESPDrawMid.Visible   = false
        zoneESPDrawCore.Visible  = false
        return
    end

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    for _, p in ipairs(projected) do
        minX = math.min(minX, p.X); minY = math.min(minY, p.Y)
        maxX = math.max(maxX, p.X); maxY = math.max(maxY, p.Y)
    end

    local basePos   = Vector2.new(minX, minY)
    local baseSize  = Vector2.new(maxX - minX, maxY - minY)
    local grow      = math.clamp(math.max(baseSize.X, baseSize.Y) * 0.18, 6, 24)
    local zoneColor = Color3.fromRGB(170, 70, 255)

    zoneESPDrawOuter.Position = basePos - Vector2.new(grow, grow)
    zoneESPDrawOuter.Size     = baseSize + Vector2.new(grow * 2, grow * 2)
    zoneESPDrawOuter.Color    = zoneColor
    zoneESPDrawOuter.Visible  = true
    zoneESPDrawMid.Position   = basePos - Vector2.new(8, 8)
    zoneESPDrawMid.Size       = baseSize + Vector2.new(16, 16)
    zoneESPDrawMid.Color      = zoneColor
    zoneESPDrawMid.Visible    = true
    zoneESPDrawCore.Position  = basePos
    zoneESPDrawCore.Size      = baseSize
    zoneESPDrawCore.Color     = zoneColor
    zoneESPDrawCore.Visible   = true
end

-- // Ball ESP Drawing
local function updateBallESP()
    if not Config.BallESP or not trackedBall then
        if ballESPDrawing then
            ballESPDrawing.Visible = false
        end
        return
    end
    
    local ballPart = getBallPart()
    if not ballPart then
        if ballESPDrawing then ballESPDrawing.Visible = false end
        return
    end
    
    if not ballESPDrawing then
        ballESPDrawing = Drawing.new("Circle")
        ballESPDrawing.Thickness = 2
        ballESPDrawing.Filled = false
        ballESPDrawing.Color = Color3.fromRGB(255, 255, 0)
        ballESPDrawing.NumSides = 16
    end
    
    local pos = ballPart.Position
    local screenPos, onScreen = camera:WorldToViewportPoint(pos)
    
    if onScreen and screenPos.Z > 0 then
        ballESPDrawing.Position = Vector2.new(screenPos.X, screenPos.Y)
        local distance = (pos - camera.CFrame.Position).Magnitude
        local radius = math.clamp(500 / distance, 8, 40)
        ballESPDrawing.Radius = radius
        ballESPDrawing.Visible = true
    else
        ballESPDrawing.Visible = false
    end
end

-- // Auto Aim
local function doAutoAim()
    if not Config.AutoAim then return end
    if hasSwung then return end
    if not trackedBall or not trackedBall:IsDescendantOf(workspace) then return end

    local ballPart = getBallPart()
    if not ballPart then return end

    local sp, onScreen = camera:WorldToViewportPoint(ballPart.Position)
    if not onScreen or sp.Z < 0 then return end

    if math.abs(sp.X - mouse.X) > 1 or math.abs(sp.Y - mouse.Y) > 1 then
        VirtualInputManager:SendMouseMoveEvent(sp.X, sp.Y, game)
    end
end

-- // Auto Swing
local function autoSwing()
    if not Config.AutoSwing then return end
    if hasSwung then return end
    if not isBallInZone() then return end
    
    hasSwung = true
    if Config.PitchUI then
        statusLabel.Text = "⚾  SWINGING!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    end
    
    local screenPos = getBallScreenPos()
    local x = screenPos and screenPos.X or mouse.X
    local y = screenPos and screenPos.Y or mouse.Y
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-- // UI Update
local function updateUI(state)
    if not Config.PitchUI then
        statusGui.Enabled = false
        return
    end
    statusGui.Enabled = true
    
    if state == "tracking" then
        statusLabel.Text = "🟡  BALL INCOMING"
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    elseif state == "none" then
        statusLabel.Text = "🔴  NO BALL"
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    end
end

-- // Watch for PitchedBall
local ballAddedConn = workspace.Balls.ChildAdded:Connect(function(child)
    if child.Name == "PitchedBall" then
        trackedBall = child
        hasSwung = false
        updateUI("tracking")

        local ancestryConn = child.AncestryChanged:Connect(function()
            if not child:IsDescendantOf(workspace) then
                trackedBall = nil
                hasSwung = false
                updateUI("none")
            end
        end)
        table.insert(connections, ancestryConn)
    end
end)
table.insert(connections, ballAddedConn)

-- // Main loop
local renderConn = RunService.RenderStepped:Connect(function()
    ensureZoneTargets()
    drawZoneESP()
    updateBallESP()

    if trackedBall and trackedBall:IsDescendantOf(workspace) then
        doAutoAim()
        autoSwing()
    end
end)
table.insert(connections, renderConn)

-- // Keybind (K to toggle UI)
local inputConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.K then
        Window:Toggle()
    end
end)
table.insert(connections, inputConn)

print("Lock On System loaded! Press K to toggle UI")
