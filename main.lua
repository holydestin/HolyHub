-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Create the main window
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
    ToggleUIKeybind = Enum.KeyCode.Insert -- Press 'Insert' to toggle the UI
})

-- Create a tab for the aimbot
local AimbotTab = Window:CreateTab("Aimbot")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Aimbot settings
local aimbotEnabled = false
local THROW_SPEED = 95 -- Adjust as needed

-- Function to get the closest teammate
local function getClosestTeammate()
    local bestPlayer, shortestDist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team == LocalPlayer.Team and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Camera.ViewportSize / 2).Magnitude
                    if dist < shortestDist then
                        bestPlayer = player
                        shortestDist = dist
                    end
                end
            end
        end
    end
    return bestPlayer
end

-- Function to predict the position of the target
local function predictPosition(origin, targetPos, targetVel)
    local displacement = targetPos - origin
    local time = displacement.Magnitude / THROW_SPEED
    return targetPos + targetVel * time + Vector3.new(0, 10, 0) -- Adjust height as needed
end

-- Aimbot function
local function aimAssist()
    if not aimbotEnabled then return end
    local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not origin then return end

    local teammate = getClosestTeammate()
    if teammate and teammate.Character then
        local hrp = teammate.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local predicted = predictPosition(origin.Position, hrp.Position, hrp.Velocity)
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predicted)
        end
    end
end

-- Connect the aimbot function to RenderStepped
RunService.RenderStepped:Connect(function()
    pcall(aimAssist)
end)

-- Create a toggle in the GUI to enable/disable the aimbot
AimbotTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        aimbotEnabled = Value
    end
})
