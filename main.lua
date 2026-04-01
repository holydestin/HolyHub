local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- // KEY SYSTEM - SCRIPT GATE
local VALID_KEYS = {
    ["Holykilla2026"] = true,
    ["LekoSparda2026"] = true
}

-- // HWID Whitelist
local VALID_HWIDS = {}

-- // Get HWID function
local function getHWID()
    if gethwid then
        return gethwid()
    elseif syn and syn.get_hwid then
        return syn.get_hwid()
    elseif KRNL and KRNL.get_hwid then
        return KRNL.get_hwid()
    elseif fluxus and fluxus.get_hwid then
        return fluxus.get_hwid()
    elseif identifyexecutor then
        return tostring(identifyexecutor()) .. tostring(player.UserId)
    else
        return tostring(game:GetService("RbxAnalyticsService"):GetClientId())
    end
end

local currentHWID = getHWID()
print("Your HWID: " .. tostring(currentHWID))

local function isHWIDValid()
    if next(VALID_HWIDS) == nil then
        return true
    end
    return VALID_HWIDS[currentHWID] == true
end

local function validateKey(key)
    if not key or key == "" then
        return false, "No key entered"
    end
    if not isHWIDValid() then
        return false, "HWID Not Whitelisted"
    end
    if VALID_KEYS[key] then
        return true, "Lifetime Key Active"
    else
        return false, "Invalid Key"
    end
end

-- // Create Key Gate UI
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeyGate"
keyGui.ResetOnSpawn = false
keyGui.Parent = player.PlayerGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 350, 0, 250)
keyFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
keyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = keyGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 8)
keyCorner.Parent = keyFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "🔐 Key System"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = keyFrame

local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(1, -20, 0, 35)
inputFrame.Position = UDim2.new(0, 10, 0, 100)
inputFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputFrame.BorderSizePixel = 0
inputFrame.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -10, 1, 0)
keyInput.Position = UDim2.new(0, 5, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = "Enter lifetime key..."
keyInput.Text = ""
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.TextSize = 14
keyInput.Font = Enum.Font.Gotham
keyInput.Parent = inputFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Enter key to unlock"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = keyFrame

local validateBtn = Instance.new("TextButton")
validateBtn.Size = UDim2.new(1, -20, 0, 35)
validateBtn.Position = UDim2.new(0, 10, 0, 150)
validateBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
validateBtn.Text = "Validate Key"
validateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
validateBtn.TextSize = 14
validateBtn.Font = Enum.Font.GothamBold
validateBtn.Parent = keyFrame

local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 80, 0, 28)
exitBtn.Position = UDim2.new(1, -90, 1, -38)
exitBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
exitBtn.Text = "Exit"
exitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
exitBtn.TextSize = 12
exitBtn.Font = Enum.Font.GothamBold
exitBtn.Parent = keyFrame

exitBtn.MouseButton1Click:Connect(function()
    keyGui:Destroy()
end)

local keyValidated = false
local validatedKey = nil

validateBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    local success, message = validateKey(key)
    
    if success then
        keyValidated = true
        validatedKey = key
        statusLabel.Text = "✅ " .. message
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        task.wait(1)
        keyGui:Destroy()
    else
        statusLabel.Text = "❌ " .. message
        statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end)

while not keyValidated do
    task.wait(0.1)
    if not keyGui or not keyGui.Parent then
        return
    end
end

-- // RAYFIELD UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Lock On System",
    LoadingTitle = "Lock On System",
    LoadingSubtitle = "Key: " .. validatedKey,
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483345998)
local KeysTab = Window:CreateTab("Keys", 4483345998)

local Config = {
    BallESP = false,
    AutoSwing = false,
    AutoAim = true,
    ZoneESP = true,
    PitchUI = true,
    PitchESP = false
}

MainTab:CreateToggle({
    Name = "Ball ESP",
    CurrentValue = Config.BallESP,
    Callback = function(Value) Config.BallESP = Value end
})

MainTab:CreateToggle({
    Name = "Auto Swing",
    CurrentValue = Config.AutoSwing,
    Callback = function(Value) Config.AutoSwing = Value end
})

MainTab:CreateToggle({
    Name = "Auto Aim",
    CurrentValue = Config.AutoAim,
    Callback = function(Value) Config.AutoAim = Value end
})

MainTab:CreateToggle({
    Name = "Zone ESP",
    CurrentValue = Config.ZoneESP,
    Callback = function(Value) Config.ZoneESP = Value end
})

MainTab:CreateToggle({
    Name = "Pitch ESP (Landing)",
    CurrentValue = Config.PitchESP,
    Callback = function(Value) Config.PitchESP = Value end
})

MainTab:CreateToggle({
    Name = "Pitch UI",
    CurrentValue = Config.PitchUI,
    Callback = function(Value) Config.PitchUI = Value end
})

KeysTab:CreateSection("Key Info")
KeysTab:CreateLabel("Active: " .. validatedKey)
KeysTab:CreateLabel("HWID: " .. string.sub(tostring(currentHWID), 1, 20) .. "...")

KeysTab:CreateButton({
    Name = "Copy HWID",
    Callback = function()
        if setclipboard then
            setclipboard(tostring(currentHWID))
            Rayfield:Notify({Title = "Copied", Content = "HWID copied to clipboard", Duration = 3})
        end
    end
})

-- // ESP Drawings
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

local pitchESPDrawing = Drawing.new("Circle")
pitchESPDrawing.Thickness = 3
pitchESPDrawing.Filled = true
pitchESPDrawing.Color = Color3.fromRGB(255, 0, 255)
pitchESPDrawing.NumSides = 32
pitchESPDrawing.Visible = false
pitchESPDrawing.Radius = 15

local hasSwung = false
local trackedBall = nil
local trackedZone = nil
local trackedStrikeBounds = nil
local ballESPDrawing = nil
local connections = {}

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
                elseif string.find(name, h) then score += 25 end
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

local function isBallInZone()
    if not trackedBall then return false end
    local zone = trackedStrikeBounds or trackedZone
    if not zone then return false end
    local ballPart = getBallPart()
    if not ballPart then return false end
    local ballPos = ballPart.Position
    local vel = ballPart.AssemblyLinearVelocity
    local checkPos = vel.Magnitude > 1 and (ballPos + vel * 0.15) or ballPos
    local localPos = zone.CFrame:PointToObjectSpace(checkPos)
    local half = zone.Size * 0.5
    return math.abs(localPos.X) <= half.X and math.abs(localPos.Y) <= half.Y and math.abs(localPos.Z) <= (half.Z + 2)
end

local function drawZoneESP()
    if not Config.ZoneESP then
        zoneESPDrawOuter.Visible = false
        zoneESPDrawMid.Visible = false
        zoneESPDrawCore.Visible = false
        return
    end
    local zone = trackedStrikeBounds or trackedZone
    if not zone then
        zoneESPDrawOuter.Visible = false
        zoneESPDrawMid.Visible = false
        zoneESPDrawCore.Visible = false
        return
    end
    local cf = zone.CFrame
    local size = zone.Size * Vector3.new(0.92, 0.88, 1)
    local viewport = camera.ViewportSize
    local margin = 60
    local corners = {
        (cf * CFrame.new(-size.X/2, size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new(size.X/2, size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new(size.X/2, -size.Y/2, -size.Z/2)).Position,
        (cf * CFrame.new(-size.X/2, size.Y/2, size.Z/2)).Position,
        (cf * CFrame.new(size.X/2, size.Y/2, size.Z/2)).Position,
        (cf * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)).Position,
        (cf * CFrame.new(size.X/2, -size.Y/2, size.Z/2)).Position,
    }
    local projected = {}
    for _, c in ipairs(corners) do
        local v, visible = camera:WorldToViewportPoint(c)
        if visible and v.Z > 0 and v.X >= -margin and v.X <= viewport.X + margin and v.Y >= -margin and v.Y <= viewport.Y + margin then
            projected[#projected + 1] = Vector2.new(v.X, v.Y)
        end
    end
    if #projected < 2 then
        zoneESPDrawOuter.Visible = false
        zoneESPDrawMid.Visible = false
        zoneESPDrawCore.Visible = false
        return
    end
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    for _, p in ipairs(projected) do
        minX = math.min(minX, p.X); minY = math.min(minY, p.Y)
        maxX = math.max(maxX, p.X); maxY = math.max(maxY, p.Y)
    end
    local basePos = Vector2.new(minX, minY)
    local baseSize = Vector2.new(maxX - minX, maxY - minY)
    local grow = math.clamp(math.max(baseSize.X, baseSize.Y) * 0.18, 6, 24)
    local zoneColor = Color3.fromRGB(170, 70, 255)
    zoneESPDrawOuter.Position = basePos - Vector2.new(grow, grow)
    zoneESPDrawOuter.Size = baseSize + Vector2.new(grow * 2, grow * 2)
    zoneESPDrawOuter.Color = zoneColor
    zoneESPDrawOuter.Visible = true
    zoneESPDrawMid.Position = basePos - Vector2.new(8, 8)
    zoneESPDrawMid.Size = baseSize + Vector2.new(16, 16)
    zoneESPDrawMid.Color = zoneColor
    zoneESPDrawMid.Visible = true
    zoneESPDrawCore.Position = basePos
    zoneESPDrawCore.Size = baseSize
    zoneESPDrawCore.Color = zoneColor
    zoneESPDrawCore.Visible = true
end

local function getPredictedLandingPosition()
    if not trackedBall then return nil end
    local ballPart = getBallPart()
    if not ballPart then return nil end
    local zone = trackedStrikeBounds or trackedZone
    if not zone then return nil end
    local ballPos = ballPart.Position
    local velocity = ballPart.AssemblyLinearVelocity
    if velocity.Magnitude < 0.1 then return nil end
    local zoneCFrame = zone.CFrame
    local localPos = zoneCFrame:PointToObjectSpace(ballPos)
    local localVel = zoneCFrame:VectorToObjectSpace(velocity)
    if localVel.Z >= -0.1 then return nil end
    local timeToReach = -localPos.Z / localVel.Z
    if timeToReach < 0 or timeToReach > 5 then return nil end
    local predictedLocalPos = localPos + localVel * timeToReach
    return zoneCFrame:PointToWorldSpace(predictedLocalPos)
end

local function updatePitchESP()
    if not Config.PitchESP or not trackedBall then
        pitchESPDrawing.Visible = false
        return
    end
    local landingPos = getPredictedLandingPosition()
    if not landingPos then
        pitchESPDrawing.Visible = false
        return
    end
    local screenPos, onScreen = camera:WorldToViewportPoint(landingPos)
    if onScreen and screenPos.Z > 0 then
        pitchESPDrawing.Position = Vector2.new(screenPos.X, screenPos.Y)
        local distance = (landingPos - camera.CFrame.Position).Magnitude
        local pulse = math.sin(tick() * 10) * 3
        pitchESPDrawing.Radius = math.clamp(300 / distance, 10, 30) + pulse
        pitchESPDrawing.Visible = true
    else
        pitchESPDrawing.Visible = false
    end
end

local function updateBallESP()
    if not Config.BallESP or not trackedBall then
        if ballESPDrawing then ballESPDrawing.Visible = false end
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
        ballESPDrawing.Radius = math.clamp(500 / distance, 8, 40)
        ballESPDrawing.Visible = true
    else
        ballESPDrawing.Visible = false
    end
end

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

local function autoSwing()
    if not Config.AutoSwing then return end
    if hasSwung then return end
    if not isBallInZone() then return end
    hasSwung = true
    local screenPos = getBallScreenPos()
    local x = screenPos and screenPos.X or mouse.X
    local y = screenPos and screenPos.Y or mouse.Y
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.2)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

local ballAddedConn = workspace.Balls.ChildAdded:Connect(function(child)
    if child.Name == "PitchedBall" then
        trackedBall = child
        hasSwung = false
        local ancestryConn = child.AncestryChanged:Connect(function()
            if not child:IsDescendantOf(workspace) then
                trackedBall = nil
                hasSwung = false
            end
        end)
        table.insert(connections, ancestryConn)
    end
end)
table.insert(connections, ballAddedConn)

local renderConn = RunService.RenderStepped:Connect(function()
    ensureZoneTargets()
    drawZoneESP()
    updateBallESP()
    updatePitchESP()
    if trackedBall and trackedBall:IsDescendantOf(workspace) then
        doAutoAim()
        autoSwing()
    end
end)
table.insert(connections, renderConn)

print("✅ Lock On System loaded with Key: " .. validatedKey)
