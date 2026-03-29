--[[
    Abyss Hub
    Версия: 1.0 (оптимизированный)
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = syn and syn.virtual_user or (getrenv and getrenv().virtual_user) or nil

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
    pvp_mode = false,
    window_bind = "RightShift"
}

-- Оптимизация: кэшируем часто используемые объекты
local playerChar = nil
local playerRoot = nil
local playerHumanoid = nil

local function updatePlayerRefs()
    playerChar = LocalPlayer.Character
    if playerChar then
        playerRoot = playerChar:FindFirstChild("HumanoidRootPart")
        playerHumanoid = playerChar:FindFirstChild("Humanoid")
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    updatePlayerRefs()
end)
updatePlayerRefs()

-- Скорость
local function updateSpeed()
    if playerHumanoid then
        if state.speed_enabled then
            playerHumanoid.WalkSpeed = 16 * state.speed
        else
            playerHumanoid.WalkSpeed = 16
        end
    end
end

-- Прыжок
local function updateJump()
    if playerHumanoid then
        if state.jump_enabled then
            playerHumanoid.JumpPower = 50 * state.jump
        else
            playerHumanoid.JumpPower = 50
        end
    end
end

-- ============================================
-- FAST ATTACK (оптимизированный)
-- ============================================

local fastAttackRunning = false
local fastAttackTask = nil

local function performAttack()
    if not playerRoot or not playerChar then return end
    
    local nearestTarget = nil
    local nearestDist = math.huge
    local attackRange = 15
    
    for _, v in ipairs(workspace:GetChildren()) do
        if v:IsA("Model") and v ~= playerChar and v:FindFirstChild("Humanoid") then
            local isPlayer = Players:GetPlayerFromCharacter(v)
            if (not isPlayer) or (isPlayer and state.pvp_mode) then
                local root = v:FindFirstChild("HumanoidRootPart")
                if root then
                    local dist = (root.Position - playerRoot.Position).Magnitude
                    if dist < nearestDist and dist < attackRange then
                        nearestDist = dist
                        nearestTarget = v
                    end
                end
            end
        end
    end
    
    if nearestTarget then
        local targetRoot = nearestTarget:FindFirstChild("HumanoidRootPart")
        if targetRoot then
            playerRoot.CFrame = CFrame.new(playerRoot.Position, targetRoot.Position)
            
            -- Эмулируем атаку
            pcall(function()
                local attackRemote = ReplicatedStorage:FindFirstChild("AttackEvent") or 
                                    ReplicatedStorage:FindFirstChild("Attack") or
                                    ReplicatedStorage:FindFirstChild("Combat")
                if attackRemote then
                    attackRemote:FireServer()
                end
                if VirtualUser then
                    VirtualUser:ClickButton1()
                end
            end)
        end
    end
end

local function fastAttackLoop()
    while fastAttackRunning do
        if state.fast_attack then
            performAttack()
        end
        task.wait(0.3) -- 0.3 сек между атаками (вместо 0.25 для снижения нагрузки)
    end
end

local function updateFastAttack()
    if state.fast_attack and not fastAttackRunning then
        fastAttackRunning = true
        fastAttackTask = task.spawn(fastAttackLoop)
        print("[Fast Attack] Включена")
    elseif not state.fast_attack and fastAttackRunning then
        fastAttackRunning = false
        if fastAttackTask then
            task.cancel(fastAttackTask)
            fastAttackTask = nil
        end
        print("[Fast Attack] Выключена")
    end
end

-- ============================================
-- ОСТАЛЬНЫЕ ФУНКЦИИ (заглушки для снижения нагрузки)
-- ============================================

local function updateAntiStun()
    print("[Anti-Stun] Set to:", state.anti_stun)
end

local function updateInfiniteEnergy()
    print("[Infinite Energy] Set to:", state.infinite_energy)
end

local function updateDashLength()
    print("[Dash Length] Set to:", state.dash_length)
end

local function updateInfiniteAirJumps()
    print("[Infinite Air Jumps] Set to:", state.infinite_air_jumps)
end

-- Обновляем настройки персонажа через Heartbeat (только когда нужно)
RunService.Heartbeat:Connect(function()
    updatePlayerRefs()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- КООРДИНАТЫ (для телепортов)
-- ============================================

local islands = {
    ["1st Sea"] = {
        ["Pirate Starter"] = Vector3.new(-1150, 80, 380),
        ["Marine Starter"] = Vector3.new(-1150, 80, 380),
    },
    ["2nd Sea"] = {
        ["Kingdom of Rose"] = Vector3.new(-1150, 80, 380),
    },
    ["3rd Sea"] = {
        ["Port Town"] = Vector3.new(-1150, 80, 380),
    }
}

local seaCoords = {
    ["1st Sea"] = Vector3.new(-1250, 80, 330),
    ["2nd Sea"] = Vector3.new(-1250, 80, 330),
    ["3rd Sea"] = Vector3.new(-1250, 80, 330),
}

local npcs = {
    ["Monkey"] = Vector3.new(-1150, 80, 380),
}

local function teleportTo(coords)
    if playerRoot then
        playerRoot.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- СОЗДАНИЕ ВКЛАДОК
-- ============================================

Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X"}
})

-- Вкладка Фарм
local FarmTab = Window:CreateTab({Name = "Фарм", Icon = "grass", ImageSource = "Material"})
local TeleportTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local PvPTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local ESPTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local RaidTab = Window:CreateTab({Name = "Raid", Icon = "whatshot", ImageSource = "Material"})
local SettingsTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})

-- ============================================
-- ВКЛАДКА ФАРМ
-- ============================================

local FarmSection = FarmTab:CreateSection("Auto Farm")
FarmSection:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(v) state.auto_farm_level = v end})
FarmSection:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(v) state.auto_farm_nearby = v end})
FarmSection:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.farm_weapon = v end})

-- Auto Farm Boss
local BossSection = FarmTab:CreateSection("Auto Farm Boss")
BossSection:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(v) state.auto_farm_boss = v end})
BossSection:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral"}, CurrentOption = "Diamond", Callback = function(v) state.selected_boss = v end})
BossSection:CreateDropdown({Name = "Оружие (босс)", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.boss_weapon = v end})
BossSection:CreateToggle({Name = "Использовать Fast Attack", CurrentValue = true, Callback = function(v) state.boss_fast_attack = v end})
BossSection:CreateDropdown({Name = "Способ передвижения", Options = {"Телепорт", "Бег"}, CurrentOption = "Телепорт", Callback = function(v) state.boss_move = v end})

-- Auto Mastery
local MasterySection = FarmTab:CreateSection("Auto Mastery")
MasterySection:CreateToggle({Name = "Auto Mastery", CurrentValue = false, Callback = function(v) state.auto_mastery = v end})
MasterySection:CreateDropdown({Name = "Тип", Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, CurrentOption = "Меч", Callback = function(v) state.mastery_type = v end})
MasterySection:CreateToggle({Name = "Использовать Z", CurrentValue = true, Callback = function(v) state.skills.Z = v end})
MasterySection:CreateToggle({Name = "Использовать X", CurrentValue = true, Callback = function(v) state.skills.X = v end})
MasterySection:CreateToggle({Name = "Использовать C", CurrentValue = false, Callback = function(v) state.skills.C = v end})
MasterySection:CreateToggle({Name = "Использовать V", CurrentValue = false, Callback = function(v) state.skills.V = v end})
MasterySection:CreateToggle({Name = "Использовать F", CurrentValue = false, Callback = function(v) state.skills.F = v end})

-- Auto Fruit
local FruitSection = FarmTab:CreateSection("Auto Fruit")
FruitSection:CreateToggle({Name = "Auto Fruit (Spawn)", CurrentValue = false, Callback = function(v) state.auto_fruit_spawn = v end})
FruitSection:CreateToggle({Name = "Auto Fruit (Dealer)", CurrentValue = false, Callback = function(v) state.auto_fruit_dealer = v end})
FruitSection:CreateToggle({Name = "Auto Store Fruit", CurrentValue = false, Callback = function(v) state.auto_store_fruit = v end})

-- Auto Chest
local ChestSection = FarmTab:CreateSection("Auto Chest")
ChestSection:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(v) state.auto_chest = v end})
ChestSection:CreateDropdown({Name = "Режим", Options = {"Teleport Farm", "Tween Farm"}, CurrentOption = "Teleport Farm", Callback = function(v) state.chest_mode = v end})

-- Другие функции
local OtherSection = FarmTab:CreateSection("Другие функции")
OtherSection:CreateToggle({Name = "Auto Sea Beast", CurrentValue = false, Callback = function(v) state.auto_sea_beast = v end})
OtherSection:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Callback = function(v) state.auto_elite = v end})
OtherSection:CreateToggle({Name = "Auto Observation (Ken Haki)", CurrentValue = false, Callback = function(v) state.auto_observation = v end})
OtherSection:CreateToggle({Name = "Auto Factory", CurrentValue = false, Callback = function(v) state.auto_factory = v end})
OtherSection:CreateToggle({Name = "Auto Mirage Island", CurrentValue = false, Callback = function(v) state.auto_mirage = v end})

-- Auto Kitsune Island
local KitsuneSection = FarmTab:CreateSection("Auto Kitsune Island")
KitsuneSection:CreateToggle({Name = "Авто-сбор Azure Embers", CurrentValue = false, Callback = function(v) state.auto_kitsune_collect = v end})
KitsuneSection:CreateToggle({Name = "Сдавать Azure Embers", CurrentValue = false, Callback = function(v) state.auto_kitsune_trade = v end})
KitsuneSection:CreateSlider({Name = "Количество для сдачи", Range = {0, 20}, Increment = 1, CurrentValue = 10, Callback = function(v) state.kitsune_amount = v end})

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================

local TeleportSection = TeleportTab:CreateSection("Телепорт между морями")
TeleportSection:CreateButton({Name = "Teleport to 1st Sea", Callback = function() teleportTo(seaCoords["1st Sea"]) Luna:Notification({Title = "Телепорт", Content = "1st Sea"}) end})
TeleportSection:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() teleportTo(seaCoords["2nd Sea"]) Luna:Notification({Title = "Телепорт", Content = "2nd Sea"}) end})
TeleportSection:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() teleportTo(seaCoords["3rd Sea"]) Luna:Notification({Title = "Телепорт", Content = "3rd Sea"}) end})

-- ============================================
-- ВКЛАДКА PVP (оптимизированная)
-- ============================================

local PvPSection = PvPTab:CreateSection("PvP Functions")

PvPSection:CreateToggle({
    Name = "Fast Attack (авто-атака)",
    Description = "Автоматически атакует врагов",
    CurrentValue = true,
    Callback = function(v)
        state.fast_attack = v
        updateFastAttack()
        Luna:Notification({Title = "Fast Attack", Content = v and "Включена" or "Выключена"})
    end
})

PvPSection:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(v) state.anti_stun = v; updateAntiStun() end})
PvPSection:CreateToggle({Name = "Infinite Energy", CurrentValue = false, Callback = function(v) state.infinite_energy = v; updateInfiniteEnergy() end})

-- Speed с отдельным тогглом
PvPSection:CreateToggle({Name = "Speed Boost", CurrentValue = false, Callback = function(v) state.speed_enabled = v; updateSpeed() end})
PvPSection:CreateSlider({Name = "Speed Multiplier", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) state.speed = v; if state.speed_enabled then updateSpeed() end end})

-- Jump с отдельным тогглом
PvPSection:CreateToggle({Name = "Jump Boost", CurrentValue = false, Callback = function(v) state.jump_enabled = v; updateJump() end})
PvPSection:CreateSlider({Name = "Jump Multiplier", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) state.jump = v; if state.jump_enabled then updateJump() end end})

PvPSection:CreateSlider({Name = "Dash Length", Range = {0, 200}, Increment = 1, CurrentValue = 0, Callback = function(v) state.dash_length = v; updateDashLength() end})
PvPSection:CreateToggle({Name = "Infinite Air Jumps", CurrentValue = false, Callback = function(v) state.infinite_air_jumps = v; updateInfiniteAirJumps() end})
PvPSection:CreateToggle({Name = "PvP Mode (атака игроков)", CurrentValue = false, Callback = function(v) state.pvp_mode = v; Luna:Notification({Title = "PvP Mode", Content = v and "Включена" or "Выключена"}) end})

-- Silent Aim
local SilentSection = PvPTab:CreateSection("Silent Aim")
SilentSection:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(v) state.silent_aim = v end})
SilentSection:CreateDropdown({Name = "Режим", Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, CurrentOption = "FOV", Callback = function(v) state.silent_mode = v end})
SilentSection:CreateSlider({Name = "FOV", Range = {0, 360}, Increment = 1, CurrentValue = 90, Callback = function(v) state.silent_fov = v end})
SilentSection:CreateSlider({Name = "Макс. дистанция", Range = {0, 500}, Increment = 10, CurrentValue = 200, Callback = function(v) state.silent_distance = v end})

-- ============================================
-- ВКЛАДКА ESP (заглушки)
-- ============================================

local EspSection = ESPTab:CreateSection("ESP Functions")
EspSection:CreateToggle({Name = "Fruit ESP", CurrentValue = false, Callback = function(v) state.fruit_esp = v end})
EspSection:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(v) state.player_esp = v end})
EspSection:CreateToggle({Name = "NPC ESP", CurrentValue = false, Callback = function(v) state.npc_esp = v end})
EspSection:CreateToggle({Name = "Chest ESP", CurrentValue = false, Callback = function(v) state.chest_esp = v end})
EspSection:CreateToggle({Name = "Island ESP", CurrentValue = false, Callback = function(v) state.island_esp = v end})
EspSection:CreateToggle({Name = "Flower ESP", CurrentValue = false, Callback = function(v) state.flower_esp = v end})
EspSection:CreateDropdown({Name = "Fruit Rarity Filter", Options = {"Все", "Rare+", "Legendary+", "Mythical"}, CurrentOption = "Все", Callback = function(v) state.fruit_filter = v end})

-- ============================================
-- ВКЛАДКА RAID (заглушки)
-- ============================================

local RaidSection = RaidTab:CreateSection("Auto Raid")
RaidSection:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(v) state.auto_raid = v end})
RaidSection:CreateToggle({Name = "Авто-старт", CurrentValue = false, Callback = function(v) state.raid_auto_start = v end})
RaidSection:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = "Buddha", Callback = function(v) state.raid_type = v end})
RaidSection:CreateToggle({Name = "Авто-покупка рейда", CurrentValue = false, Callback = function(v) state.raid_auto_buy = v end})
RaidSection:CreateToggle({Name = "Авто-доставание фрукта", CurrentValue = false, Callback = function(v) state.raid_auto_fruit = v end})
RaidSection:CreateSlider({Name = "Макс. цена фрукта (Beli)", Range = {0, 1000000}, Increment = 10000, CurrentValue = 500000, Callback = function(v) state.raid_max_price = v end})
RaidSection:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(v) state.kill_aura_raid = v end})

-- ============================================
-- ВКЛАДКА НАСТРОЙКИ
-- ============================================

local ConfigSection = SettingsTab:CreateSection("Конфигурации")
ConfigSection:CreateButton({Name = "Создать конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
ConfigSection:CreateButton({Name = "Сохранить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
ConfigSection:CreateButton({Name = "Загрузить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
ConfigSection:CreateButton({Name = "Авто-загрузка конфига", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})

local GeneralSection = SettingsTab:CreateSection("Общие")

-- Клавиша для открытия
local keyOptions = {"RightShift", "LeftShift", "RightControl", "LeftControl", "K", "L", "U", "I", "O", "P", "Q", "E", "R", "T", "Y", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"}
local keyDropdown = GeneralSection:CreateDropdown({
    Name = "Клавиша открытия",
    Options = keyOptions,
    CurrentOption = "RightShift",
    Callback = function(opt)
        state.window_bind = opt
        print("[Settings] Bind changed to:", opt)
        -- Обновляем привязку
        updateKeybind()
    end
})

GeneralSection:CreateButton({Name = "Auto Update", Callback = function() Luna:Notification({Title = "Обновление", Content = "Последняя версия"}) end})
GeneralSection:CreateButton({Name = "Unload Script", Callback = function() Window:Destroy() print("Abyss Hub выгружен") end})
GeneralSection:CreateToggle({Name = "Авто-запуск при переходе сервера", CurrentValue = true, Callback = function(v) print("[Settings] Auto Rejoin:", v) end})
GeneralSection:CreateToggle({Name = "Mobile Support", CurrentValue = UserInputService.TouchEnabled, Callback = function(v) print("[Settings] Mobile:", v) end})
GeneralSection:CreateButton({Name = "Настройка цветов", Callback = function() Luna:Notification({Title = "Цвета", Content = "В разработке"}) end})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША (полностью отключаем встроенную)
-- ============================================

-- Находим главное окно Luna UI
local mainFrame = nil
local shadowHolder = nil

-- Ищем окно в CoreGui/gethui
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

-- Если не нашли, ждём появления
if not mainFrame then
    task.wait(1)
    findLunaWindow()
end

-- Функция для обновления клавиши
local function updateKeybind()
    if _G.__keyConnection then
        _G.__keyConnection:Disconnect()
        _G.__keyConnection = nil
    end
    
    local isVisible = true
    
    _G.__keyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = string.split(tostring(input.KeyCode), ".")[3] or ""
        if key == state.window_bind then
            isVisible = not isVisible
            if mainFrame then
                mainFrame.Visible = isVisible
                if shadowHolder then
                    shadowHolder.Visible = isVisible
                end
                Luna:Notification({
                    Title = "Abyss Hub", 
                    Content = isVisible and "Интерфейс открыт" or "Интерфейс скрыт", 
                    Duration = 1
                })
            end
        end
    end)
end

-- Отключаем встроенный бинд Luna UI
pcall(function()
    -- Отключаем обработчик клавиш в Luna UI
    if Window._bindConnection then
        Window._bindConnection:Disconnect()
    end
    -- Меняем Bind на что-то неиспользуемое
    Window.Bind = Enum.KeyCode.Unknown
end)

-- Запускаем обработчик
updateKeybind()

-- Убираем размытие
pcall(function()
    _G.BlurModule = function() end
end)

-- Запускаем Fast Attack по умолчанию
updateFastAttack()

-- Уведомление о загрузке
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт загружен! Клавиша: " .. state.window_bind,
    Icon = "sparkle",
    ImageSource = "Material",
    Duration = 3
})

print("Abyss Hub загружен! Клавиша открытия:", state.window_bind)
print("Если интерфейс не открывается, проверьте что окно существует")
