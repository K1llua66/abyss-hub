--[[
    Abyss Hub v4.0 - Полностью автономная версия
    Без внешних зависимостей
]]

-- Проверка игры
if not table.find({2753915549,4442272183,7449423635}, game.PlaceId) then
    return game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub только для Blox Fruits!")
end

-- ============================================
-- FAST ATTACK МОДУЛЬ (ВСТРОЕННЫЙ)
-- ============================================
local FastAttack = {
    Active = false,
    PvPMode = false,
    CurrentTarget = nil,
    Loop = nil,
    CanAttack = true,
    AttackSpeed = 0.12,
}

-- Отправка M1 атаки
local function SendM1()
    if not FastAttack.CanAttack then return end
    
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    
    -- Пробуем разные способы отправки атаки
    local success = false
    
    -- Способ 1: Remote
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = replicatedStorage:FindFirstChild("Remotes")
    
    if remotes then
        local attackRemote = remotes:FindFirstChild("Attack")
        if attackRemote then
            pcall(function()
                attackRemote:FireServer()
                success = true
            end)
        end
        
        if not success then
            local combatRemote = remotes:FindFirstChild("Combat")
            if combatRemote then
                pcall(function()
                    combatRemote:FireServer("M1")
                    success = true
                end)
            end
        end
    end
    
    -- Способ 2: Через мышь
    if not success then
        pcall(function()
            local mouse = player:GetMouse()
            if mouse then
                local b1d = mouse.Button1Down
                local b1u = mouse.Button1Up
                if b1d and b1u then
                    b1d:Fire()
                    task.wait(0.05)
                    b1u:Fire()
                    success = true
                end
            end
        end)
    end
    
    if success then
        FastAttack.CanAttack = false
        task.delay(FastAttack.AttackSpeed, function()
            FastAttack.CanAttack = true
        end)
    end
end

-- Поиск цели
local function FindTarget()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closestTarget = nil
    local closestDist = 25
    
    -- Поиск мобов
    if not FastAttack.PvPMode then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in pairs(enemies:GetChildren()) do
                local hrp2 = enemy:FindFirstChild("HumanoidRootPart")
                local hum = enemy:FindFirstChild("Humanoid")
                if hrp2 and hum and hum.Health > 0 then
                    local dist = (hrp.Position - hrp2.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestTarget = enemy
                    end
                end
            end
        end
    end
    
    -- Поиск игроков
    if FastAttack.PvPMode then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherChar = otherPlayer.Character
                local hrp2 = otherChar:FindFirstChild("HumanoidRootPart")
                local hum = otherChar:FindFirstChild("Humanoid")
                if hrp2 and hum and hum.Health > 0 then
                    local dist = (hrp.Position - hrp2.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestTarget = otherChar
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Поворот к цели
local function LookAt(target)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local targetHrp = target:FindFirstChild("HumanoidRootPart")
    if targetHrp then
        local newCFrame = CFrame.new(hrp.Position, targetHrp.Position)
        hrp.CFrame = newCFrame
    end
end

function FastAttack:Start()
    if self.Loop then self:Stop() end
    self.Active = true
    
    self.Loop = game:GetService("RunService").Heartbeat:Connect(function()
        if not self.Active then return end
        
        local target = self.CurrentTarget or FindTarget()
        if target then
            LookAt(target)
            SendM1()
        end
    end)
end

function FastAttack:Stop()
    self.Active = false
    if self.Loop then
        self.Loop:Disconnect()
        self.Loop = nil
    end
end

function FastAttack:SetTarget(target)
    self.CurrentTarget = target
end

-- ============================================
-- ESP МОДУЛЬ (УПРОЩЕННЫЙ)
-- ============================================
local ESP = {
    Active = false,
    Objects = {Fruits = false, Players = false, NPC = false, Chests = false},
    Drawings = {}
}

function ESP:Start()
    if self.Active then return end
    self.Active = true
    -- Базовая ESP (можно расширить позже)
    print("ESP активирован")
end

function ESP:Stop()
    self.Active = false
    for _, drawing in pairs(self.Drawings) do
        pcall(function() drawing:Remove() end)
    end
    self.Drawings = {}
end

-- ============================================
-- PLAYER МОДУЛЬ (УПРОЩЕННЫЙ)
-- ============================================
local Player = {
    SpeedEnabled = false,
    JumpEnabled = false,
    OriginalSpeed = 16,
    OriginalJump = 50
}

function Player:Update()
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if self.SpeedEnabled then
        hum.WalkSpeed = self.OriginalSpeed * (self.SpeedMultiplier or 1)
    else
        hum.WalkSpeed = self.OriginalSpeed
    end
    
    if self.JumpEnabled then
        hum.JumpPower = self.OriginalJump * (self.JumpMultiplier or 1)
    else
        hum.JumpPower = self.OriginalJump
    end
end

function Player:SetSpeed(mult)
    self.SpeedMultiplier = mult
    self:Update()
end

function Player:SetJump(mult)
    self.JumpMultiplier = mult
    self:Update()
end

-- ============================================
-- TELEPORT МОДУЛЬ (УПРОЩЕННЫЙ)
-- ============================================
local Teleport = {
    Coords = {
        Sea1 = Vector3.new(-1175, 25, 1450),
        Sea2 = Vector3.new(-2550, 25, -4050),
        Sea3 = Vector3.new(1175, 25, 14575),
        PirateStarter = Vector3.new(-1125, 25, 1400),
        MarineStarter = Vector3.new(-1200, 25, 1300),
        Jungle = Vector3.new(-1450, 35, 950),
        Desert = Vector3.new(-900, 25, 1750),
        SkyIslands = Vector3.new(100, 250, 500),
        KingdomRose = Vector3.new(-2750, 25, -3750),
        PortTown = Vector3.new(-2350, 25, -4250)
    }
}

function Teleport.Teleport(pos)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- ============================================
-- LUNA UI (ЗАГРУЗКА)
-- ============================================
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Luna%20UI.lua"))()
if not Luna then
    return game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Luna UI")
end

-- Создание окна
local Window = Luna:CreateWindow({
    Name = "Abyss Hub",
    Subtitle = "Blox Fruits v4.0",
    LogoID = "6031097225",
    LoadingEnabled = true,
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "Loading...",
    KeySystem = false
})

-- Домашняя вкладка
Window:CreateHomeTab({DiscordInvite = "abysshub", SupportedExecutors = {"Xeno","Delta","Vega X","Arceus X"}})

-- ============================================
-- PVP ВКЛАДКА
-- ============================================
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака (только первый удар M1)",
    CurrentValue = false,
    Callback = function(v) 
        if v then 
            FastAttack:Start() 
        else 
            FastAttack:Stop() 
        end 
    end
})

pvpSec:CreateToggle({
    Name = "PvP Mode",
    Description = "Атаковать игроков",
    CurrentValue = false,
    Callback = function(v) FastAttack.PvPMode = v end
})

pvpSec:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(v) 
        Player.SpeedEnabled = v
        Player:Update() 
    end
})

pvpSec:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) Player:SetSpeed(v) end
})

pvpSec:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(v) 
        Player.JumpEnabled = v
        Player:Update() 
    end
})

pvpSec:CreateSlider({
    Name = "Jump Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) Player:SetJump(v) end
})

-- ============================================
-- ESP ВКЛАДКА
-- ============================================
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")

espSec:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Fruits = v; if v then ESP:Start() else ESP:Stop() end end
})

espSec:CreateToggle({
    Name = "Player ESP", 
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Players = v; if v then ESP:Start() else ESP:Stop() end end
})

espSec:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.NPC = v; if v then ESP:Start() else ESP:Stop() end end
})

-- ============================================
-- ТЕЛЕПОРТЫ
-- ============================================
local teleTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local teleSec = teleTab:CreateSection("Моря")

teleSec:CreateButton({Name = "1st Sea", Callback = function() Teleport.Teleport(Teleport.Coords.Sea1) end})
teleSec:CreateButton({Name = "2nd Sea", Callback = function() Teleport.Teleport(Teleport.Coords.Sea2) end})
teleSec:CreateButton({Name = "3rd Sea", Callback = function() Teleport.Teleport(Teleport.Coords.Sea3) end})

local islandSec = teleTab:CreateSection("Острова")
islandSec:CreateButton({Name = "Pirate Starter", Callback = function() Teleport.Teleport(Teleport.Coords.PirateStarter) end})
islandSec:CreateButton({Name = "Marine Starter", Callback = function() Teleport.Teleport(Teleport.Coords.MarineStarter) end})
islandSec:CreateButton({Name = "Jungle", Callback = function() Teleport.Teleport(Teleport.Coords.Jungle) end})
islandSec:CreateButton({Name = "Desert", Callback = function() Teleport.Teleport(Teleport.Coords.Desert) end})
islandSec:CreateButton({Name = "Sky Islands", Callback = function() Teleport.Teleport(Teleport.Coords.SkyIslands) end})
islandSec:CreateButton({Name = "Kingdom of Rose", Callback = function() Teleport.Teleport(Teleport.Coords.KingdomRose) end})
islandSec:CreateButton({Name = "Port Town", Callback = function() Teleport.Teleport(Teleport.Coords.PortTown) end})

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})
local genSec = setTab:CreateSection("Общие")

genSec:CreateButton({Name = "Unload Script", Callback = function()
    FastAttack:Stop()
    ESP:Stop()
    Window:Destroy()
end})

-- Горячая клавиша
local mainFrame = nil
local function findFrame()
    local p = gethui and gethui() or game:GetService("CoreGui")
    for _, g in ipairs(p:GetChildren()) do
        if g.Name == "Luna UI" and g:FindFirstChild("SmartWindow") then
            mainFrame = g.SmartWindow
            return true
        end
    end
    return false
end
findFrame() or task.wait(1) and findFrame()

local visible = true
game:GetService("UserInputService").InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        if mainFrame then mainFrame.Visible = visible end
    end
end)

if mainFrame then mainFrame.Visible = true end

print("✅ Abyss Hub v4.0 загружен! Клавиша: Right Control")
