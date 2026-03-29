--[[
    Abyss Hub
    Версия: 1.0
    Основа: Luna UI
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
    Callback = function(state)
        print("[Farm] Level:", state)
    end
})

FarmSection:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    CurrentValue = false,
    Callback = function(state)
        print("[Farm] Nearby:", state)
    end
})

FarmSection:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(option)
        print("[Farm] Weapon:", option)
    end
})

-- Auto Farm Boss
local BossSection = FarmTab:CreateSection("Auto Farm Boss")
BossSection:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(state)
        print("[Boss]", state)
    end
})

BossSection:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"},
    CurrentOption = "Diamond",
    Callback = function(option)
        print("[Boss] Select:", option)
    end
})

BossSection:CreateDropdown({
    Name = "Оружие (босс)",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(option)
        print("[Boss] Weapon:", option)
    end
})

BossSection:CreateToggle({
    Name = "Использовать Fast Attack",
    CurrentValue = true,
    Callback = function(state)
        print("[Boss] Fast Attack:", state)
    end
})

BossSection:CreateDropdown({
    Name = "Способ передвижения",
    Options = {"Телепорт", "Бег"},
    CurrentOption = "Телепорт",
    Callback = function(option)
        print("[Boss] Move:", option)
    end
})

-- Auto Mastery
local MasterySection = FarmTab:CreateSection("Auto Mastery")
MasterySection:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(state)
        print("[Mastery]", state)
    end
})

MasterySection:CreateDropdown({
    Name = "Тип",
    Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"},
    CurrentOption = "Меч",
    Callback = function(option)
        print("[Mastery] Type:", option)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать Z",
    CurrentValue = true,
    Callback = function(state)
        print("[Mastery] Z:", state)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать X",
    CurrentValue = true,
    Callback = function(state)
        print("[Mastery] X:", state)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать C",
    CurrentValue = false,
    Callback = function(state)
        print("[Mastery] C:", state)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать V",
    CurrentValue = false,
    Callback = function(state)
        print("[Mastery] V:", state)
    end
})

MasterySection:CreateToggle({
    Name = "Использовать F",
    CurrentValue = false,
    Callback = function(state)
        print("[Mastery] F:", state)
    end
})

-- Auto Fruit
local FruitSection = FarmTab:CreateSection("Auto Fruit")
FruitSection:CreateToggle({
    Name = "Auto Fruit (Spawn)",
    CurrentValue = false,
    Callback = function(state)
        print("[Fruit] Spawn:", state)
    end
})

FruitSection:CreateToggle({
    Name = "Auto Fruit (Dealer)",
    CurrentValue = false,
    Callback = function(state)
        print("[Fruit] Dealer:", state)
    end
})

FruitSection:CreateToggle({
    Name = "Auto Store Fruit",
    CurrentValue = false,
    Callback = function(state)
        print("[Fruit] Store:", state)
    end
})

-- Auto Chest
local ChestSection = FarmTab:CreateSection("Auto Chest")
ChestSection:CreateToggle({
    Name = "Auto Chest",
    CurrentValue = false,
    Callback = function(state)
        print("[Chest]", state)
    end
})

ChestSection:CreateDropdown({
    Name = "Режим",
    Options = {"Teleport Farm", "Tween Farm"},
    CurrentOption = "Teleport Farm",
    Callback = function(option)
        print("[Chest] Mode:", option)
    end
})

-- Другие функции
local OtherSection = FarmTab:CreateSection("Другие функции")
OtherSection:CreateToggle({
    Name = "Auto Sea Beast",
    CurrentValue = false,
    Callback = function(state)
        print("[Sea Beast]", state)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Elite Hunter",
    CurrentValue = false,
    Callback = function(state)
        print("[Elite Hunter]", state)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Observation (Ken Haki)",
    CurrentValue = false,
    Callback = function(state)
        print("[Observation]", state)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Factory",
    CurrentValue = false,
    Callback = function(state)
        print("[Factory]", state)
    end
})

OtherSection:CreateToggle({
    Name = "Auto Mirage Island",
    CurrentValue = false,
    Callback = function(state)
        print("[Mirage]", state)
    end
})

-- Auto Kitsune Island
local KitsuneSection = FarmTab:CreateSection("Auto Kitsune Island")
KitsuneSection:CreateToggle({
    Name = "Авто-сбор Azure Embers",
    CurrentValue = false,
    Callback = function(state)
        print("[Kitsune] Collect:", state)
    end
})

KitsuneSection:CreateToggle({
    Name = "Сдавать Azure Embers",
    CurrentValue = false,
    Callback = function(state)
        print("[Kitsune] Trade:", state)
    end
})

KitsuneSection:CreateSlider({
    Name = "Количество для сдачи",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(value)
        print("[Kitsune] Amount:", value)
    end
})

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================

local TeleportSection = TeleportTab:CreateSection("Телепорты")
TeleportSection:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        print("[Teleport] 1st Sea")
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        print("[Teleport] 2nd Sea")
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        print("[Teleport] 3rd Sea")
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to Islands (Safe)",
    Callback = function()
        print("[Teleport] Islands")
    end
})

TeleportSection:CreateButton({
    Name = "Teleport to NPC",
    Callback = function()
        print("[Teleport] NPC")
    end
})

TeleportSection:CreateButton({
    Name = "Hop to Server",
    Callback = function()
        print("[Teleport] Hop")
    end
})

-- ============================================
-- ВКЛАДКА PVP
-- ============================================

local PvPSection = PvPTab:CreateSection("PvP Functions")

PvPSection:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Callback = function(state)
        print("[PvP] Fast Attack:", state)
    end
})

PvPSection:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(state)
        print("[PvP] Anti-Stun:", state)
    end
})

PvPSection:CreateToggle({
    Name = "Infinite Energy",
    CurrentValue = false,
    Callback = function(state)
        print("[PvP] Infinite Energy:", state)
    end
})

PvPSection:CreateSlider({
    Name = "Speed",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(value)
        print("[PvP] Speed x", value)
    end
})

PvPSection:CreateSlider({
    Name = "Jump",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(value)
        print("[PvP] Jump x", value)
    end
})

PvPSection:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(value)
        print("[PvP] Dash:", value)
    end
})

PvPSection:CreateToggle({
    Name = "Infinite Air Jumps",
    CurrentValue = false,
    Callback = function(state)
        print("[PvP] Air Jumps:", state)
    end
})

-- Silent Aim
local SilentSection = PvPTab:CreateSection("Silent Aim")

SilentSection:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(state)
        print("[Silent]", state)
    end
})

SilentSection:CreateDropdown({
    Name = "Режим",
    Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"},
    CurrentOption = "FOV",
    Callback = function(option)
        print("[Silent] Mode:", option)
    end
})

SilentSection:CreateSlider({
    Name = "FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Callback = function(value)
        print("[Silent] FOV:", value)
    end
})

SilentSection:CreateSlider({
    Name = "Макс. дистанция",
    Range = {0, 500},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(value)
        print("[Silent] Distance:", value)
    end
})

PvPSection:CreateToggle({
    Name = "Enable PvP Mode",
    CurrentValue = false,
    Callback = function(state)
        print("[PvP] PvP Mode:", state)
    end
})

-- ============================================
-- ВКЛАДКА ESP
-- ============================================

local EspSection = ESPTab:CreateSection("ESP Functions")

EspSection:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Fruit:", state)
    end
})

EspSection:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Player:", state)
    end
})

EspSection:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] NPC:", state)
    end
})

EspSection:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Chest:", state)
    end
})

EspSection:CreateToggle({
    Name = "Island ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Island:", state)
    end
})

EspSection:CreateToggle({
    Name = "Flower ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Flower:", state)
    end
})

EspSection:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(option)
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
    Callback = function(state)
        print("[Raid] Auto:", state)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-старт",
    CurrentValue = false,
    Callback = function(state)
        print("[Raid] Auto Start:", state)
    end
})

RaidSection:CreateDropdown({
    Name = "Выбор рейда",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"},
    CurrentOption = "Buddha",
    Callback = function(option)
        print("[Raid] Type:", option)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-покупка рейда",
    CurrentValue = false,
    Callback = function(state)
        print("[Raid] Auto Buy:", state)
    end
})

RaidSection:CreateToggle({
    Name = "Авто-доставание фрукта",
    CurrentValue = false,
    Callback = function(state)
        print("[Raid] Auto Fruit:", state)
    end
})

RaidSection:CreateSlider({
    Name = "Макс. цена фрукта (Beli)",
    Range = {0, 1000000},
    Increment = 10000,
    CurrentValue = 500000,
    Callback = function(value)
        print("[Raid] Max Price:", value)
    end
})

RaidSection:CreateToggle({
    Name = "Kill Aura (5 остров рейда)",
    CurrentValue = false,
    Callback = function(state)
        print("[Raid] Kill Aura:", state)
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
    end
})

ConfigSection:CreateButton({
    Name = "Сохранить конфиг",
    Callback = function()
        print("[Config] Save")
    end
})

ConfigSection:CreateButton({
    Name = "Загрузить конфиг",
    Callback = function()
        print("[Config] Load")
    end
})

ConfigSection:CreateButton({
    Name = "Авто-загрузка конфига",
    Callback = function()
        print("[Config] Auto Load")
    end
})

local GeneralSection = SettingsTab:CreateSection("Общие")

GeneralSection:CreateButton({
    Name = "Auto Update",
    Callback = function()
        print("[Settings] Update")
    end
})

GeneralSection:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Window:Destroy()
    end
})

GeneralSection:CreateToggle({
    Name = "Авто-запуск при переходе сервера",
    CurrentValue = true,
    Callback = function(state)
        print("[Settings] Auto Rejoin:", state)
    end
})

-- Определяем мобильное устройство
local IsMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

GeneralSection:CreateToggle({
    Name = "Mobile Support",
    CurrentValue = IsMobile,
    Callback = function(state)
        print("[Settings] Mobile:", state)
    end
})

GeneralSection:CreateButton({
    Name = "Настройка цветов",
    Callback = function()
        print("[Settings] Colors")
    end
})

-- Уведомление
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт успешно загружен!",
    Icon = "sparkle",
    ImageSource = "Material"
})

print("Abyss Hub загружен!")
