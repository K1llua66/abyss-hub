-- Abyss Hub v4.0 - Максимально упрощенная версия

-- Отключаем ошибки
local oldPrint = print
print = function() end

-- Проверяем game
if not game then return end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Проверка игры (упрощенная)
local placeId = game.PlaceId
if placeId ~= 2753915549 and placeId ~= 4442272183 and placeId ~= 7449423635 then
    LocalPlayer:Kick("❌ Abyss Hub только для Blox Fruits!")
    return
end

print("✅ Abyss Hub загружается...")

-- ============================================
-- FAST ATTACK (Максимально упрощенный)
-- ============================================
local FastAttackActive = false
local PvPMode = false
local CanAttack = true

local function SendM1()
    if not CanAttack then return end
    
    -- Самый простой способ - через Remote
    local success = false
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    
    if remotes then
        local attack = remotes:FindFirstChild("Attack")
        if attack then
            pcall(function() attack:FireServer() success = true end)
        end
    end
    
    if success then
        CanAttack = false
        task.wait(0.15)
        CanAttack = true
    end
end

local function FindTarget()
    local char = LocalPlayer.Character
    if not char then return nil end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local bestTarget = nil
    local bestDist = 25
    
    -- Поиск мобов
    if not PvPMode then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in pairs(enemies:GetChildren()) do
                local ehrp = enemy:FindFirstChild("HumanoidRootPart")
                local hum = enemy:FindFirstChild("Humanoid")
                if ehrp and hum and hum.Health > 0 then
                    local dist = (hrp.Position - ehrp.Position).Magnitude
                    if dist < bestDist then
                        bestDist = dist
                        bestTarget = enemy
                    end
                end
            end
        end
    end
    
    return bestTarget
end

local function LookAt(target)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local thrp = target:FindFirstChild("HumanoidRootPart")
    if thrp then
        hrp.CFrame = CFrame.new(hrp.Position, thrp.Position)
    end
end

local FastAttackLoop = nil

local function StartFastAttack()
    if FastAttackLoop then return end
    FastAttackActive = true
    FastAttackLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if not FastAttackActive then return end
        local target = FindTarget()
        if target then
            LookAt(target)
            SendM1()
        end
    end)
end

local function StopFastAttack()
    FastAttackActive = false
    if FastAttackLoop then
        FastAttackLoop:Disconnect()
        FastAttackLoop = nil
    end
end

-- ============================================
-- SPEED & JUMP
-- ============================================
local SpeedEnabled = false
local JumpEnabled = false
local SpeedMult = 1
local JumpMult = 1

local function UpdateMovement()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if SpeedEnabled then
        hum.WalkSpeed = 16 * SpeedMult
    else
        hum.WalkSpeed = 16
    end
    
    if JumpEnabled then
        hum.JumpPower = 50 * JumpMult
    else
        hum.JumpPower = 50
    end
end

-- ============================================
-- TELEPORT
-- ============================================
local function Teleport(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

local Coords = {
    Sea1 = Vector3.new(-1175, 25, 1450),
    Sea2 = Vector3.new(-2550, 25, -4050),
    Sea3 = Vector3.new(1175, 25, 14575),
}

-- ============================================
-- LUNA UI (ПРОБУЕМ ЗАГРУЗИТЬ)
-- ============================================
local Luna = nil
local loadSuccess = false

-- Пробуем разные способы загрузки
local url = "https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Luna%20UI.lua"

-- Способ 1: через HttpGet
local success, result = pcall(function()
    return game:HttpGet(url)
end)

if success and result then
    local func, err = loadstring(result)
    if func then
        local status, res = pcall(func)
        if status and res then
            Luna = res
            loadSuccess = true
        end
    end
end

-- Если не загрузился, создаем простой UI
if not loadSuccess then
    -- Создаем простой ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AbyssHub"
    screenGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.1
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "Abyss Hub v4.0"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Parent = frame
    
    -- Fast Attack кнопка
    local faBtn = Instance.new("TextButton")
    faBtn.Size = UDim2.new(0.9, 0, 0, 40)
    faBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
    faBtn.Text = "Fast Attack: OFF"
    faBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    faBtn.Parent = frame
    
    local faActive = false
    faBtn.MouseButton1Click:Connect(function()
        faActive = not faActive
        if faActive then
            faBtn.Text = "Fast Attack: ON"
            faBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            StartFastAttack()
        else
            faBtn.Text = "Fast Attack: OFF"
            faBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            StopFastAttack()
        end
    end)
    
    -- Speed кнопка
    local spBtn = Instance.new("TextButton")
    spBtn.Size = UDim2.new(0.9, 0, 0, 40)
    spBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
    spBtn.Text = "Speed: OFF"
    spBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    spBtn.Parent = frame
    
    spBtn.MouseButton1Click:Connect(function()
        SpeedEnabled = not SpeedEnabled
        if SpeedEnabled then
            spBtn.Text = "Speed: ON"
            spBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            spBtn.Text = "Speed: OFF"
            spBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        UpdateMovement()
    end)
    
    -- Teleport кнопки
    local sea1Btn = Instance.new("TextButton")
    sea1Btn.Size = UDim2.new(0.9, 0, 0, 40)
    sea1Btn.Position = UDim2.new(0.05, 0, 0.45, 0)
    sea1Btn.Text = "1st Sea"
    sea1Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sea1Btn.Parent = frame
    sea1Btn.MouseButton1Click:Connect(function() Teleport(Coords.Sea1) end)
    
    local sea2Btn = Instance.new("TextButton")
    sea2Btn.Size = UDim2.new(0.9, 0, 0, 40)
    sea2Btn.Position = UDim2.new(0.05, 0, 0.6, 0)
    sea2Btn.Text = "2nd Sea"
    sea2Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sea2Btn.Parent = frame
    sea2Btn.MouseButton1Click:Connect(function() Teleport(Coords.Sea2) end)
    
    local sea3Btn = Instance.new("TextButton")
    sea3Btn.Size = UDim2.new(0.9, 0, 0, 40)
    sea3Btn.Position = UDim2.new(0.05, 0, 0.75, 0)
    sea3Btn.Text = "3rd Sea"
    sea3Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sea3Btn.Parent = frame
    sea3Btn.MouseButton1Click:Connect(function() Teleport(Coords.Sea3) end)
    
    -- Перетаскивание
    local dragging = false
    local dragStart
    local startPos
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    print("✅ Abyss Hub загружен (упрощенный интерфейс)")
else
    -- Если Luna UI загрузился, создаем нормальное окно
    local Window = Luna:CreateWindow({
        Name = "Abyss Hub",
        Subtitle = "Blox Fruits v4.0",
        KeySystem = false
    })
    
    Window:CreateHomeTab({})
    
    local pvpTab = Window:CreateTab({Name = "PvP"})
    local pvpSec = pvpTab:CreateSection("Functions")
    
    pvpSec:CreateToggle({
        Name = "Fast Attack",
        CurrentValue = false,
        Callback = function(v)
            if v then StartFastAttack() else StopFastAttack() end
        end
    })
    
    pvpSec:CreateToggle({
        Name = "PvP Mode",
        CurrentValue = false,
        Callback = function(v) PvPMode = v end
    })
    
    pvpSec:CreateToggle({
        Name = "Speed Boost",
        CurrentValue = false,
        Callback = function(v) SpeedEnabled = v; UpdateMovement() end
    })
    
    local teleTab = Window:CreateTab({Name = "Teleports"})
    local teleSec = teleTab:CreateSection("Seas")
    
    teleSec:CreateButton({Name = "1st Sea", Callback = function() Teleport(Coords.Sea1) end})
    teleSec:CreateButton({Name = "2nd Sea", Callback = function() Teleport(Coords.Sea2) end})
    teleSec:CreateButton({Name = "3rd Sea", Callback = function() Teleport(Coords.Sea3) end})
    
    print("✅ Abyss Hub v4.0 загружен!")
end

-- Восстанавливаем print
print = oldPrint
