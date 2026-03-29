--[[
    Abyss Hub v4.0
    Модульная версия с Luna UI
    Добавлено: Auto Farm, Auto Boss, Silent Aim, Config System
]]

-- Проверка игры
if not table.find({2753915549,4442272183,7449423635}, game.PlaceId) then
    return game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub только для Blox Fruits!")
end

-- Загрузка модулей
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/ESP.lua"))()
local FastAttack = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/FastAttack.lua"))()
if not FastAttack then 
    -- Фолбэк если модуль не загрузился
    FastAttack = { Start = function() end, Stop = function() end }
end
local Player = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/Player.lua"))()
local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/Teleport.lua"))()

-- Загрузка Luna UI
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Luna%20UI.lua"))()
if not Luna then return game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Luna UI") end

-- ============================================
-- НОВЫЕ МОДУЛИ (ВСТРОЕННЫЕ)
-- ============================================

-- UTILS МОДУЛЬ
local Utils = {}
Utils.Players = game:GetService("Players")
Utils.RunService = game:GetService("RunService")
Utils.HttpService = game:GetService("HttpService")

function Utils.GetClosestMob(character)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest, closestDist = nil, math.huge
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = v
            end
        end
    end
    return closest, closestDist
end

function Utils.GetClosestPlayer(character)
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest, closestDist = nil, math.huge
    for _, v in pairs(Utils.Players:GetPlayers()) do
        if v ~= Utils.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closest = v.Character
            end
        end
    end
    return closest, closestDist
end

function Utils.GetQuestNPC()
    local localPlayer = Utils.Players.LocalPlayer
    local character = localPlayer.Character
    if not character then return nil end
    
    for _, v in pairs(workspace.NPCs:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Head") then
            local head = v.Head
            local billboard = head:FindFirstChild("BillboardGui")
            if billboard and billboard:FindFirstChild("Quest") then
                return v
            end
        end
    end
    return nil
end

function Utils.IsInRange(pos1, pos2, range)
    return (pos1 - pos2).Magnitude <= range
end

-- AUTO FARM МОДУЛЬ
local AutoFarm = {
    Active = false,
    Mode = "Level",
    Weapon = "Melee",
    CurrentQuest = nil,
    CurrentTarget = nil,
    Loop = nil,
    QuestCompleted = false
}

function AutoFarm:Start()
    if self.Loop then return end
    self.Active = true
    self.Loop = Utils.RunService.RenderStepped:Connect(function()
        if not self.Active then return end
        
        if self.Mode == "Level" then
            self:LevelMode()
        elseif self.Mode == "Nearest" then
            self:NearestMode()
        end
    end)
end

function AutoFarm:Stop()
    self.Active = false
    if self.Loop then
        self.Loop:Disconnect()
        self.Loop = nil
    end
    self.CurrentTarget = nil
end

function AutoFarm:LevelMode()
    local localPlayer = Utils.Players.LocalPlayer
    local character = localPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- Поиск ближайшего моба
    local target, dist = Utils.GetClosestMob(character)
    
    if target then
        -- Атакуем моба
        if dist <= 15 then
            FastAttack:SetTarget(target)
        else
            -- Телепорт к мобу
            Teleport.Teleport(target.HumanoidRootPart.Position)
        end
    else
        -- Нет мобов - ищем квест
        local questNPC = Utils.GetQuestNPC()
        if questNPC then
            local npcDist = (hrp.Position - questNPC.HumanoidRootPart.Position).Magnitude
            if npcDist <= 10 then
                -- Взятие/сдача квеста
                local args = {
                    [1] = "RequestQuest",
                    [2] = questNPC:FindFirstChild("NPCType") and questNPC.NPCType.Value or "Unknown"
                }
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                task.wait(0.5)
            else
                Teleport.Teleport(questNPC.HumanoidRootPart.Position)
            end
        end
    end
end

function AutoFarm:NearestMode()
    local character = Utils.Players.LocalPlayer.Character
    if not character then return end
    
    local target, dist = Utils.GetClosestMob(character)
    if target and dist <= 15 then
        FastAttack:SetTarget(target)
    elseif target then
        Teleport.Teleport(target.HumanoidRootPart.Position)
    end
end

-- AUTO BOSS МОДУЛЬ
local AutoBoss = {
    Active = false,
    SelectedBoss = "Diamond",
    Loop = nil,
    Bosses = {
        Diamond = {Name = "Diamond", Pos = Vector3.new(-4455, 45, 795), Sea = 2},
        ThunderGod = {Name = "Thunder God", Pos = Vector3.new(240, 350, 4200), Sea = 2},
        ViceAdmiral = {Name = "Vice Admiral", Pos = Vector3.new(2850, 25, 725), Sea = 3},
        CakeQueen = {Name = "Cake Queen", Pos = Vector3.new(-1550, 245, 425), Sea = 3},
        RipIndra = {Name = "Rip Indra", Pos = Vector3.new(-1075, 25, 5050), Sea = 3}
    }
}

function AutoBoss:Start()
    if self.Loop then return end
    self.Active = true
    self.Loop = Utils.RunService.RenderStepped:Connect(function()
        if not self.Active then return end
        
        local boss = self.Bosses[self.SelectedBoss]
        if not boss then return end
        
        local character = Utils.Players.LocalPlayer.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local bossChar = self:FindBoss(boss.Name)
        if bossChar then
            local dist = (hrp.Position - bossChar.HumanoidRootPart.Position).Magnitude
            if dist <= 20 then
                FastAttack:SetTarget(bossChar)
            else
                Teleport.Teleport(bossChar.HumanoidRootPart.Position)
            end
        else
            -- Телепорт на спавн босса
            Teleport.Teleport(boss.Pos)
        end
    end)
end

function AutoBoss:Stop()
    self.Active = false
    if self.Loop then
        self.Loop:Disconnect()
        self.Loop = nil
    end
end

function AutoBoss:FindBoss(bossName)
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name:find(bossName) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    return nil
end

-- SILENT AIM МОДУЛЬ
local SilentAim = {
    Active = false,
    TargetMode = "Closest",
    FOV = 90,
    MaxDistance = 300,
    FOVCircle = nil,
    CurrentTarget = nil
}

function SilentAim:Start()
    self.Active = true
    self:CreateFOVCircle()
    self:StartAiming()
end

function SilentAim:Stop()
    self.Active = false
    if self.FOVCircle then
        self.FOVCircle:Destroy()
        self.FOVCircle = nil
    end
end

function SilentAim:CreateFOVCircle()
    local player = Utils.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    self.FOVCircle = Drawing.new("Circle")
    self.FOVCircle.Visible = true
    self.FOVCircle.Radius = self.FOV
    self.FOVCircle.Thickness = 2
    self.FOVCircle.Color = Color3.fromRGB(255, 0, 0)
    self.FOVCircle.Filled = false
    self.FOVCircle.NumSides = 60
    self.FOVCircle.Position = Vector2.new(mouse.X, mouse.Y)
    
    Utils.RunService.RenderStepped:Connect(function()
        if self.FOVCircle then
            self.FOVCircle.Position = Vector2.new(mouse.X, mouse.Y)
        end
    end)
end

function SilentAim:StartAiming()
    Utils.RunService.RenderStepped:Connect(function()
        if not self.Active then return end
        
        local character = Utils.Players.LocalPlayer.Character
        if not character then return end
        
        local target = self:SelectTarget()
        if target then
            self:SilentAimAt(target)
        end
    end)
end

function SilentAim:SelectTarget()
    local character = Utils.Players.LocalPlayer.Character
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local targets = {}
    
    -- Сбор всех возможных целей (мобы + игроки)
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
            if dist <= self.MaxDistance then
                table.insert(targets, {Char = v, Dist = dist, Health = v.Humanoid.Health})
            end
        end
    end
    
    if #targets == 0 then return nil end
    
    -- Выбор цели по режиму
    if self.TargetMode == "Closest" then
        table.sort(targets, function(a, b) return a.Dist < b.Dist end)
    elseif self.TargetMode == "Farthest" then
        table.sort(targets, function(a, b) return a.Dist > b.Dist end)
    elseif self.TargetMode == "Weakest" then
        table.sort(targets, function(a, b) return a.Health < b.Health end)
    elseif self.TargetMode == "Strongest" then
        table.sort(targets, function(a, b) return a.Health > b.Health end)
    end
    
    return targets[1] and targets[1].Char
end

function SilentAim:SilentAimAt(target)
    local player = Utils.Players.LocalPlayer
    local mouse = player:GetMouse()
    
    if target and target:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.HumanoidRootPart.Position
        local screenPos, onScreen = game:GetService("Camera"):WorldToScreenPoint(targetPos)
        
        if onScreen then
            local mousePos = Vector2.new(mouse.X, mouse.Y)
            local targetScreen = Vector2.new(screenPos.X, screenPos.Y)
            local dist = (mousePos - targetScreen).Magnitude
            
            if dist <= self.FOV then
                -- Silent aim (не двигаем камеру, просто меняем цель)
                FastAttack:SetTarget(target)
            end
        end
    end
end

-- CONFIG МОДУЛЬ
local Config = {
    SavePath = "AbyssHub_Config.json",
    Settings = {}
}

function Config:Load()
    local success, data = pcall(function()
        return readfile(self.SavePath)
    end)
    
    if success and data then
        self.Settings = Utils.HttpService:JSONDecode(data)
        self:Apply()
        print("✅ Конфигурация загружена")
    else
        print("⚠️ Конфигурация не найдена, создана новая")
        self:Save()
    end
end

function Config:Save()
    local data = Utils.HttpService:JSONEncode(self.Settings)
    pcall(function()
        writefile(self.SavePath, data)
        print("✅ Конфигурация сохранена")
    end)
end

function Config:Apply()
    -- Применяем сохраненные настройки (будет реализовано позже)
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

-- Отключение размытия
_G.BlurModule = function() end
for _,e in ipairs(game:GetService("Lighting"):GetChildren()) do
    if e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then e:Destroy() end
end

-- Домашняя вкладка
Window:CreateHomeTab({DiscordInvite = "abysshub", SupportedExecutors = {"Xeno","Delta","Vega X","Arceus X"}})

-- ============================================
-- AUTO FARM ВКЛАДКА
-- ============================================
local farmTab = Window:CreateTab({Name = "Auto Farm", Icon = "grass", ImageSource = "Material"})
local farmSec = farmTab:CreateSection("Настройки фермы")

farmSec:CreateToggle({
    Name = "Auto Farm",
    Description = "Автоматическая ферма мобов",
    CurrentValue = false,
    Callback = function(v) if v then AutoFarm:Start() else AutoFarm:Stop() end end
})

farmSec:CreateDropdown({
    Name = "Режим",
    Description = "Level - квесты | Nearest - ближайшие мобы",
    Options = {"Level", "Nearest"},
    CurrentOption = "Level",
    Callback = function(v) AutoFarm.Mode = v end
})

farmSec:CreateDropdown({
    Name = "Оружие",
    Description = "Тип атаки",
    Options = {"Melee", "Sword", "Fruit"},
    CurrentOption = "Melee",
    Callback = function(v) AutoFarm.Weapon = v end
})

-- ============================================
-- AUTO BOSS ВКЛАДКА
-- ============================================
local bossTab = Window:CreateTab({Name = "Auto Boss", Icon = "bolt", ImageSource = "Material"})
local bossSec = bossTab:CreateSection("Фарм боссов")

bossSec:CreateToggle({
    Name = "Auto Boss",
    Description = "Автоматический фарм выбранного босса",
    CurrentValue = false,
    Callback = function(v) if v then AutoBoss:Start() else AutoBoss:Stop() end end
})

bossSec:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral", "Cake Queen", "Rip Indra"},
    CurrentOption = "Diamond",
    Callback = function(v) AutoBoss.SelectedBoss = v end
})

-- ============================================
-- SILENT AIM ВКЛАДКА
-- ============================================
local silentTab = Window:CreateTab({Name = "Silent Aim", Icon = "my_location", ImageSource = "Material"})
local silentSec = silentTab:CreateSection("Настройки Silent Aim")

silentSec:CreateToggle({
    Name = "Silent Aim",
    Description = "Автоматическое наведение на цель",
    CurrentValue = false,
    Callback = function(v) if v then SilentAim:Start() else SilentAim:Stop() end end
})

silentSec:CreateDropdown({
    Name = "Режим выбора цели",
    Options = {"Closest", "Farthest", "Weakest", "Strongest"},
    CurrentOption = "Closest",
    Callback = function(v) SilentAim.TargetMode = v end
})

silentSec:CreateSlider({
    Name = "FOV (градусы)",
    Range = {30, 360},
    Increment = 10,
    CurrentValue = 90,
    Callback = function(v) 
        SilentAim.FOV = v
        if SilentAim.FOVCircle then
            SilentAim.FOVCircle.Radius = v
        end
    end
})

silentSec:CreateSlider({
    Name = "Макс. дистанция",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 300,
    Callback = function(v) SilentAim.MaxDistance = v end
})

-- ============================================
-- PVP ВКЛАДКА
-- ============================================
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака (только первая M1)",
    CurrentValue = true,
    Callback = function(v) if v then FastAttack:Start() else FastAttack:Stop() end end
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
    Callback = function(v) Player.SpeedEnabled = v; Player:Update() end
})

pvpSec:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1,10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) Player:SetSpeed(v) end
})

pvpSec:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(v) Player.JumpEnabled = v; Player:Update() end
})

pvpSec:CreateSlider({
    Name = "Jump Multiplier",
    Range = {1,10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) Player:SetJump(v) end
})

-- ============================================
-- ESP ВКЛАДКА
-- ============================================
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")

local function updateESP()
    local any = ESP.Objects.Fruits or ESP.Objects.Players or ESP.Objects.NPC or ESP.Objects.Chests
    if any then ESP:Start() else ESP:Stop() end
end

espSec:CreateToggle({
    Name = "Fruit ESP",
    Description = "Показывает Devil Fruits",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Fruits = v; updateESP() end
})

espSec:CreateToggle({
    Name = "Player ESP",
    Description = "Показывает игроков",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Players = v; updateESP() end
})

espSec:CreateToggle({
    Name = "NPC ESP",
    Description = "Показывает NPC и мобов",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.NPC = v; updateESP() end
})

espSec:CreateToggle({
    Name = "Chest ESP",
    Description = "Показывает сундуки",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Chests = v; updateESP() end
})

-- ============================================
-- ТЕЛЕПОРТЫ ВКЛАДКА
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
-- КОНФИГУРАЦИИ ВКЛАДКА
-- ============================================
local configTab = Window:CreateTab({Name = "Конфиги", Icon = "save", ImageSource = "Material"})
local configSec = configTab:CreateSection("Сохранение/Загрузка")

configSec:CreateButton({Name = "💾 Сохранить конфигурацию", Callback = function()
    Config.Settings = {
        AutoFarm = {Mode = AutoFarm.Mode, Weapon = AutoFarm.Weapon},
        AutoBoss = {SelectedBoss = AutoBoss.SelectedBoss},
        SilentAim = {TargetMode = SilentAim.TargetMode, FOV = SilentAim.FOV, MaxDistance = SilentAim.MaxDistance}
    }
    Config:Save()
end})

configSec:CreateButton({Name = "📂 Загрузить конфигурацию", Callback = function()
    Config:Load()
end})

-- ============================================
-- НАСТРОЙКИ ВКЛАДКА
-- ============================================
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})
local genSec = setTab:CreateSection("Общие")

genSec:CreateButton({Name = "Unload Script", Callback = function()
    FastAttack:Stop()
    ESP:Stop()
    AutoFarm:Stop()
    AutoBoss:Stop()
    SilentAim:Stop()
    Window:Destroy()
end})

-- Горячая клавиша (Right Control)
local mainFrame = nil
local function findFrame()
    local p = gethui and gethui() or game:GetService("CoreGui")
    for _,g in ipairs(p:GetChildren()) do
        if g.Name == "Luna UI" and g:FindFirstChild("SmartWindow") then
            mainFrame = g.SmartWindow
            return true
        end
    end
    return false
end
findFrame() or task.wait(1) and findFrame()
pcall(function() Window.Bind = Enum.KeyCode.Unknown end)

local visible = true
game:GetService("UserInputService").InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        if mainFrame then mainFrame.Visible = visible end
    end
end)

if mainFrame then mainFrame.Visible = true end

-- Запуск Fast Attack по умолчанию
FastAttack:Start()

print("🔥 Abyss Hub v4.0 загружен! Клавиша: Right Control")
print("📌 Новые функции: Auto Farm | Auto Boss | Silent Aim | Конфигурации")
