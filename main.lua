-- Holy Hub by HolyDestin

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Holy Hub",
    LoadingTitle = "Holy Hub Loading...",
    LoadingSubtitle = "by HolyDestin",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "HolyHubConfigs",
        FileName = "HolyHubSettings"
    },
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.Insert
})

local MainTab = Window:CreateTab("Main Cheats")

-- Feature flags
local features = {
    Aimbot = false,
    AutoCatch = false,
    ESP = false,
    SpeedHack = false,
    NoCooldown = false,
    AutoTackle = false,
    BallMagnet = false,
    AutoSnap = false,
    PlayerTeleport = false,
    AutoSprint = false,
    AntiDelay = false
}

-- Helpers
local function getClosestOpponent()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local distance = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < dist then
                    closest = player
                    dist = distance
                end
            end
        end
    end
    return closest
end

-- Toggle aimbot with Q or Left D-Pad
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if (input.KeyCode == Enum.KeyCode.Q) or (input.KeyCode == Enum.KeyCode.DPadLeft) then
        features.Aimbot = not features.Aimbot
        Rayfield:Notify({
            Title = "Holy Hub",
            Content = "Aimbot " .. (features.Aimbot and "Enabled" or "Disabled"),
            Duration = 3
        })
    end
end)

-- Main Aimbot Logic (aims at closest wide receiver, adjusts throw height)
local THROW_SPEED = 95

local function predictPosition(origin, targetPos, targetVel)
    local displacement = targetPos - origin
    local time = displacement.Magnitude / THROW_SPEED
    return targetPos + targetVel * time + Vector3.new(0, 10, 0) -- add height offset for throw arc
end

local function doAimbot()
    if not features.Aimbot then return end
    local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not origin then return end

    local closestTeammate, shortestDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team == LocalPlayer.Team and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - origin.Position).Magnitude
                if dist < shortestDist then
                    closestTeammate = player
                    shortestDist = dist
                end
            end
        end
    end

    if closestTeammate and closestTeammate.Character then
        local hrp = closestTeammate.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local predicted = predictPosition(origin.Position, hrp.Position, hrp.Velocity)
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predicted)
            -- You said no auto throw so you must manually throw/pass after aiming
        end
    end
end

RunService.RenderStepped:Connect(function()
    if features.ESP then
        -- Simple ESP for players and ball
        -- (fill with your ESP logic or I can help here)
    end
    if features.SpeedHack then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 40 -- boost speed
        end
    else
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 -- default speed
        end
    end

    if features.NoCooldown then
        -- Remove cooldown logic here (depends on game specifics)
    end

    if features.AutoTackle then
        -- Auto tackle closest opponent if near
        local opponent = getClosestOpponent()
        if opponent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (opponent.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if dist < 5 then
                -- Trigger tackle action (game-specific)
            end
        end
    end

    if features.BallMagnet then
        -- Ball magnet logic (game-specific)
    end

    if features.AutoSnap then
        -- Auto snap / kickoff logic (game-specific)
    end

    if features.PlayerTeleport then
        -- Teleport logic (game-specific)
    end

    if features.AutoSprint then
        -- Infinite sprint / stamina hack
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Stamina = math.huge -- example if stamina exists
            end
        end
    end

    if features.AntiDelay then
        -- Reduce lag/desync if possible
    end

    doAimbot()
end)

-- Create toggles in the UI
MainTab:CreateToggle({
    Name = "Aimbot (Q / Left D-Pad to toggle)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(val)
        features.Aimbot = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Catch",
    CurrentValue = false,
    Flag = "AutoCatchToggle",
    Callback = function(val)
        features.AutoCatch = val
        -- Implement auto catch logic here
    end
})

MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(val)
        features.ESP = val
        -- Setup or cleanup ESP here
    end
})

MainTab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHackToggle",
    Callback = function(val)
        features.SpeedHack = val
    end
})

MainTab:CreateToggle({
    Name = "No Cooldown",
    CurrentValue = false,
    Flag = "NoCooldownToggle",
    Callback = function(val)
        features.NoCooldown = val
        -- Implement cooldown removal logic here
    end
})

MainTab:CreateToggle({
    Name = "Auto Tackle",
    CurrentValue = false,
    Flag = "AutoTackleToggle",
    Callback = function(val)
        features.AutoTackle = val
    end
})

MainTab:CreateToggle({
    Name = "Ball Magnet",
    CurrentValue = false,
    Flag = "BallMagnetToggle",
    Callback = function(val)
        features.BallMagnet = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Snap / Kickoff",
    CurrentValue = false,
    Flag = "AutoSnapToggle",
    Callback = function(val)
        features.AutoSnap = val
    end
})

MainTab:CreateToggle({
    Name = "Player Teleport",
    CurrentValue = false,
    Flag = "PlayerTeleportToggle",
    Callback = function(val)
        features.PlayerTeleport = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Sprint / Stamina Hack",
    CurrentValue = false,
    Flag = "AutoSprintToggle",
    Callback = function(val)
        features.AutoSprint = val
    end
})

MainTab:CreateToggle({
    Name = "Anti-Delay / Lag Reduction",
    CurrentValue = false,
    Flag = "AntiDelayToggle",
    Callback = function(val)
        features.AntiDelay = val
    end
})

Rayfield:Notify({
    Title = "Holy Hub",
    Content = "Loaded successfully! Press Insert to toggle UI",
    Duration = 5
})
