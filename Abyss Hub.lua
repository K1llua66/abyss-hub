--[[
    Abyss Hub v2.1
    Полная версия
]]

-- Проверка игры
local gameId = game.PlaceId
local validIds = {2753915549, 4442272183, 7449423635}
local isValid = false
for _, id in ipairs(validIds) do
    if gameId == id then isValid = true break end
end
if not isValid then
    game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub работает только в Blox Fruits!")
    return
end

-- Загрузка Luna UI
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Luna%20UI.lua"))()
if not Luna then
    game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Luna UI")
    return
end

-- Создание окна
local Window = Luna:CreateWindow({
    Name = "Abyss Hub",
    Subtitle = "Blox Fruits",
    LogoID = "6031097225",
    LoadingEnabled = true,
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "Loading...",
    KeySystem = false
})

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VU = syn and syn.virtual_user or (getrenv and getrenv().virtual_user)

local char, root, hum
local function updateChar()
    char = LP.Character
    if char then
        root = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChild("Humanoid")
    end
end
LP.CharacterAdded:Connect(updateChar)
updateChar()

-- Состояние
local state = {
    auto_farm_level = false,
    auto_farm_nearby = false,
    farm_weapon = "Меч",
    auto_farm_boss = false,
    selected_boss = "Diamond",
    boss_weapon = "Меч",
    boss_fast_attack = true,
    boss_move = "Телепорт",
    auto_mastery = false,
    mastery_type = "Меч",
    skills = {Z = true, X = true, C = false, V = false, F = false},
    auto_fruit_spawn = false,
    auto_fruit_dealer = false,
    auto_store_fruit = false,
    auto_chest = false,
    chest_mode = "Teleport Farm",
    auto_sea_beast = false,
    auto_elite = false,
    auto_observation = false,
    auto_factory = false,
    auto_mirage = false,
    auto_kitsune_collect = false,
    auto_kitsune_trade = false,
    kitsune_amount = 10,
    fast_attack = true,
    anti_stun = false,
    infinite_energy = false,
    speed_enabled = false,
    speed = 1,
    jump_enabled = false,
    jump = 1,
    dash_length = 0,
    infinite_air_jumps = false,
    silent_aim = false,
    silent_mode = "FOV",
    silent_fov = 90,
    silent_distance = 200,
    fruit_esp = false,
    player_esp = false,
    chest_esp = false,
    island_esp = false,
    fruit_filter = "Все",
    auto_raid = false,
    raid_auto_start = false,
    raid_type = "Buddha",
    raid_auto_buy = false,
    raid_auto_fruit = false,
    raid_max_price = 500000,
    kill_aura_raid = false,
    pvp_mode = false
}

-- ============================================
-- ОТКЛЮЧЕНИЕ РАЗМЫТИЯ
-- ============================================
local function killBlur()
    for _, e in ipairs(game:GetService("Lighting"):GetChildren()) do
        if e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then
            e:Destroy()
        end
    end
    local p = gethui and gethui() or game:GetService("CoreGui")
    for _, g in ipairs(p:GetDescendants()) do
        if g:IsA("DepthOfFieldEffect") or g:IsA("BlurEffect") then
            g:Destroy()
        end
    end
end
_G.BlurModule = function() end
killBlur()

-- ============================================
-- СКОРОСТЬ И ПРЫЖОК (исправлено)
-- ============================================
local function updateSpeed()
    if hum then
        if state.speed_enabled then
            hum.WalkSpeed = 16 * state.speed
            print("[Speed] Установлена:", hum.WalkSpeed)
        else
            hum.WalkSpeed = 16
        end
    end
end

local function updateJump()
    if hum then
        if state.jump_enabled then
            hum.JumpPower = 50 * state.jump
        else
            hum.JumpPower = 50
        end
    end
end

-- Постоянное обновление
RS.Heartbeat:Connect(function()
    updateChar()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- FAST ATTACK (быстрый)
-- ============================================
local attackRunning = false
local lastAttack = 0
local attackCooldown = 0.12

local function getNearestTarget()
    if not root then return nil end
    local nearest, nearestDist = nil, 22
    local pos = root.Position
    
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, npc in ipairs(enemies:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                if npcRoot then
                    local dist = (pos - npcRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = npc
                    end
                end
            end
        end
    end
    
    if state.pvp_mode then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local charRoot = char:FindFirstChild("HumanoidRootPart")
                    if charRoot then
                        local dist = (pos - charRoot.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = char
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

local function performAttack()
    if not state.fast_attack then return end
    local target = getNearestTarget()
    if not target then return end
    
    local now = tick()
    if now - lastAttack < attackCooldown then return end
    
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if targetRoot and root then
        root.CFrame = CFrame.new(root.Position, targetRoot.Position)
        
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            if VU then VU:ClickButton1() end
        end)
        
        lastAttack = now
    end
end

local function startFastAttack()
    if attackRunning then return end
    attackRunning = true
    task.spawn(function()
        while attackRunning do
            performAttack()
            task.wait(attackCooldown)
        end
    end)
end

local function stopFastAttack()
    attackRunning = false
end

startFastAttack()

-- ============================================
-- ESP (только Fruit, Player, Chest, Island)
-- ============================================
local espLabels = {}
local espActive = false

local devilFruits = {
    "Bomb", "Spike", "Chop", "Spring", "Kilo", "Spin",
    "Flame", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake",
    "Buddha", "Love", "Spider", "Phoenix", "Portal", "Rumble",
    "Dragon", "Leopard", "Mammoth", "T-Rex", "Spirit", "Venom", "Control", "Gravity", "Shadow", "Dough"
}

local function isDevilFruit(obj)
    if not obj:IsA("Tool") then return false end
    local name = obj.Name
    for _, fruit in ipairs(devilFruits) do
        if name:find(fruit) then return true end
    end
    return false
end

local function getFruitRarity(name)
    local common = {"Bomb", "Spike", "Chop", "Spring", "Kilo", "Spin"}
    local rare = {"Flame", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake"}
    local legendary = {"Buddha", "Love", "Spider", "Phoenix", "Portal", "Rumble"}
    local mythical = {"Dragon", "Leopard", "Mammoth", "T-Rex", "Spirit", "Venom", "Control", "Gravity", "Shadow", "Dough"}
    
    for _, n in ipairs(common) do if name:find(n) then return "Common" end end
    for _, n in ipairs(rare) do if name:find(n) then return "Rare" end end
    for _, n in ipairs(legendary) do if name:find(n) then return "Legendary" end end
    for _, n in ipairs(mythical) do if name:find(n) then return "Mythical" end end
    return "Unknown"
end

local function shouldShowFruit(rarity)
    local f = state.fruit_filter
    if f == "Все" then return true end
    if f == "Rare+" then return rarity == "Rare" or rarity == "Legendary" or rarity == "Mythical" end
    if f == "Legendary+" then return rarity == "Legendary" or rarity == "Mythical" end
    if f == "Mythical" then return rarity == "Mythical" end
    return true
end

local function addLabel(obj, text, color, offset)
    if not obj then return end
    for o, l in pairs(espLabels) do
        if l and l.Adornee == obj then
            local tl = l:FindFirstChild("TextLabel")
            if tl then tl.Text = text end
            return
        end
    end
    
    local bill = Instance.new("BillboardGui")
    bill.Adornee = obj
    bill.Size = UDim2.new(0, 140, 0, 24)
    bill.StudsOffset = Vector3.new(0, offset or 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = obj
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    espLabels[obj] = bill
end

local function clearESP()
    for _, l in pairs(espLabels) do
        pcall(function() l:Destroy() end)
    end
    espLabels = {}
end

local function updateESP()
    if not espActive then return end
    
    if state.fruit_esp then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if isDevilFruit(obj) then
                local r = getFruitRarity(obj.Name)
                if shouldShowFruit(r) then
                    local color = r == "Mythical" and Color3.new(1, 0.33, 1) or 
                                  r == "Legendary" and Color3.new(1, 0.84, 0) or 
                                  r == "Rare" and Color3.new(0, 0.59, 1) or 
                                  Color3.new(0.78, 0.78, 0.78)
                    addLabel(obj, obj.Name .. " [" .. r .. "]", color, 2.5)
                end
            end
        end
    end
    
    if state.player_esp then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid and c.Humanoid.Health > 0 then
                    local lvl = p.Data and p.Data.Level and p.Data.Level.Value or "?"
                    addLabel(c, p.Name .. " [Lv." .. lvl .. "]", p.TeamColor and p.TeamColor.Color or Color3.new(1, 0.5, 0.5), 3)
                end
            end
        end
    end
    
    if state.chest_esp then
        for _, c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                addLabel(c, "📦 " .. c.Name, Color3.new(1, 0.84, 0), 2)
            end
        end
    end
    
    if state.island_esp then
        for _, i in ipairs(workspace:GetChildren()) do
            if i:IsA("Model") and (i.Name:lower():find("island") or i.Name:lower():find("town") or i.Name:lower():find("port")) then
                addLabel(i, "🏝️ " .. i.Name, Color3.new(0.5, 0.8, 1), 12)
            end
        end
    end
    
    for obj, label in pairs(espLabels) do
        if not obj or not obj.Parent then
            pcall(function() label:Destroy() end)
            espLabels[obj] = nil
        end
    end
end

local function startESP()
    if espActive then return end
    espActive = true
    task.spawn(function()
        while espActive do
            updateESP()
            task.wait(0.35)
        end
    end)
end

local function stopESP()
    espActive = false
    clearESP()
end

-- ============================================
-- ТЕЛЕПОРТЫ (полный список)
-- ============================================
local seaCoords = {
    ["1st Sea"] = Vector3.new(-1250, 80, 330),
    ["2nd Sea"] = Vector3.new(-1250, 80, 330),
    ["3rd Sea"] = Vector3.new(-1250, 80, 330)
}

local islands = {
    ["Pirate Starter"] = Vector3.new(-1150, 80, 380),
    ["Marine Starter"] = Vector3.new(-1150, 80, 380),
    ["Jungle"] = Vector3.new(-1150, 80, 380),
    ["Desert"] = Vector3.new(-1150, 80, 380),
    ["Sky Islands"] = Vector3.new(-1150, 80, 380),
    ["Kingdom of Rose"] = Vector3.new(-1150, 80, 380),
    ["Port Town"] = Vector3.new(-1150, 80, 380),
    ["Hydra Island"] = Vector3.new(-1150, 80, 380),
    ["Great Tree"] = Vector3.new(-1150, 80, 380)
}

local npcs = {
    ["Monkey"] = Vector3.new(-1150, 80, 380),
    ["Bandit"] = Vector3.new(-1150, 80, 380),
    ["Gorilla"] = Vector3.new(-1150, 80, 380)
}

local function teleport(coords)
    if root then
        root.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- СОЗДАНИЕ ВКЛАДОК
-- ============================================

Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X", "Solara", "Hydrogen"}
})

-- Вкладка Фарм
local farmTab = Window:CreateTab({Name = "Фарм", Icon = "grass", ImageSource = "Material"})
local farmSec = farmTab:CreateSection("Auto Farm")
farmSec:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(v) state.auto_farm_level = v end})
farmSec:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(v) state.auto_farm_nearby = v end})
farmSec:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.farm_weapon = v end})

local bossSec = farmTab:CreateSection("Auto Farm Boss")
bossSec:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(v) state.auto_farm_boss = v end})
bossSec:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral"}, CurrentOption = "Diamond", Callback = function(v) state.selected_boss = v end})
bossSec:CreateDropdown({Name = "Оружие (босс)", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.boss_weapon = v end})
bossSec:CreateToggle({Name = "Использовать Fast Attack", CurrentValue = true, Callback = function(v) state.boss_fast_attack = v end})

local masterySec = farmTab:CreateSection("Auto Mastery")
masterySec:CreateToggle({Name = "Auto Mastery", CurrentValue = false, Callback = function(v) state.auto_mastery = v end})
masterySec:CreateDropdown({Name = "Тип", Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, CurrentOption = "Меч", Callback = function(v) state.mastery_type = v end})
masterySec:CreateToggle({Name = "Использовать Z", CurrentValue = true, Callback = function(v) state.skills.Z = v end})
masterySec:CreateToggle({Name = "Использовать X", CurrentValue = true, Callback = function(v) state.skills.X = v end})
masterySec:CreateToggle({Name = "Использовать C", CurrentValue = false, Callback = function(v) state.skills.C = v end})
masterySec:CreateToggle({Name = "Использовать V", CurrentValue = false, Callback = function(v) state.skills.V = v end})
masterySec:CreateToggle({Name = "Использовать F", CurrentValue = false, Callback = function(v) state.skills.F = v end})

local fruitSec = farmTab:CreateSection("Auto Fruit")
fruitSec:CreateToggle({Name = "Auto Fruit (Spawn)", CurrentValue = false, Callback = function(v) state.auto_fruit_spawn = v end})
fruitSec:CreateToggle({Name = "Auto Fruit (Dealer)", CurrentValue = false, Callback = function(v) state.auto_fruit_dealer = v end})
fruitSec:CreateToggle({Name = "Auto Store Fruit", CurrentValue = false, Callback = function(v) state.auto_store_fruit = v end})

local chestSec = farmTab:CreateSection("Auto Chest")
chestSec:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(v) state.auto_chest = v end})
chestSec:CreateDropdown({Name = "Режим", Options = {"Teleport Farm", "Tween Farm"}, CurrentOption = "Teleport Farm", Callback = function(v) state.chest_mode = v end})

local otherSec = farmTab:CreateSection("Другие функции")
otherSec:CreateToggle({Name = "Auto Sea Beast", CurrentValue = false, Callback = function(v) state.auto_sea_beast = v end})
otherSec:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Callback = function(v) state.auto_elite = v end})
otherSec:CreateToggle({Name = "Auto Observation (Ken Haki)", CurrentValue = false, Callback = function(v) state.auto_observation = v end})
otherSec:CreateToggle({Name = "Auto Factory", CurrentValue = false, Callback = function(v) state.auto_factory = v end})
otherSec:CreateToggle({Name = "Auto Mirage Island", CurrentValue = false, Callback = function(v) state.auto_mirage = v end})

local kitsuneSec = farmTab:CreateSection("Auto Kitsune Island")
kitsuneSec:CreateToggle({Name = "Авто-сбор Azure Embers", CurrentValue = false, Callback = function(v) state.auto_kitsune_collect = v end})
kitsuneSec:CreateToggle({Name = "Сдавать Azure Embers", CurrentValue = false, Callback = function(v) state.auto_kitsune_trade = v end})
kitsuneSec:CreateSlider({Name = "Количество для сдачи", Range = {0, 20}, Increment = 1, CurrentValue = 10, Callback = function(v) state.kitsune_amount = v end})

-- Вкладка Телепорты
local teleTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local teleSec = teleTab:CreateSection("Телепорт между морями")
teleSec:CreateButton({Name = "Teleport to 1st Sea", Callback = function() teleport(seaCoords["1st Sea"]) Luna:Notification({Title = "Телепорт", Content = "1st Sea"}) end})
teleSec:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() teleport(seaCoords["2nd Sea"]) Luna:Notification({Title = "Телепорт", Content = "2nd Sea"}) end})
teleSec:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() teleport(seaCoords["3rd Sea"]) Luna:Notification({Title = "Телепорт", Content = "3rd Sea"}) end})

local islandSec = teleTab:CreateSection("Острова")
islandSec:CreateButton({Name = "Pirate Starter", Callback = function() teleport(islands["Pirate Starter"]) end})
islandSec:CreateButton({Name = "Marine Starter", Callback = function() teleport(islands["Marine Starter"]) end})
islandSec:CreateButton({Name = "Jungle", Callback = function() teleport(islands["Jungle"]) end})
islandSec:CreateButton({Name = "Desert", Callback = function() teleport(islands["Desert"]) end})
islandSec:CreateButton({Name = "Sky Islands", Callback = function() teleport(islands["Sky Islands"]) end})
islandSec:CreateButton({Name = "Kingdom of Rose", Callback = function() teleport(islands["Kingdom of Rose"]) end})
islandSec:CreateButton({Name = "Port Town", Callback = function() teleport(islands["Port Town"]) end})
islandSec:CreateButton({Name = "Hydra Island", Callback = function() teleport(islands["Hydra Island"]) end})
islandSec:CreateButton({Name = "Great Tree", Callback = function() teleport(islands["Great Tree"]) end})

local npcSec = teleTab:CreateSection("NPC")
npcSec:CreateButton({Name = "Monkey", Callback = function() teleport(npcs["Monkey"]) end})
npcSec:CreateButton({Name = "Bandit", Callback = function() teleport(npcs["Bandit"]) end})
npcSec:CreateButton({Name = "Gorilla", Callback = function() teleport(npcs["Gorilla"]) end})

-- Вкладка PvP
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака (быстрая)",
    CurrentValue = true,
    Callback = function(v)
        state.fast_attack = v
        if v then startFastAttack() else stopFastAttack() end
    end
})

pvpSec:CreateToggle({
    Name = "PvP Mode",
    Description = "Атаковать игроков",
    CurrentValue = false,
    Callback = function(v) state.pvp_mode = v end
})

pvpSec:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(v)
        state.speed_enabled = v
        updateSpeed()
    end
})

pvpSec:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v)
        state.speed = v
        if state.speed_enabled then updateSpeed()
    end
})

pvpSec:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(v)
        state.jump_enabled = v
        updateJump()
    end
})

pvpSec:CreateSlider({
    Name = "Jump Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v)
        state.jump = v
        if state.jump_enabled then updateJump()
    end
})

pvpSec:CreateSlider({Name = "Dash Length", Range = {0, 200}, Increment = 1, CurrentValue = 0, Callback = function(v) state.dash_length = v end})
pvpSec:CreateToggle({Name = "Infinite Air Jumps", CurrentValue = false, Callback = function(v) state.infinite_air_jumps = v end})
pvpSec:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(v) state.anti_stun = v end})
pvpSec:CreateToggle({Name = "Infinite Energy", CurrentValue = false, Callback = function(v) state.infinite_energy = v end})

local silentSec = pvpTab:CreateSection("Silent Aim")
silentSec:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(v) state.silent_aim = v end})
silentSec:CreateDropdown({Name = "Режим", Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, CurrentOption = "FOV", Callback = function(v) state.silent_mode = v end})
silentSec:CreateSlider({Name = "FOV", Range = {0, 360}, Increment = 1, CurrentValue = 90, Callback = function(v) state.silent_fov = v end})
silentSec:CreateSlider({Name = "Макс. дистанция", Range = {0, 500}, Increment = 10, CurrentValue = 200, Callback = function(v) state.silent_distance = v end})

-- Вкладка ESP
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")

espSec:CreateToggle({
    Name = "Fruit ESP",
    Description = "Показывает Devil Fruits",
    CurrentValue = false,
    Callback = function(v)
        state.fruit_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(v) state.fruit_filter = v end
})

espSec:CreateToggle({
    Name = "Player ESP",
    Description = "Показывает игроков",
    CurrentValue = false,
    Callback = function(v)
        state.player_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "Chest ESP",
    Description = "Показывает сундуки",
    CurrentValue = false,
    Callback = function(v)
        state.chest_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "Island ESP",
    Description = "Показывает названия островов",
    CurrentValue = false,
    Callback = function(v)
        state.island_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

-- Вкладка Raid
local raidTab = Window:CreateTab({Name = "Raid", Icon = "whatshot", ImageSource = "Material"})
local raidSec = raidTab:CreateSection("Auto Raid")
raidSec:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(v) state.auto_raid = v end})
raidSec:CreateToggle({Name = "Авто-старт", CurrentValue = false, Callback = function(v) state.raid_auto_start = v end})
raidSec:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = "Buddha", Callback = function(v) state.raid_type = v end})
raidSec:CreateToggle({Name = "Авто-покупка рейда", CurrentValue = false, Callback = function(v) state.raid_auto_buy = v end})
raidSec:CreateToggle({Name = "Авто-доставание фрукта", CurrentValue = false, Callback = function(v) state.raid_auto_fruit = v end})
raidSec:CreateSlider({Name = "Макс. цена фрукта (Beli)", Range = {0, 1000000}, Increment = 10000, CurrentValue = 500000, Callback = function(v) state.raid_max_price = v end})
raidSec:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(v) state.kill_aura_raid = v end})

-- Вкладка Настройки
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})
local configSec = setTab:CreateSection("Конфигурации")
configSec:CreateButton({Name = "Создать конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
configSec:CreateButton({Name = "Сохранить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
configSec:CreateButton({Name = "Загрузить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})

local generalSec = setTab:CreateSection("Общие")
generalSec:CreateButton({Name = "Auto Update", Callback = function() Luna:Notification({Title = "Обновление", Content = "Последняя версия"}) end})
generalSec:CreateButton({Name = "Unload Script", Callback = function() stopFastAttack(); stopESP(); Window:Destroy() end})
generalSec:CreateToggle({Name = "Mobile Support", CurrentValue = UIS.TouchEnabled, Callback = function(v) print("[Settings] Mobile:", v) end})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША (правая клавиша Ctrl)
-- ============================================
local mainFrame = nil
local shadowHolder = nil
local visible = true

local function findLunaWindow()
    local parent = gethui and gethui() or game:GetService("CoreGui")
    for _, gui in ipairs(parent:GetChildren()) do
        if gui.Name == "Luna UI" or (gui.Name and string.find(gui.Name, "Luna")) then
            if gui:FindFirstChild("SmartWindow") then
                mainFrame = gui.SmartWindow
                shadowHolder = gui:FindFirstChild("ShadowHolder")
                return true
            end
        end
    end
    return false
end

findLunaWindow()
if not mainFrame then
    task.wait(1)
    findLunaWindow()
end

-- Отключаем встроенный бинд и устанавливаем RightControl
pcall(function()
    if Window._bindConnection then
        Window._bindConnection:Disconnect()
    end
    Window.Bind = Enum.KeyCode.RightControl
end)

-- Включаем размытие только когда интерфейс открыт
task.wait(0.5)
if mainFrame then
    mainFrame.Visible = true
    if shadowHolder then
        shadowHolder.Visible = true
    end
end

-- Уведомление
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт загружен! Клавиша: Right Control",
    Icon = "sparkle",
    ImageSource = "Material",
    Duration = 3
})

print("Abyss Hub загружен! Клавиша: Right Control")
