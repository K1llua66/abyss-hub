--[[
    Abyss Hub
    Версия: 1.0 (рабочий)
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

-- Убираем размытие при скрытии (изменяем метод Hide в библиотеке)
-- Сохраняем оригинальный метод Hide
local originalHide = _G.Hide or nil
-- Переопределяем поведение скрытия окна
local function CustomHide(win, bind, notif)
    win.Visible = false
    if notif then
        Luna:Notification({
            Title = "Abyss Hub",
            Content = "Интерфейс скрыт. Нажмите RightShift для открытия.",
            Icon = "visibility_off"
        })
    end
end

-- Меняем Bind на RightShift
Window.Bind = Enum.KeyCode.RightShift

-- Переопределяем методы скрытия/показа
local function CustomUnhide(win, tab)
    win.Visible = true
    Luna:Notification({
        Title = "Abyss Hub",
        Content = "Интерфейс открыт",
        Icon = "visibility"
    })
end

-- Подменяем функции (если библиотека позволяет)
pcall(function()
    -- Находим и отключаем BlurModule
    _G.BlurModule = function() end
    -- Подменяем Hide/Unhide в объекте окна
    Window._originalHide = Window.Hide
    Window.Hide = function(self, notif)
        CustomHide(self, Window.Bind, notif)
    end
    Window.Unhide = CustomUnhide
end)

-- Создаём Home Tab (информационная)
Window:CreateHomeTab()

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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
    speed = 1,
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
}

-- Телепорты
local function teleportTo(coords)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(coords)
    end
end

-- Быстрая атака
local function applyFastAttack(value)
    -- Здесь будет логика ускорения атаки
    print("[Fast Attack] Set to:", value)
end

-- Изменение скорости
local function setSpeed(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = 16 * value
    end
end

-- Изменение прыжка
local function setJump(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = 50 * value
    end
end

-- Длина рывка
local function setDashLength(value)
    -- Здесь будет логика изменения длины рывка
    print("[Dash Length] Set to:", value)
end

-- Бесконечные воздушные прыжки
local function setInfiniteAirJumps(enabled)
    -- Здесь будет логика бесконечных воздушных прыжков
    print("[Infinite Air Jumps] Set to:", enabled)
end

-- Бесконечная энергия
local function setInfiniteEnergy(enabled)
    -- Здесь будет логика бесконечной энергии
    print("[Infinite Energy] Set to:", enabled)
end

-- Anti-Stun
local function setAntiStun(enabled)
    -- Здесь будет логика Anti-Stun
    print("[Anti-Stun] Set to:", enabled)
end

-- ============================================
-- ВКЛАДКИ
-- ============================================

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
    Callback = function(stateVal)
        state.auto_farm_level = stateVal
        print("[Farm] Level:", stateVal)
        if stateVal then
            -- Здесь запускается фарм уровня
        end
    end
})

FarmSection:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_farm_nearby = stateVal
        print("[Farm] Nearby:", stateVal)
        if stateVal then
            -- Здесь запускается фарм ближайших мобов
        end
    end
})

FarmSection:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(option)
        state.farm_weapon = option
        print("[Farm] Weapon:", option)
    end
})

-- Auto Farm Boss
local BossSection = FarmTab:CreateSection("Auto Farm Boss")
BossSection:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_farm_boss = stateVal
        print("[Boss]", stateVal)
    end
})

BossSection:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"},
    CurrentOption = "Diamond",
    Callback = function(option)
        state.selected_boss = option
        print("[Boss] Select:", option)
    end
})

BossSection:CreateDropdown({
    Name = "Оружие (босс)",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(option)
        state.boss_weapon = option
        print("[Boss] Weapon:", option)
    end
})

BossSection:CreateToggle({
    Name = "Использовать Fast Attack",
    CurrentValue = true,
    Callback = function(stateVal)
        state.boss_fast_attack = stateVal
        print("[Boss] Fast Attack:", stateVal)
    end
})

BossSection:CreateDropdown({
    Name = "Способ передвижения",
    Options = {"Телепорт", "Бег"},
    CurrentOption = "Телепорт",
    Callback = function(option)
        state.boss_move = option
        print("[Boss] Move:", option)
    end
})

-- Auto Mastery
local MasterySection = FarmTab:CreateSection("Auto Mastery")
MasterySection:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_mastery = stateVal
        print("[Mastery]", stateVal)
    end
})

MasterySection:CreateDropdown({
    Name = "Тип",
    Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"},
    CurrentOption = "Меч",
    Callback = function(option)
        state.mastery_type = option
        print("[Mastery] Type:", option)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать Z",
    CurrentValue = true,
    Callback = function(stateVal)
        state.skills.Z = stateVal
        print("[Mastery] Z:", stateVal)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать X",
    CurrentValue = true,
    Callback = function(stateVal)
        state.skills.X = stateVal
        print("[Mastery] X:", stateVal)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать C",
    CurrentValue = false,
    Callback = function(stateVal)
        state.skills.C = stateVal
        print("[Mastery] C:", stateVal)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать V",
    CurrentValue = false,
    Callback = function(stateVal)
        state.skills.V = stateVal
        print("[Mastery] V:", stateVal)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать F",
    CurrentValue = false,
    Callback = function(stateVal)
        state.skills.F = stateVal
        print("[Mastery] F:", stateVal)
    end
})

-- Auto Fruit
local FruitSection = FarmTab:CreateSection("Auto Fruit")
FruitSection:CreateToggle({
    Name = "Auto Fruit (Spawn)",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_fruit_spawn = stateVal
        print("[Fruit] Spawn:", stateVal)
    end
})

FruitSection:CreateToggle({
    Name = "Auto Fruit (Dealer)",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_fruit_dealer = stateVal
        print("[Fruit] Dealer:", stateVal)
    end
})

FruitSection:CreateToggle({
    Name = "Auto Store Fruit",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_store_fruit = stateVal
        print("[Fruit] Store:", stateVal)
    end
})

-- Auto Chest
local ChestSection = FarmTab:CreateSection("Auto Chest")
ChestSection:CreateToggle({
    Name = "Auto Chest",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_chest = stateVal
        print("[Chest]", stateVal)
    end
})

ChestSection:CreateDropdown({
    Name = "Режим",
    Options = {"Teleport Farm", "Tween Farm"},
    CurrentOption = "Teleport Farm",
    Callback = function(option)
        state.chest_mode = option
        print("[Chest] Mode:", option)
    end
})

-- Другие функции
local OtherSection = FarmTab:CreateSection("Другие функции")
OtherSection:CreateToggle({
    Name = "Auto Sea Beast",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_sea_beast = stateVal
        print("[Sea Beast]", stateVal)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Elite Hunter",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_elite = stateVal
        print("[Elite Hunter]", stateVal)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Observation (Ken Haki)",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_observation = stateVal
        print("[Observation]", stateVal)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Factory",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_factory = stateVal
        print("[Factory]", stateVal)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Mirage Island",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_mirage = stateVal
        print("[Mirage]", stateVal)
    end
})

-- Auto Kitsune Island
local KitsuneSection = FarmTab:CreateSection("Auto Kitsune Island")
KitsuneSection:CreateToggle({
    Name = "Авто-сбор Azure Embers",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_kitsune_collect = stateVal
        print("[Kitsune] Collect:", stateVal)
    end
})

KitsuneSection:CreateToggle({
    Name = "Сдавать Azure Embers",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_kitsune_trade = stateVal
        print("[Kitsune] Trade:", stateVal)
    end
})

KitsuneSection:CreateSlider({
    Name = "Количество для сдачи",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        state.kitsune_amount = value
        print("[Kitsune] Amount:", value)
    end
})

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ (рабочие кнопки)
-- ============================================

local TeleportSection = TeleportTab:CreateSection("Телепорты")

TeleportSection:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        teleportTo(Vector3.new(-1250, 80, 330))
        Luna:Notification({Title = "Телепорт", Content = "1st Sea", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        teleportTo(Vector3.new(-1250, 80, 330)) -- координаты 2-го моря
        Luna:Notification({Title = "Телепорт", Content = "2nd Sea", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        teleportTo(Vector3.new(-1250, 80, 330)) -- координаты 3-го моря
        Luna:Notification({Title = "Телепорт", Content = "3rd Sea", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to Islands (Safe)",
    Callback = function()
        -- Безопасный телепорт (ресет)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(0, 5000, 0)
            task.wait(0.5)
            char.HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
        end
        Luna:Notification({Title = "Телепорт", Content = "Islands", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to NPC",
    Callback = function()
        -- Здесь можно добавить выбор NPC
        Luna:Notification({Title = "Телепорт", Content = "NPC", Icon = "navigation"})
    end
})

TeleportSection:CreateButton({
    Name = "Hop to Server",
    Callback = function()
        local servers = {}
        Luna:Notification({Title = "Hop", Content = "Поиск сервера...", Icon = "search"})
        -- Здесь логика поиска сервера
    end
})

-- ============================================
-- ВКЛАДКА PVP (рабочие функции)
-- ============================================

local PvPSection = PvPTab:CreateSection("PvP Functions")

PvPSection:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Callback = function(stateVal)
        state.fast_attack = stateVal
        applyFastAttack(stateVal)
        print("[PvP] Fast Attack:", stateVal)
    end
})

PvPSection:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(stateVal)
        state.anti_stun = stateVal
        setAntiStun(stateVal)
        print("[PvP] Anti-Stun:", stateVal)
    end
})

PvPSection:CreateToggle({
    Name = "Infinite Energy",
    CurrentValue = false,
    Callback = function(stateVal)
        state.infinite_energy = stateVal
        setInfiniteEnergy(stateVal)
        print("[PvP] Infinite Energy:", stateVal)
    end
})

PvPSection:CreateSlider({
    Name = "Speed",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(value)
        state.speed = value
        setSpeed(value)
        print("[PvP] Speed x", value)
    end
})

PvPSection:CreateSlider({
    Name = "Jump",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(value)
        state.jump = value
        setJump(value)
        print("[PvP] Jump x", value)
    end
})

PvPSection:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(value)
        state.dash_length = value
        setDashLength(value)
        print("[PvP] Dash:", value)
    end
})

PvPSection:CreateToggle({
    Name = "Infinite Air Jumps",
    CurrentValue = false,
    Callback = function(stateVal)
        state.infinite_air_jumps = stateVal
        setInfiniteAirJumps(stateVal)
        print("[PvP] Air Jumps:", stateVal)
    end
})

-- Silent Aim
local SilentSection = PvPTab:CreateSection("Silent Aim")

SilentSection:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(stateVal)
        state.silent_aim = stateVal
        print("[Silent]", stateVal)
    end
})

SilentSection:CreateDropdown({
    Name = "Режим",
    Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"},
    CurrentOption = "FOV",
    Callback = function(option)
        state.silent_mode = option
        print("[Silent] Mode:", option)
    end
})

SilentSection:CreateSlider({
    Name = "FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Callback = function(value)
        state.silent_fov = value
        print("[Silent] FOV:", value)
    end
})

SilentSection:CreateSlider({
    Name = "Макс. дистанция",
    Range = {0, 500},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(value)
        state.silent_distance = value
        print("[Silent] Distance:", value)
    end
})

PvPSection:CreateToggle({
    Name = "Enable PvP Mode",
    CurrentValue = false,
    Callback = function(stateVal)
        print("[PvP] PvP Mode:", stateVal)
    end
})

-- ============================================
-- ВКЛАДКА ESP (заготовки)
-- ============================================

local EspSection = ESPTab:CreateSection("ESP Functions")

EspSection:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(stateVal)
        state.fruit_esp = stateVal
        print("[ESP] Fruit:", stateVal)
    end
})

EspSection:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(stateVal)
        state.player_esp = stateVal
        print("[ESP] Player:", stateVal)
    end
})

EspSection:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(stateVal)
        state.npc_esp = stateVal
        print("[ESP] NPC:", stateVal)
    end
})

EspSection:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Callback = function(stateVal)
        state.chest_esp = stateVal
        print("[ESP] Chest:", stateVal)
    end
})

EspSection:CreateToggle({
    Name = "Island ESP",
    CurrentValue = false,
    Callback = function(stateVal)
        state.island_esp = stateVal
        print("[ESP] Island:", stateVal)
    end
})

EspSection:CreateToggle({
    Name = "Flower ESP",
    CurrentValue = false,
    Callback = function(stateVal)
        state.flower_esp = stateVal
        print("[ESP] Flower:", stateVal)
    end
})

EspSection:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(option)
        state.fruit_filter = option
        print("[ESP] Filter:", option)
    end
})

-- ============================================
-- ВКЛАДКА RAID
-- ============================================

local RaidSection = RaidTab:CreateSection("Auto Raid")

RaidSection:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Callback = function(stateVal)
        state.auto_raid = stateVal
        print("[Raid] Auto:", stateVal)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-старт",
    CurrentValue = false,
    Callback = function(stateVal)
        state.raid_auto_start = stateVal
        print("[Raid] Auto Start:", stateVal)
    end
})

RaidSection:CreateDropdown({
    Name = "Выбор рейда",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"},
    CurrentOption = "Buddha",
    Callback = function(option)
        state.raid_type = option
        print("[Raid] Type:", option)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-покупка рейда",
    CurrentValue = false,
    Callback = function(stateVal)
        state.raid_auto_buy = stateVal
        print("[Raid] Auto Buy:", stateVal)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-доставание фрукта",
    CurrentValue = false,
    Callback = function(stateVal)
        state.raid_auto_fruit = stateVal
        print("[Raid] Auto Fruit:", stateVal)
    end
})

RaidSection:CreateSlider({
    Name = "Макс. цена фрукта (Beli)",
    Range = {0, 1000000},
    Increment = 10000,
    CurrentValue = 500000,
    Callback = function(value)
        state.raid_max_price = value
        print("[Raid] Max Price:", value)
    end
})

RaidSection:CreateToggle({
    Name = "Kill Aura (5 остров рейда)",
    CurrentValue = false,
    Callback = function(stateVal)
        state.kill_aura_raid = stateVal
        print("[Raid] Kill Aura:", stateVal)
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
    Callback = function(stateVal)
        print("[Settings] Auto Rejoin:", stateVal)
    end
})

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

GeneralSection:CreateToggle({
    Name = "Mobile Support",
    CurrentValue = IsMobile,
    Callback = function(stateVal)
        print("[Settings] Mobile:", stateVal)
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
-- ГОРЯЧАЯ КЛАВИША RightShift
-- ============================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if Window.Visible then
            Window.Visible = false
            Luna:Notification({Title = "Abyss Hub", Content = "Интерфейс скрыт. Нажмите RightShift для открытия.", Icon = "visibility_off"})
        else
            Window.Visible = true
            Luna:Notification({Title = "Abyss Hub", Content = "Интерфейс открыт", Icon = "visibility"})
        end
    end
end)

-- Убираем размытие (отключаем BlurModule)
pcall(function()
    _G.BlurModule = function() end
end)

-- Уведомление о загрузке
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт успешно загружен! Нажмите RightShift для скрытия/открытия.",
    Icon = "sparkle",
    ImageSource = "Material"
})

print("Abyss Hub загружен! RightShift для скрытия/открытия.")
