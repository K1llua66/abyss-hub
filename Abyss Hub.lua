-- Abyss Hub v4.0 - С Void UI Library

-- Проверка игры
local placeId = game.PlaceId
if placeId ~= 2753915549 and placeId ~= 4442272183 and placeId ~= 7449423635 then
    game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub только для Blox Fruits!")
    return
end

-- Загрузка Void UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/VoidUI.lua"))()
if not Library then
    return game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить библиотеку")
end

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Состояния
local state = {
    -- Auto Farm
    autoFarm = false,
    farmMode = "Level",
    weaponType = "Melee",
    
    -- Auto Boss
    autoBoss = false,
    selectedBoss = "Diamond",
    
    -- Silent Aim
    silentAim = false,
    aimMode = "Closest",
    fov = 90,
    maxDistance = 300,
    
    -- Fast Attack
    fastAttack = false,
    pvpMode = false,
    
    -- Movement
    speedEnabled = false,
    speedValue = 16,
    jumpEnabled = false,
    jumpValue = 50,
    
    -- ESP
    espFruits = false,
    espPlayers = false,
    espNPC = false,
    espChests = false,
}

-- Текущая цель
local currentTarget = nil
local canAttack = true

-- ============================================
-- БАЗОВЫЕ ФУНКЦИИ
-- ============================================

-- Отправка M1 атаки
local function SendM1()
    if not canAttack then return end
    if not state.fastAttack and not state.autoFarm and not state.autoBoss then return end
    
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        local attack = remotes:FindFirstChild("Attack")
        if attack then
            pcall(function() 
                attack:FireServer() 
                canAttack = false
                task.wait(0.12)
                canAttack = true
            end)
        end
    end
end

-- Поиск ближайшего моба
local function GetClosestMob()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 50
    
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local ehrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            if ehrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - ehrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = enemy
                end
            end
        end
    end
    
    return closest, closestDist
end

-- Поиск ближайшего игрока
local function GetClosestPlayer()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 50
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local pchar = player.Character
            local phrp = pchar:FindFirstChild("HumanoidRootPart")
            local phum = pchar:FindFirstChild("Humanoid")
            if phrp and phum and phum.Health > 0 then
                local dist = (hrp.Position - phrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = pchar
                end
            end
        end
    end
    
    return closest, closestDist
end

-- Поворот к цели
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

-- Телепорт
local function Teleport(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Обновление скорости/прыжка
local function UpdateMovement()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if state.speedEnabled then
        hum.WalkSpeed = state.speedValue
    else
        hum.WalkSpeed = 16
    end
    
    if state.jumpEnabled then
        hum.JumpPower = state.jumpValue
    else
        hum.JumpPower = 50
    end
end

-- ============================================
-- AUTO FARM ЛОГИКА
-- ============================================
local farmLoop = nil

local function StartAutoFarm()
    if farmLoop then return end
    
    farmLoop = RunService.Heartbeat:Connect(function()
        if not state.autoFarm then return end
        
        if state.farmMode == "Nearest" then
            local target = GetClosestMob()
            if target then
                LookAt(target)
                SendM1()
            end
        elseif state.farmMode == "Level" then
            local target = GetClosestMob()
            if target then
                LookAt(target)
                SendM1()
            end
        end
    end)
end

local function StopAutoFarm()
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
    end
end

-- ============================================
-- AUTO BOSS ЛОГИКА
-- ============================================
local bossPositions = {
    Diamond = Vector3.new(-4455, 45, 795),
    ThunderGod = Vector3.new(240, 350, 4200),
    ViceAdmiral = Vector3.new(2850, 25, 725),
    CakeQueen = Vector3.new(-1550, 245, 425),
    RipIndra = Vector3.new(-1075, 25, 5050),
}

local bossLoop = nil

local function StartAutoBoss()
    if bossLoop then return end
    
    bossLoop = RunService.Heartbeat:Connect(function()
        if not state.autoBoss then return end
        
        local bossPos = bossPositions[state.selectedBoss]
        if bossPos then
            local enemies = workspace:FindFirstChild("Enemies")
            local bossChar = nil
            
            if enemies then
                for _, enemy in pairs(enemies:GetChildren()) do
                    if enemy.Name:find(state.selectedBoss) then
                        bossChar = enemy
                        break
                    end
                end
            end
            
            if bossChar then
                LookAt(bossChar)
                SendM1()
            else
                Teleport(bossPos)
            end
        end
    end)
end

local function StopAutoBoss()
    if bossLoop then
        bossLoop:Disconnect()
        bossLoop = nil
    end
end

-- ============================================
-- FAST ATTACK ЛОГИКА
-- ============================================
local fastAttackLoop = nil

local function StartFastAttack()
    if fastAttackLoop then return end
    
    fastAttackLoop = RunService.Heartbeat:Connect(function()
        if not state.fastAttack then return end
        
        local target = nil
        if state.pvpMode then
            target = GetClosestPlayer()
        else
            target = GetClosestMob()
        end
        
        if target then
            LookAt(target)
            SendM1()
        end
    end)
end

local function StopFastAttack()
    if fastAttackLoop then
        fastAttackLoop:Disconnect()
        fastAttackLoop = nil
    end
end

-- ============================================
-- SILENT AIM ЛОГИКА
-- ============================================
local silentAimLoop = nil

local function GetTargetsByMode()
    local char = LocalPlayer.Character
    if not char then return {} end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    
    local targets = {}
    local enemies = workspace:FindFirstChild("Enemies")
    
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local ehrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            if ehrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - ehrp.Position).Magnitude
                if dist <= state.maxDistance then
                    table.insert(targets, {
                        obj = enemy,
                        dist = dist,
                        health = hum.Health
                    })
                end
            end
        end
    end
    
    if state.aimMode == "Closest" then
        table.sort(targets, function(a, b) return a.dist < b.dist end)
    elseif state.aimMode == "Farthest" then
        table.sort(targets, function(a, b) return a.dist > b.dist end)
    elseif state.aimMode == "Weakest" then
        table.sort(targets, function(a, b) return a.health < b.health end)
    elseif state.aimMode == "Strongest" then
        table.sort(targets, function(a, b) return a.health > b.health end)
    end
    
    return targets
end

local function StartSilentAim()
    if silentAimLoop then return end
    
    silentAimLoop = RunService.Heartbeat:Connect(function()
        if not state.silentAim then return end
        
        local targets = GetTargetsByMode()
        if #targets > 0 then
            local target = targets[1].obj
            LookAt(target)
        end
    end)
end

local function StopSilentAim()
    if silentAimLoop then
        silentAimLoop:Disconnect()
        silentAimLoop = nil
    end
end

-- ============================================
-- СОЗДАНИЕ UI
-- ============================================

-- Создаем окно
local Window = Library:Load({
    name = "Abyss Hub",
    sizex = 500,
    sizey = 550,
    theme = "Midnight",
    folder = "AbyssHub",
    extension = "json"
})

-- Вкладка: Auto Farm
local farmTab = Window:Tab("Auto Farm")
local farmSection = farmTab:Section({name = "Настройки фермы", side = "left"})

local farmToggle = farmSection:Toggle({
    name = "Auto Farm",
    default = false,
    flag = "autoFarm",
    callback = function(v)
        state.autoFarm = v
        if v then StartAutoFarm() else StopAutoFarm() end
    end
})

farmSection:Dropdown({
    name = "Режим",
    content = {"Level", "Nearest"},
    default = "Level",
    flag = "farmMode",
    callback = function(v)
        state.farmMode = v
    end
})

farmSection:Dropdown({
    name = "Оружие",
    content = {"Melee", "Sword", "Fruit"},
    default = "Melee",
    flag = "weaponType",
    callback = function(v)
        state.weaponType = v
    end
})

-- Вкладка: Auto Boss
local bossTab = Window:Tab("Auto Boss")
local bossSection = bossTab:Section({name = "Фарм боссов", side = "left"})

local bossToggle = bossSection:Toggle({
    name = "Auto Boss",
    default = false,
    flag = "autoBoss",
    callback = function(v)
        state.autoBoss = v
        if v then StartAutoBoss() else StopAutoBoss() end
    end
})

bossSection:Dropdown({
    name = "Выбор босса",
    content = {"Diamond", "ThunderGod", "ViceAdmiral", "CakeQueen", "RipIndra"},
    default = "Diamond",
    flag = "selectedBoss",
    callback = function(v)
        state.selectedBoss = v
    end
})

-- Вкладка: Silent Aim
local silentTab = Window:Tab("Silent Aim")
local silentSection = silentTab:Section({name = "Настройки Silent Aim", side = "left"})

local silentToggle = silentSection:Toggle({
    name = "Silent Aim",
    default = false,
    flag = "silentAim",
    callback = function(v)
        state.silentAim = v
        if v then StartSilentAim() else StopSilentAim() end
    end
})

silentSection:Dropdown({
    name = "Режим цели",
    content = {"Closest", "Farthest", "Weakest", "Strongest"},
    default = "Closest",
    flag = "aimMode",
    callback = function(v)
        state.aimMode = v
    end
})

silentSection:Slider({
    name = "FOV (градусы)",
    min = 30,
    max = 360,
    default = 90,
    flag = "fov",
    callback = function(v)
        state.fov = v
    end
})

silentSection:Slider({
    name = "Макс. дистанция",
    min = 50,
    max = 500,
    default = 300,
    flag = "maxDistance",
    callback = function(v)
        state.maxDistance = v
    end
})

-- Вкладка: PvP
local pvpTab = Window:Tab("PvP")
local pvpSection = pvpTab:Section({name = "PvP Functions", side = "left"})

local fastAttackToggle = pvpSection:Toggle({
    name = "Fast Attack",
    default = false,
    flag = "fastAttack",
    callback = function(v)
        state.fastAttack = v
        if v then StartFastAttack() else StopFastAttack() end
    end
})

pvpSection:Toggle({
    name = "PvP Mode",
    default = false,
    flag = "pvpMode",
    callback = function(v)
        state.pvpMode = v
    end
})

pvpSection:Toggle({
    name = "Speed Boost",
    default = false,
    flag = "speedEnabled",
    callback = function(v)
        state.speedEnabled = v
        UpdateMovement()
    end
})

pvpSection:Slider({
    name = "Speed Value",
    min = 16,
    max = 100,
    default = 16,
    flag = "speedValue",
    callback = function(v)
        state.speedValue = v
        UpdateMovement()
    end
})

pvpSection:Toggle({
    name = "Jump Boost",
    default = false,
    flag = "jumpEnabled",
    callback = function(v)
        state.jumpEnabled = v
        UpdateMovement()
    end
})

pvpSection:Slider({
    name = "Jump Value",
    min = 50,
    max = 200,
    default = 50,
    flag = "jumpValue",
    callback = function(v)
        state.jumpValue = v
        UpdateMovement()
    end
})

-- Вкладка: ESP
local espTab = Window:Tab("ESP")
local espSection = espTab:Section({name = "ESP Functions", side = "left"})

espSection:Toggle({
    name = "Fruit ESP",
    default = false,
    flag = "espFruits",
    callback = function(v)
        state.espFruits = v
    end
})

espSection:Toggle({
    name = "Player ESP",
    default = false,
    flag = "espPlayers",
    callback = function(v)
        state.espPlayers = v
    end
})

espSection:Toggle({
    name = "NPC ESP",
    default = false,
    flag = "espNPC",
    callback = function(v)
        state.espNPC = v
    end
})

espSection:Toggle({
    name = "Chest ESP",
    default = false,
    flag = "espChests",
    callback = function(v)
        state.espChests = v
    end
})

-- Вкладка: Телепорты
local teleTab = Window:Tab("Телепорты")

local seaSection = teleTab:Section({name = "Моря", side = "left"})
seaSection:Button({name = "🌊 1st Sea", callback = function() Teleport(Vector3.new(-1175, 25, 1450)) end})
seaSection:Button({name = "🌊 2nd Sea", callback = function() Teleport(Vector3.new(-2550, 25, -4050)) end})
seaSection:Button({name = "🌊 3rd Sea", callback = function() Teleport(Vector3.new(1175, 25, 14575)) end})

local islandSection = teleTab:Section({name = "Острова", side = "right"})
islandSection:Button({name = "🏝️ Pirate Starter", callback = function() Teleport(Vector3.new(-1125, 25, 1400)) end})
islandSection:Button({name = "🏝️ Marine Starter", callback = function() Teleport(Vector3.new(-1200, 25, 1300)) end})
islandSection:Button({name = "🏝️ Jungle", callback = function() Teleport(Vector3.new(-1450, 35, 950)) end})
islandSection:Button({name = "🏝️ Desert", callback = function() Teleport(Vector3.new(-900, 25, 1750)) end})
islandSection:Button({name = "🏝️ Sky Islands", callback = function() Teleport(Vector3.new(100, 250, 500)) end})
islandSection:Button({name = "🏝️ Kingdom of Rose", callback = function() Teleport(Vector3.new(-2750, 25, -3750)) end})
islandSection:Button({name = "🏝️ Port Town", callback = function() Teleport(Vector3.new(-2350, 25, -4250)) end})

-- Вкладка: Конфигурации
local configTab = Window:Tab("Конфиги")
local configSection = configTab:Section({name = "Сохранение/Загрузка", side = "left"})

configSection:Button({
    name = "💾 Сохранить конфигурацию",
    callback = function()
        Library:SaveConfig("config", false)
    end
})

configSection:Button({
    name = "📂 Загрузить конфигурацию",
    callback = function()
        Library:LoadConfig("config", false)
    end
})

-- Вкладка: Настройки
local settingsTab = Window:Tab("Настройки")
local settingsSection = settingsTab:Section({name = "Общие", side = "left"})

settingsSection:Button({
    name = "❌ Выгрузить скрипт",
    callback = function()
        StopAutoFarm()
        StopAutoBoss()
        StopFastAttack()
        StopSilentAim()
        Library:Unload()
    end
})

print("✅ Abyss Hub v4.0 успешно загружен!")
print("📌 Используйте Right Shift для открытия/закрытия меню")
