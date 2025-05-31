local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local THROW_SPEED = 95 -- adjust if needed
local aimbotEnabled = false

-- Create GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HolyHubGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Holy Hub - Football Aimbot"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 200, 0, 40)
ToggleButton.Position = UDim2.new(0, 25, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
ToggleButton.Text = "Toggle Aimbot OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = Frame

local LandingLabel = Instance.new("TextLabel")
LandingLabel.Size = UDim2.new(1, -20, 0, 40)
LandingLabel.Position = UDim2.new(0, 10, 0, 85)
LandingLabel.BackgroundTransparency = 1
LandingLabel.Text = "Ball Landing: N/A"
LandingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
LandingLabel.Font = Enum.Font.SourceSans
LandingLabel.TextSize = 14
LandingLabel.TextWrapped = true
LandingLabel.Parent = Frame

-- Functions

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

local function predictPosition(origin, targetPos, targetVel)
    local displacement = targetPos - origin
    local time = displacement.Magnitude / THROW_SPEED
    return targetPos + targetVel * time, time
end

local function aimAssist()
    if not aimbotEnabled then return end
    local origin = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not origin then return end

    local teammate = getClosestTeammate()
    if teammate and teammate.Character then
        local hrp = teammate.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local predicted, time = predictPosition(origin.Position, hrp.Position, hrp.Velocity)
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, predicted)

            -- Update Landing info label with predicted position and estimated time
            LandingLabel.Text = string.format("Ball Landing in %.2f sec at (%.1f, %.1f, %.1f)", time, predicted.X, predicted.Y, predicted.Z)
        else
            LandingLabel.Text = "Ball Landing: N/A"
        end
    else
        LandingLabel.Text = "Ball Landing: N/A"
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    if aimbotEnabled then
        ToggleButton.Text = "Toggle Aimbot ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        ToggleButton.Text = "Toggle Aimbot OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        LandingLabel.Text = "Ball Landing: N/A"
    end
end)

RunService.RenderStepped:Connect(function()
    pcall(aimAssist)
end)
