--[[
    Abyss Hub
    Версия: 1.0
]]

-- 🔍 ПРОВЕРКА ИГРЫ (все моря Blox Fruits)
local gameId = game.PlaceId
local validIds = {
    2753915549, -- 1st Sea
    4442272183, -- 2nd Sea
    7449423635, -- 3rd Sea
}

local isValid = false
for _, id in ipairs(validIds) do
    if gameId == id then
        isValid = true
        break
    end
end

if not isValid then
    game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub работает только в Blox Fruits!")
    return
end

-- 🔧 ЗАГРУЗКА STARLIGHT UI
local Starlight = nil
local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua")
end)

if success and result then
    local func, err = loadstring(result)
    if func then
        Starlight = func()
    else
        warn("Ошибка компиляции Starlight UI:", err)
    end
end

if not Starlight then
    game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Starlight UI. Проверьте интернет-соединение.")
    return
end

-- 🎨 СОЗДАНИЕ ГЛАВНОГО ОКНА
local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Blox Fruits | Starlight UI",
    Size = UDim2.new(0, 600, 0, 550),
    Theme = "Dark",
    Minimizable = true,
    Resizable = false
})

-- ⭐ СОЗДАНИЕ СЕКЦИИ ВКЛАДОК (ОБЯЗАТЕЛЬНО!)
local MainSection = Window:CreateTabSection("Главные вкладки", true)

-- 📑 СОЗДАНИЕ ВКЛАДОК
local FarmTab = MainSection:CreateTab({
    Name = "Фарм",
    Columns = 1,
    Icon = "⚔️"
}, "farm_tab")

local TeleportTab = MainSection:CreateTab({
    Name = "Телепорты",
    Columns = 1,
    Icon = "🌀"
}, "teleport_tab")

local PvPTab = MainSection:CreateTab({
    Name = "PvP",
    Columns = 1,
    Icon = "⚡"
}, "pvp_tab")

local ESPTab = MainSection:CreateTab({
    Name = "ESP",
    Columns = 1,
    Icon = "👁️"
}, "esp_tab")

local RaidTab = MainSection:CreateTab({
    Name = "Raid",
    Columns = 1,
    Icon = "🔥"
}, "raid_tab")

local SettingsTab = MainSection:CreateTab({
    Name = "Настройки",
    Columns = 1,
    Icon = "⚙️"
}, "settings_tab")

-- ============================================
-- ⚔️ ВКЛАДКА ФАРМ
-- ============================================

-- Auto Farm
local FarmGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm",
    Column = 1
}, "farm_group")

FarmGroup:CreateToggle("Auto Farm (Уровень)", false, function(state)
    print("[Auto Farm] Уровень:", state)
end)

FarmGroup:CreateToggle("Auto Farm (Ближайшие)", false, function(state)
    print("[Auto Farm] Ближайшие:", state)
end)

FarmGroup:CreateDropdown("Оружие", {"Фрукт", "Меч", "Ближний бой"}, "Меч", function(value)
    print("[Auto Farm] Оружие:", value)
end)

-- Auto Farm Boss
local BossGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm Boss",
    Column = 1
}, "boss_group")

BossGroup:CreateToggle("Auto Farm Boss", false, function(state)
    print("[Auto Farm Boss]", state)
end)

BossGroup:CreateDropdown("Выбор босса", {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"}, "Diamond", function(value)
    print("[Auto Farm Boss] Босс:", value)
end)

BossGroup:CreateDropdown("Оружие (босс)", {"Фрукт", "Меч", "Ближний бой"}, "Меч", function(value)
    print("[Auto Farm Boss] Оружие:", value)
end)

BossGroup:CreateToggle("Использовать Fast Attack", true, function(state)
    print("[Auto Farm Boss] Fast Attack:", state)
end)

BossGroup:CreateDropdown("Способ передвижения", {"Телепорт", "Бег"}, "Телепорт", function(value)
    print("[Auto Farm Boss] Способ:", value)
end)

-- Auto Mastery
local MasteryGroup = FarmTab:CreateGroupbox({
    Name = "Auto Mastery",
    Column = 1
}, "mastery_group")

MasteryGroup:CreateToggle("Auto Mastery", false, function(state)
    print("[Auto Mastery]", state)
end)

MasteryGroup:CreateDropdown("Тип", {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, "Меч", function(value)
    print("[Auto Mastery] Тип:", value)
end)

MasteryGroup:CreateToggle("Использовать Z", true, function(state)
    print("[Auto Mastery] Z skill:", state)
end)

MasteryGroup:CreateToggle("Использовать X", true, function(state)
    print("[Auto Mastery] X skill:", state)
end)

MasteryGroup:CreateToggle("Использовать C", false, function(state)
    print("[Auto Mastery] C skill:", state)
end)

MasteryGroup:CreateToggle("Использовать V", false, function(state)
    print("[Auto Mastery] V skill:", state)
end)

MasteryGroup:CreateToggle("Использовать F", false, function(state)
    print("[Auto Mastery] F skill:", state)
end)

-- Auto Fruit
local FruitGroup = FarmTab:CreateGroupbox({
    Name = "Auto Fruit",
    Column = 1
}, "fruit_group")

FruitGroup:CreateToggle("Auto Fruit (Spawn)", false, function(state)
    print("[Auto Fruit] Сбор на карте:", state)
end)

FruitGroup:CreateToggle("Auto Fruit (Dealer)", false, function(state)
    print("[Auto Fruit] Покупка в магазине:", state)
end)

FruitGroup:CreateToggle("Auto Store Fruit", false, function(state)
    print("[Auto Fruit] Сохранять в инвентарь:", state)
end)

-- Auto Chest
local ChestGroup = FarmTab:CreateGroupbox({
    Name = "Auto Chest",
    Column = 1
}, "chest_group")

ChestGroup:CreateToggle("Auto Chest", false, function(state)
    print("[Auto Chest]", state)
end)

ChestGroup:CreateDropdown("Режим", {"Teleport Farm", "Tween Farm"}, "Teleport Farm", function(value)
    print("[Auto Chest] Режим:", value)
end)

-- Остальные функции
local OtherGroup = FarmTab:CreateGroupbox({
    Name = "Другие функции",
    Column = 1
}, "other_group")

OtherGroup:CreateToggle("Auto Sea Beast", false, function(state) print("[Auto Sea Beast]", state) end)
OtherGroup:CreateToggle("Auto Elite Hunter", false, function(state) print("[Auto Elite Hunter]", state) end)
OtherGroup:CreateToggle("Auto Observation (Ken Haki)", false, function(state) print("[Auto Observation]", state) end)
OtherGroup:CreateToggle("Auto Factory", false, function(state) print("[Auto Factory]", state) end)
OtherGroup:CreateToggle("Auto Mirage Island", false, function(state) print("[Auto Mirage Island]", state) end)

-- Auto Kitsune Island
local KitsuneGroup = FarmTab:CreateGroupbox({
    Name = "Auto Kitsune Island",
    Column = 1
}, "kitsune_group")

KitsuneGroup:CreateToggle("Авто-сбор Azure Embers", false, function(state)
    print("[Kitsune] Сбор Azure Embers:", state)
end)

KitsuneGroup:CreateToggle("Сдавать Azure Embers", false, function(state)
    print("[Kitsune] Сдача Azure Embers:", state)
end)

KitsuneGroup:CreateSlider("Количество для сдачи", 0, 20, 10, function(value)
    print("[Kitsune] Сдавать при:", value)
end)

-- ============================================
-- 🌀 ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================

local TeleportGroup = TeleportTab:CreateGroupbox({
    Name = "Телепорты",
    Column = 1
}, "teleport_group")

TeleportGroup:CreateButton("Teleport to 1st Sea", function()
    print("[Teleport] 1st Sea")
end)

TeleportGroup:CreateButton("Teleport to 2nd Sea", function()
    print("[Teleport] 2nd Sea")
end)

TeleportGroup:CreateButton("Teleport to 3rd Sea", function()
    print("[Teleport] 3rd Sea")
end)

TeleportGroup:CreateButton("Teleport to Islands (Safe)", function()
    print("[Teleport] Islands (ресет)")
end)

TeleportGroup:CreateButton("Teleport to NPC", function()
    print("[Teleport] NPC")
end)

TeleportGroup:CreateButton("Hop to Server", function()
    print("[Teleport] Hop to Server")
end)

-- ============================================
-- ⚡ ВКЛАДКА PVP
-- ============================================

local PvPGroup = PvPTab:CreateGroupbox({
    Name = "PvP Функции",
    Column = 1
}, "pvp_group")

PvPGroup:CreateToggle("Fast Attack", true, function(state)
    print("[PvP] Fast Attack:", state)
end)

PvPGroup:CreateToggle("Anti-Stun", false, function(state)
    print("[PvP] Anti-Stun:", state)
end)

PvPGroup:CreateToggle("Infinite Energy", false, function(state)
    print("[PvP] Infinite Energy:", state)
end)

PvPGroup:CreateSlider("Speed", 1, 10, 1, function(value)
    print("[PvP] Speed x", value)
end)

PvPGroup:CreateSlider("Jump", 1, 10, 1, function(value)
    print("[PvP] Jump x", value)
end)

PvPGroup:CreateSlider("Dash Length", 0, 200, 0, function(value)
    print("[PvP] Dash Length:", value)
end)

PvPGroup:CreateToggle("Infinite Air Jumps", false, function(state)
    print("[PvP] Infinite Air Jumps:", state)
end)

-- Silent Aim
local SilentGroup = PvPTab:CreateGroupbox({
    Name = "Silent Aim",
    Column = 1
}, "silent_group")

SilentGroup:CreateToggle("Silent Aim", false, function(state)
    print("[Silent Aim]", state)
end)

SilentGroup:CreateDropdown("Режим", {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, "FOV", function(value)
    print("[Silent Aim] Режим:", value)
end)

SilentGroup:CreateSlider("FOV", 0, 360, 90, function(value)
    print("[Silent Aim] FOV:", value)
end)

SilentGroup:CreateSlider("Макс. дистанция", 0, 500, 200, function(value)
    print("[Silent Aim] Max Distance:", value)
end)

PvPGroup:CreateToggle("Enable PvP Mode", false, function(state)
    print("[PvP] Enable PvP Mode:", state)
end)

-- ============================================
-- 👁️ ВКЛАДКА ESP
-- ============================================

local EspGroup = ESPTab:CreateGroupbox({
    Name = "ESP Функции",
    Column = 1
}, "esp_group")

EspGroup:CreateToggle("Fruit ESP", false, function(state)
    print("[ESP] Fruit ESP:", state)
end)

EspGroup:CreateToggle("Player ESP", false, function(state)
    print("[ESP] Player ESP:", state)
end)

EspGroup:CreateToggle("NPC ESP", false, function(state)
    print("[ESP] NPC ESP:", state)
end)

EspGroup:CreateToggle("Chest ESP", false, function(state)
    print("[ESP] Chest ESP:", state)
end)

EspGroup:CreateToggle("Island ESP", false, function(state)
    print("[ESP] Island ESP:", state)
end)

EspGroup:CreateToggle("Flower ESP", false, function(state)
    print("[ESP] Flower ESP:", state)
end)

EspGroup:CreateDropdown("Fruit Rarity Filter", {"Все", "Rare+", "Legendary+", "Mythical"}, "Все", function(value)
    print("[ESP] Fruit Filter:", value)
end)

-- ============================================
-- 🔥 ВКЛАДКА RAID
-- ============================================

local RaidGroup = RaidTab:CreateGroupbox({
    Name = "Auto Raid",
    Column = 1
}, "raid_group")

RaidGroup:CreateToggle("Auto Raid", false, function(state)
    print("[Raid] Auto Raid:", state)
end)

RaidGroup:CreateToggle("Авто-старт", false, function(state)
    print("[Raid] Auto Start:", state)
end)

RaidGroup:CreateDropdown("Выбор рейда", {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, "Buddha", function(value)
    print("[Raid] Type:", value)
end)

RaidGroup:CreateToggle("Авто-покупка рейда", false, function(state)
    print("[Raid] Auto Buy:", state)
end)

RaidGroup:CreateToggle("Авто-доставание фрукта", false, function(state)
    print("[Raid] Auto Equip Fruit:", state)
end)

RaidGroup:CreateSlider("Макс. цена фрукта (Beli)", 0, 1000000, 500000, function(value)
    print("[Raid] Max Fruit Price:", value)
end)

RaidTab:CreateToggle("Kill Aura (5 остров рейда)", false, function(state)
    print("[Raid] Kill Aura:", state)
end)

-- ============================================
-- ⚙️ ВКЛАДКА НАСТРОЙКИ
-- ============================================

local ConfigGroup = SettingsTab:CreateGroupbox({
    Name = "Конфигурации",
    Column = 1
}, "config_group")

ConfigGroup:CreateButton("Создать конфиг", function()
    print("[Config] Create")
end)

ConfigGroup:CreateButton("Сохранить конфиг", function()
    print("[Config] Save")
end)

ConfigGroup:CreateButton("Загрузить конфиг", function()
    print("[Config] Load")
end)

ConfigGroup:CreateButton("Авто-загрузка конфига", function()
    print("[Config] Auto Load")
end)

local SettingsGroup = SettingsTab:CreateGroupbox({
    Name = "Общие настройки",
    Column = 1
}, "settings_group")

SettingsGroup:CreateButton("Auto Update", function()
    print("[Settings] Check Updates")
end)

SettingsGroup:CreateButton("Unload Script", function()
    print("[Settings] Unloading...")
    Window:Destroy()
end)

SettingsGroup:CreateToggle("Авто-запуск при переходе сервера", true, function(state)
    print("[Settings] Auto Rejoin:", state)
end)

local IsMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

SettingsGroup:CreateToggle("Mobile Support", IsMobile, function(state)
    print("[Settings] Mobile Support:", state)
end)

SettingsGroup:CreateSlider("UI Opacity", 0, 100, 85, function(value)
    -- Starlight UI не имеет стандартной функции SetOpacity, пока оставим
    print("[Settings] Opacity:", value)
end)

SettingsGroup:CreateButton("Настройка цветов", function()
    print("[Settings] Color Settings (soon)")
end)

-- ============================================
-- 🎉 ЗАВЕРШЕНИЕ
-- ============================================

print("Abyss Hub загружен! (Blox Fruits)")
Window:Notify("Abyss Hub", "Скрипт успешно загружен!", 3)
