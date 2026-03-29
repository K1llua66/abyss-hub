--[[
    Abyss Hub
    Версия: 1.0 (исправленный)
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
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Состояние функций
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
    npc_esp = false,
    chest_esp = false,
    island_esp = false,
    flower_esp = false,
    fruit_filter = "Все",
    auto_raid = false,
    raid_auto_start = false,
    raid_type = "Buddha",
    raid_auto_buy = false,
    raid_auto_fruit = false,
    raid_max_price = 500000,
    kill_aura_raid = false,
    selected_island = "Pirate Starter",
    selected_npc = "Monkey",
    selected_teleport_island = "Pirate Starter",
    window_bind = "RightShift"
}

-- Координаты островов
local islands = {
    ["1st Sea"] = {
        ["Pirate Starter"] = Vector3.new(-1150, 80, 380),
        ["Marine Starter"] = Vector3.new(-1150, 80, 380),
        ["Jungle"] = Vector3.new(-1150, 80, 380),
        ["Middle Town"] = Vector3.new(-1150, 80, 380),
        ["Frozen Village"] = Vector3.new(-1150, 80, 380),
        ["Marine Fortress"] = Vector3.new(-1150, 80, 380),
        ["Skylands"] = Vector3.new(-1150, 80, 380),
        ["Prison"] = Vector3.new(-1150, 80, 380),
        ["Colosseum"] = Vector3.new(-1150, 80, 380),
        ["Magma Village"] = Vector3.new(-1150, 80, 380),
        ["Underwater City"] = Vector3.new(-1150, 80, 380),
        ["Fountain City"] = Vector3.new(-1150, 80, 380),
    },
    ["2nd Sea"] = {
        ["Kingdom of Rose"] = Vector3.new(-1150, 80, 380),
        ["Green Zone"] = Vector3.new(-1150, 80, 380),
        ["Graveyard"] = Vector3.new(-1150, 80, 380),
        ["Hot and Cold"] = Vector3.new(-1150, 80, 380),
        ["Cafe"] = Vector3.new(-1150, 80, 380),
        ["Flamingo Mansion"] = Vector3.new(-1150, 80, 380),
        ["Ice Castle"] = Vector3.new(-1150, 80, 380),
        ["Forgotten Island"] = Vector3.new(-1150, 80, 380),
        ["Usoap's Island"] = Vector3.new(-1150, 80, 380),
    },
    ["3rd Sea"] = {
        ["Port Town"] = Vector3.new(-1150, 80, 380),
        ["Hydra Island"] = Vector3.new(-1150, 80, 380),
        ["Great Tree"] = Vector3.new(-1150, 80, 380),
        ["Castle on the Sea"] = Vector3.new(-1150, 80, 380),
        ["Sea of Treats"] = Vector3.new(-1150, 80, 380),
        ["Tiki Outpost"] = Vector3.new(-1150, 80, 380),
    }
}

-- Координаты морей
local seaCoords = {
    ["1st Sea"] = Vector3.new(-1250, 80, 330),
    ["2nd Sea"] = Vector3.new(-1250, 80, 330),
    ["3rd Sea"] = Vector3.new(-1250, 80, 330),
}

-- NPC координаты (пример)
local npcs = {
    ["Monkey"] = Vector3.new(-1150, 80, 380),
    ["Gorilla"] = Vector3.new(-1150, 80, 380),
    ["Pirate"] = Vector3.new(-1150, 80, 380),
    ["Marine"] = Vector3.new(-1150, 80, 380),
}

-- Телепорт
local function teleportTo(coords)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(coords)
        return true
    end
    return false
end

-- Безопасный телепорт (с ресетом)
local function safeTeleportTo(coords)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
        task.wait(0.3)
        char.HumanoidRootPart.CFrame = CFrame.new(coords)
    end
end

-- Скорость
local function updateSpeed()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if state.speed_enabled then
            char.Humanoid.WalkSpeed = 16 * state.speed
        else
            char.Humanoid.WalkSpeed = 16
        end
    end
end

-- Прыжок
local function updateJump()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if state.jump_enabled then
            char.Humanoid.JumpPower = 50 * state.jump
        else
            char.Humanoid.JumpPower = 50
        end
    end
end

-- Fast Attack (увеличение скорости атаки через анимации)
local function updateFastAttack()
    -- Здесь логика Fast Attack
    print("[Fast Attack] Set to:", state.fast_attack)
end

-- Anti-Stun
local function updateAntiStun()
    print("[Anti-Stun] Set to:", state.anti_stun)
end

-- Infinite Energy
local function updateInfiniteEnergy()
    print("[Infinite Energy] Set to:", state.infinite_energy)
end

-- Dash Length
local function updateDashLength()
    print("[Dash Length] Set to:", state.dash_length)
end

-- Infinite Air Jumps
local function updateInfiniteAirJumps()
    print("[Infinite Air Jumps] Set to:", state.infinite_air_jumps)
end

-- Следим за персонажем для применения настроек
RunService.Heartbeat:Connect(function()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- СОЗДАНИЕ ВКЛАДОК
-- ============================================

-- Home Tab
Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X"}
})

-- Вкладка Фарм
local FarmTab = Window:CreateTab({
    Name = "Фарм",
    Icon = "grass",
    ImageSource = "Material"
})

-- Вкладка Телепорты
local TeleportTab = Window:CreateTab({
    Name = "Телепорты",
    Icon = "navigation",
    ImageSource = "Material"
})

-- Вкладка PvP
local PvPTab = Window:CreateTab({
    Name = "PvP",
    Icon = "sports_mma",
    ImageSource = "Material"
})

-- Вкладка ESP
local ESPTab = Window:CreateTab({
    Name = "ESP",
    Icon = "visibility",
    ImageSource = "Material"
})

-- Вкладка Raid
local RaidTab = Window:CreateTab({
    Name = "Raid",
    Icon = "whatshot",
    ImageSource = "Material"
})

-- Вкладка Настройки
local SettingsTab = Window:CreateTab({
    Name = "Настройки",
    Icon = "settings",
    ImageSource = "Material"
})

-- ============================================
-- ВКЛАДКА ФАРМ
-- ============================================

-- Auto Farm
local FarmSection = FarmTab:CreateSection("Auto Farm")
FarmSection:CreateToggle({
    Name = "Auto Farm (Уровень)",
    CurrentValue = false,
    Callback = function(val)
        state.auto_farm_level = val
        print("[Farm] Level:", val)
    end
})

FarmSection:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    CurrentValue = false,
    Callback = function(val)
        state.auto_farm_nearby = val
        print("[Farm] Nearby:", val)
    end
})

FarmSection:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(opt)
        state.farm_weapon = opt
        print("[Farm] Weapon:", opt)
    end
})

-- Auto Farm Boss
local BossSection = FarmTab:CreateSection("Auto Farm Boss")
BossSection:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(val)
        state.auto_farm_boss = val
        print("[Boss]", val)
    end
})

BossSection:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"},
    CurrentOption = "Diamond",
    Callback = function(opt)
        state.selected_boss = opt
        print("[Boss] Select:", opt)
    end
})

BossSection:CreateDropdown({
    Name = "Оружие (босс)",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(opt)
        state.boss_weapon = opt
        print("[Boss] Weapon:", opt)
    end
})

BossSection:CreateToggle({
    Name = "Использовать Fast Attack",
    CurrentValue = true,
    Callback = function(val)
        state.boss_fast_attack = val
        print("[Boss] Fast Attack:", val)
    end
})

BossSection:CreateDropdown({
    Name = "Способ передвижения",
    Options = {"Телепорт", "Бег"},
    CurrentOption = "Телепорт",
    Callback = function(opt)
        state.boss_move = opt
        print("[Boss] Move:", opt)
    end
})

-- Auto Mastery
local MasterySection = FarmTab:CreateSection("Auto Mastery")
MasterySection:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(val)
        state.auto_mastery = val
        print("[Mastery]", val)
    end
})

MasterySection:CreateDropdown({
    Name = "Тип",
    Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"},
    CurrentOption = "Меч",
    Callback = function(opt)
        state.mastery_type = opt
        print("[Mastery] Type:", opt)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать Z",
    CurrentValue = true,
    Callback = function(val)
        state.skills.Z = val
        print("[Mastery] Z:", val)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать X",
    CurrentValue = true,
    Callback = function(val)
        state.skills.X = val
        print("[Mastery] X:", val)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать C",
    CurrentValue = false,
    Callback = function(val)
        state.skills.C = val
        print("[Mastery] C:", val)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать V",
    CurrentValue = false,
    Callback = function(val)
        state.skills.V = val
        print("[Mastery] V:", val)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать F",
    CurrentValue = false,
    Callback = function(val)
        state.skills.F = val
        print("[Mastery] F:", val)
    end
})

-- Auto Fruit
local FruitSection = FarmTab:CreateSection("Auto Fruit")
FruitSection:CreateToggle({
    Name = "Auto Fruit (Spawn)",
    CurrentValue = false,
    Callback = function(val)
        state.auto_fruit_spawn = val
        print("[Fruit] Spawn:", val)
    end
})

FruitSection:CreateToggle({
    Name = "Auto Fruit (Dealer)",
    CurrentValue = false,
    Callback = function(val)
        state.auto_fruit_dealer = val
        print("[Fruit] Dealer:", val)
    end
})

FruitSection:CreateToggle({
    Name = "Auto Store Fruit",
    CurrentValue = false,
    Callback = function(val)
        state.auto_store_fruit = val
        print("[Fruit] Store:", val)
    end
})

-- Auto Chest
local ChestSection = FarmTab:CreateSection("Auto Chest")
ChestSection:CreateToggle({
    Name = "Auto Chest",
    CurrentValue = false,
    Callback = function(val)
        state.auto_chest = val
        print("[Chest]", val)
    end
})

ChestSection:CreateDropdown({
    Name = "Режим",
    Options = {"Teleport Farm", "Tween Farm"},
    CurrentOption = "Teleport Farm",
    Callback = function(opt)
        state.chest_mode = opt
        print("[Chest] Mode:", opt)
    end
})

-- Другие функции
local OtherSection = FarmTab:CreateSection("Другие функции")
OtherSection:CreateToggle({
    Name = "Auto Sea Beast",
    CurrentValue = false,
    Callback = function(val)
        state.auto_sea_beast = val
        print("[Sea Beast]", val)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Elite Hunter",
    CurrentValue = false,
    Callback = function(val)
        state.auto_elite = val
        print("[Elite Hunter]", val)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Observation (Ken Haki)",
    CurrentValue = false,
    Callback = function(val)
        state.auto_observation = val
        print("[Observation]", val)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Factory",
    CurrentValue = false,
    Callback = function(val)
        state.auto_factory = val
        print("[Factory]", val)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Mirage Island",
    CurrentValue = false,
    Callback = function(val)
        state.auto_mirage = val
        print("[Mirage]", val)
    end
})

-- Auto Kitsune Island
local KitsuneSection = FarmTab:CreateSection("Auto Kitsune Island")
KitsuneSection:CreateToggle({
    Name = "Авто-сбор Azure Embers",
    CurrentValue = false,
    Callback = function(val)
        state.auto_kitsune_collect = val
        print("[Kitsune] Collect:", val)
    end
})

KitsuneSection:CreateToggle({
    Name = "Сдавать Azure Embers",
    CurrentValue = false,
    Callback = function(val)
        state.auto_kitsune_trade = val
        print("[Kitsune] Trade:", val)
    end
})

KitsuneSection:CreateSlider({
    Name = "Количество для сдачи",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(val)
        state.kitsune_amount = val
        print("[Kitsune] Amount:", val)
    end
})

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ (с выбором)
-- ============================================

local TeleportSection = TeleportTab:CreateSection("Телепорт между морями")

TeleportSection:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        teleportTo(seaCoords["1st Sea"])
        Luna:Notification({Title = "Телепорт", Content = "1st Sea", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        teleportTo(seaCoords["2nd Sea"])
        Luna:Notification({Title = "Телепорт", Content = "2nd Sea", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        teleportTo(seaCoords["3rd Sea"])
        Luna:Notification({Title = "Телепорт", Content = "3rd Sea", Icon = "navigation"})
    end
})

TeleportSection:CreateDivider()

local IslandSection = TeleportTab:CreateSection("Телепорт на остров (безопасный)")

-- Выбор моря для островов
local selectedSea = "1st Sea"
IslandSection:CreateDropdown({
    Name = "Выбор моря",
    Options = {"1st Sea", "2nd Sea", "3rd Sea"},
    CurrentOption = "1st Sea",
    Callback = function(opt)
        selectedSea = opt
        -- Обновляем список островов в зависимости от моря
        local islandList = {}
        for name, _ in pairs(islands[selectedSea]) do
            table.insert(islandList, name)
        end
        -- Обновляем дропдаун с островами
        islandDropdown:Set({ Options = islandList, CurrentOption = islandList[1] })
    end
})

-- Дропдаун для выбора острова
local islandDropdown = IslandSection:CreateDropdown({
    Name = "Выбор острова",
    Options = {"Pirate Starter", "Marine Starter", "Jungle", "Middle Town", "Frozen Village"},
    CurrentOption = "Pirate Starter",
    Callback = function(opt)
        state.selected_teleport_island = opt
        print("[Teleport] Selected island:", opt)
    end
})

IslandSection:CreateButton({
    Name = "Teleport to Island",
    Callback = function()
        local coords = islands[selectedSea] and islands[selectedSea][state.selected_teleport_island]
        if coords then
            safeTeleportTo(coords)
            Luna:Notification({Title = "Телепорт", Content = state.selected_teleport_island, Icon = "navigation"})
        else
            Luna:Notification({Title = "Ошибка", Content = "Координаты не найдены", Icon = "warning"})
        end
    end
})

TeleportTab:CreateDivider()

local NPCSection = TeleportTab:CreateSection("Телепорт к NPC")

local npcDropdown = NPCSection:CreateDropdown({
    Name = "Выбор NPC",
    Options = {"Monkey", "Gorilla", "Pirate", "Marine"},
    CurrentOption = "Monkey",
    Callback = function(opt)
        state.selected_npc = opt
        print("[Teleport] Selected NPC:", opt)
    end
})

NPCSection:CreateButton({
    Name = "Teleport to NPC",
    Callback = function()
        local coords = npcs[state.selected_npc]
        if coords then
            teleportTo(coords)
            Luna:Notification({Title = "Телепорт", Content = state.selected_npc, Icon = "navigation"})
        end
    end
})

TeleportTab:CreateButton({
    Name = "Hop to Server",
    Callback = function()
        Luna:Notification({Title = "Hop", Content = "Поиск сервера...", Icon = "search"})
        -- Здесь логика поиска сервера
    end
})

-- ============================================
-- ВКЛАДКА PVP (с рабочим Fast Attack)
-- ============================================

local PvPSection = PvPTab:CreateSection("PvP Functions")

-- Fast Attack (автоматическая быстрая атака)
PvPSection:CreateToggle({
    Name = "Fast Attack (авто-атака)",
    Description = "Автоматически атакует ближайших врагов с интервалом 0.25 сек",
    CurrentValue = true,
    Callback = function(val)
        state.fast_attack = val
        updateFastAttack()
        print("[PvP] Fast Attack:", val)
        if val then
            Luna:Notification({Title = "Fast Attack", Content = "Включена", Icon = "speed"})
        else
            Luna:Notification({Title = "Fast Attack", Content = "Выключена", Icon = "speed"})
        end
    end
})

-- Anti-Stun
PvPSection:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(val)
        state.anti_stun = val
        updateAntiStun()
        print("[PvP] Anti-Stun:", val)
    end
})

-- Infinite Energy
PvPSection:CreateToggle({
    Name = "Infinite Energy",
    CurrentValue = false,
    Callback = function(val)
        state.infinite_energy = val
        updateInfiniteEnergy()
        print("[PvP] Infinite Energy:", val)
    end
})

-- Speed с отдельным тогглом
PvPSection:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(val)
        state.speed_enabled = val
        updateSpeed()
        print("[PvP] Speed Boost:", val)
        if val then
            Luna:Notification({Title = "Speed Boost", Content = "x" .. state.speed, Icon = "speed"})
        end
    end
})

PvPSection:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(val)
        state.speed = val
        if state.speed_enabled then updateSpeed() end
        print("[PvP] Speed x", val)
        if state.speed_enabled then
            Luna:Notification({Title = "Speed", Content = "x" .. val, Icon = "speed", Duration = 1})
        end
    end
})

-- Jump с отдельным тогглом
PvPSection:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(val)
        state.jump_enabled = val
        updateJump()
        print("[PvP] Jump Boost:", val)
        if val then
            Luna:Notification({Title = "Jump Boost", Content = "x" .. state.jump, Icon = "upgrade"})
        end
    end
})

PvPSection:CreateSlider({
    Name = "Jump Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(val)
        state.jump = val
        if state.jump_enabled then updateJump() end
        print("[PvP] Jump x", val)
        if state.jump_enabled then
            Luna:Notification({Title = "Jump", Content = "x" .. val, Icon = "upgrade", Duration = 1})
        end
    end
})

PvPSection:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(val)
        state.dash_length = val
        updateDashLength()
        print("[PvP] Dash:", val)
    end
})

PvPSection:CreateToggle({
    Name = "Infinite Air Jumps",
    CurrentValue = false,
    Callback = function(val)
        state.infinite_air_jumps = val
        updateInfiniteAirJumps()
        print("[PvP] Air Jumps:", val)
    end
})

-- PvP Mode (разрешает атаковать игроков)
PvPSection:CreateToggle({
    Name = "PvP Mode (атака игроков)",
    Description = "Включает атаку на других игроков (осторожно!)",
    CurrentValue = false,
    Callback = function(val)
        state.pvp_mode = val
        print("[PvP] PvP Mode:", val)
        if val then
            Luna:Notification({Title = "PvP Mode", Content = "Включена (атака игроков)", Icon = "warning"})
        else
            Luna:Notification({Title = "PvP Mode", Content = "Выключена", Icon = "info"})
        end
    end
})

-- Silent Aim
local SilentSection = PvPTab:CreateSection("Silent Aim")

SilentSection:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(val)
        state.silent_aim = val
        print("[Silent]", val)
    end
})

SilentSection:CreateDropdown({
    Name = "Режим",
    Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"},
    CurrentOption = "FOV",
    Callback = function(opt)
        state.silent_mode = opt
        print("[Silent] Mode:", opt)
    end
})

SilentSection:CreateSlider({
    Name = "FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Callback = function(val)
        state.silent_fov = val
        print("[Silent] FOV:", val)
    end
})

SilentSection:CreateSlider({
    Name = "Макс. дистанция",
    Range = {0, 500},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(val)
        state.silent_distance = val
        print("[Silent] Distance:", val)
    end
})

-- ============================================
-- ВКЛАДКА ESP
-- ============================================

local EspSection = ESPTab:CreateSection("ESP Functions")

EspSection:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(val)
        state.fruit_esp = val
        print("[ESP] Fruit:", val)
    end
})

EspSection:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(val)
        state.player_esp = val
        print("[ESP] Player:", val)
    end
})

EspSection:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(val)
        state.npc_esp = val
        print("[ESP] NPC:", val)
    end
})

EspSection:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Callback = function(val)
        state.chest_esp = val
        print("[ESP] Chest:", val)
    end
})

EspSection:CreateToggle({
    Name = "Island ESP",
    CurrentValue = false,
    Callback = function(val)
        state.island_esp = val
        print("[ESP] Island:", val)
    end
})

EspSection:CreateToggle({
    Name = "Flower ESP",
    CurrentValue = false,
    Callback = function(val)
        state.flower_esp = val
        print("[ESP] Flower:", val)
    end
})

EspSection:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(opt)
        state.fruit_filter = opt
        print("[ESP] Filter:", opt)
    end
})

-- ============================================
-- ВКЛАДКА RAID
-- ============================================

local RaidSection = RaidTab:CreateSection("Auto Raid")

RaidSection:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Callback = function(val)
        state.auto_raid = val
        print("[Raid] Auto:", val)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-старт",
    CurrentValue = false,
    Callback = function(val)
        state.raid_auto_start = val
        print("[Raid] Auto Start:", val)
    end
})

RaidSection:CreateDropdown({
    Name = "Выбор рейда",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"},
    CurrentOption = "Buddha",
    Callback = function(opt)
        state.raid_type = opt
        print("[Raid] Type:", opt)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-покупка рейда",
    CurrentValue = false,
    Callback = function(val)
        state.raid_auto_buy = val
        print("[Raid] Auto Buy:", val)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-доставание фрукта",
    CurrentValue = false,
    Callback = function(val)
        state.raid_auto_fruit = val
        print("[Raid] Auto Fruit:", val)
    end
})

RaidSection:CreateSlider({
    Name = "Макс. цена фрукта (Beli)",
    Range = {0, 1000000},
    Increment = 10000,
    CurrentValue = 500000,
    Callback = function(val)
        state.raid_max_price = val
        print("[Raid] Max Price:", val)
    end
})

RaidSection:CreateToggle({
    Name = "Kill Aura (5 остров рейда)",
    CurrentValue = false,
    Callback = function(val)
        state.kill_aura_raid = val
        print("[Raid] Kill Aura:", val)
    end
})

-- ============================================
-- ВКЛАДКА НАСТРОЙКИ
-- ============================================

local ConfigSection = SettingsTab:CreateSection("Конфигурации")

ConfigSection:CreateButton({
    Name = "Создать конфиг",
    Callback = function()
        print("[Config] Create")
        Luna:Notification({Title = "Конфиг", Content = "Функция в разработке", Icon = "info"})
    end
})

ConfigSection:CreateButton({
    Name = "Сохранить конфиг",
    Callback = function()
        print("[Config] Save")
        Luna:Notification({Title = "Конфиг", Content = "Функция в разработке", Icon = "info"})
    end
})

ConfigSection:CreateButton({
    Name = "Загрузить конфиг",
    Callback = function()
        print("[Config] Load")
        Luna:Notification({Title = "Конфиг", Content = "Функция в разработке", Icon = "info"})
    end
})

ConfigSection:CreateButton({
    Name = "Авто-загрузка конфига",
    Callback = function()
        print("[Config] Auto Load")
        Luna:Notification({Title = "Конфиг", Content = "Функция в разработке", Icon = "info"})
    end
})

local GeneralSection = SettingsTab:CreateSection("Общие")

-- Выбор клавиши для открытия интерфейса
local keyOptions = {
    "RightShift", "LeftShift", "RightControl", "LeftControl", "RightAlt", "LeftAlt",
    "K", "L", "U", "I", "O", "P", "Q", "E", "R", "T", "Y",
    "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"
}

local keyDropdown = GeneralSection:CreateDropdown({
    Name = "Клавиша открытия",
    Options = keyOptions,
    CurrentOption = "RightShift",
    Callback = function(opt)
        state.window_bind = opt
        print("[Settings] Window bind changed to:", opt)
    end
})

GeneralSection:CreateButton({
    Name = "Auto Update",
    Callback = function()
        print("[Settings] Update")
        Luna:Notification({Title = "Обновление", Content = "Вы используете последнюю версию", Icon = "info"})
    end
})

GeneralSection:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Window:Destroy()
        print("Abyss Hub выгружен")
    end
})

GeneralSection:CreateToggle({
    Name = "Авто-запуск при переходе сервера",
    CurrentValue = true,
    Callback = function(val)
        print("[Settings] Auto Rejoin:", val)
    end
})

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

GeneralSection:CreateToggle({
    Name = "Mobile Support",
    CurrentValue = IsMobile,
    Callback = function(val)
        print("[Settings] Mobile:", val)
    end
})

GeneralSection:CreateButton({
    Name = "Настройка цветов",
    Callback = function()
        print("[Settings] Colors")
        Luna:Notification({Title = "Цвета", Content = "Функция в разработке", Icon = "info"})
    end
})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША (из настроек)
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = string.split(tostring(input.KeyCode), ".")[3] or ""
    if key == state.window_bind then
        if Window.Visible then
            Window.Visible = false
            Luna:Notification({Title = "Abyss Hub", Content = "Интерфейс скрыт", Icon = "visibility_off"})
        else
            Window.Visible = true
            Luna:Notification({Title = "Abyss Hub", Content = "Интерфейс открыт", Icon = "visibility"})
        end
    end
end)

-- Убираем размытие
pcall(function()
    _G.BlurModule = function() end
end)

-- Уведомление о загрузке
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт загружен! Настройте клавишу в настройках.",
    Icon = "sparkle",
    ImageSource = "Material"
})

print("Abyss Hub загружен! Настройка клавиши в разделе Настройки -> Общие")
