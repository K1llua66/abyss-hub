--[[
    Abyss Hub
    Основа: Starlight Interface Suite
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

-- 🔧 ЗАГРУЗКА STARLIGHT UI (с альтернативными ссылками)
local Starlight = nil
local urls = {
    "https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/main/Source.lua",
    "https://raw.githubusercontent.com/Nebula-Softworks/Starlight-Interface-Suite/refs/heads/main/Source.lua",
}

for _, url in ipairs(urls) do
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        local func, err = loadstring(result)
        if func then
            Starlight = func()
            if Starlight then break end
        end
    end
    wait(0.5)
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

-- 📑 СОЗДАНИЕ ВКЛАДОК
local FarmTab = Window:CreateTab("Фарм", "⚔️")
local TeleportTab = Window:CreateTab("Телепорты", "🌀")
local PvPTab = Window:CreateTab("PvP", "⚡")
local ESPTab = Window:CreateTab("ESP", "👁️")
local RaidTab = Window:CreateTab("Raid", "🔥")
local SettingsTab = Window:CreateTab("Настройки", "⚙️")

-- ⚔️ ВКЛАДКА ФАРМ

-- Секция Auto Farm
local FarmSection = FarmTab:CreateSection("Auto Farm")
FarmSection:CreateToggle("Auto Farm (Уровень)", false, function(state)
    print("[Auto Farm] Уровень:", state)
end)

FarmSection:CreateToggle("Auto Farm (Ближайшие)", false, function(state)
    print("[Auto Farm] Ближайшие:", state)
end)

FarmSection:CreateDropdown("Оружие", {"Фрукт", "Меч", "Ближний бой"}, "Меч", function(value)
    print("[Auto Farm] Оружие:", value)
end)

-- Auto Farm Boss
local BossSection = FarmTab:CreateSection("Auto Farm Boss")
BossSection:CreateToggle("Auto Farm Boss", false, function(state)
    print("[Auto Farm Boss]", state)
end)

BossSection:CreateDropdown("Выбор босса", {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"}, "Diamond", function(value)
    print("[Auto Farm Boss] Босс:", value)
end)

BossSection:CreateDropdown("Оружие (босс)", {"Фрукт", "Меч", "Ближний бой"}, "Меч", function(value)
    print("[Auto Farm Boss] Оружие:", value)
end)

BossSection:CreateToggle("Использовать Fast Attack", true, function(state)
    print("[Auto Farm Boss] Fast Attack:", state)
end)

BossSection:CreateDropdown("Способ передвижения", {"Телепорт", "Бег"}, "Телепорт", function(value)
    print("[Auto Farm Boss] Способ:", value)
end)

-- Auto Mastery
local MasterySection = FarmTab:CreateSection("Auto Mastery")
MasterySection:CreateToggle("Auto Mastery", false, function(state)
    print("[Auto Mastery]", state)
end)

MasterySection:CreateDropdown("Тип", {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, "Меч", function(value)
    print("[Auto Mastery] Тип:", value)
end)

MasterySection:CreateToggle("Использовать Z", true, function(state)
    print("[Auto Mastery] Z skill:", state)
end)

MasterySection:CreateToggle("Использовать X", true, function(state)
    print("[Auto Mastery] X skill:", state)
end)

MasterySection:CreateToggle("Использовать C", false, function(state)
    print("[Auto Mastery] C skill:", state)
end)

MasterySection:CreateToggle("Использовать V", false, function(state)
    print("[Auto Mastery] V skill:", state)
end)

MasterySection:CreateToggle("Использовать F", false, function(state)
    print("[Auto Mastery] F skill:", state)
end)

-- Auto Fruit
local FruitSection = FarmTab:CreateSection("Auto Fruit")
FruitSection:CreateToggle("Auto Fruit (Spawn)", false, function(state)
    print("[Auto Fruit] Сбор на карте:", state)
end)

FruitSection:CreateToggle("Auto Fruit (Dealer)", false, function(state)
    print("[Auto Fruit] Покупка в магазине:", state)
end)

FruitSection:CreateToggle("Auto Store Fruit", false, function(state)
    print("[Auto Fruit] Сохранять в инвентарь:", state)
end)

-- Auto Chest
local ChestSection = FarmTab:CreateSection("Auto Chest")
ChestSection:CreateToggle("Auto Chest", false, function(state)
    print("[Auto Chest]", state)
end)

ChestSection:CreateDropdown("Режим", {"Teleport Farm", "Tween Farm"}, "Teleport Farm", function(value)
    print("[Auto Chest] Режим:", value)
end)

-- Остальные функции фарма
FarmTab:CreateToggle("Auto Sea Beast", false, function(state) print("[Auto Sea Beast]", state) end)
FarmTab:CreateToggle("Auto Elite Hunter", false, function(state) print("[Auto Elite Hunter]", state) end)
FarmTab:CreateToggle("Auto Observation (Ken Haki)", false, function(state) print("[Auto Observation]", state) end)
FarmTab:CreateToggle("Auto Factory", false, function(state) print("[Auto Factory]", state) end)
FarmTab:CreateToggle("Auto Mirage Island", false, function(state) print("[Auto Mirage Island]", state) end)

-- Auto Kitsune Island
local KitsuneSection = FarmTab:CreateSection("Auto Kitsune Island")
KitsuneSection:CreateToggle("Авто-сбор Azure Embers", false, function(state)
    print("[Kitsune] Сбор Azure Embers:", state)
end)

KitsuneSection:CreateToggle("Сдавать Azure Embers", false, function(state)
    print("[Kitsune] Сдача Azure Embers:", state)
end)

KitsuneSection:CreateSlider("Количество для сдачи", 0, 20, 10, function(value)
    print("[Kitsune] Сдавать при:", value)
end)

-- 🌀 ВКЛАДКА ТЕЛЕПОРТЫ

TeleportTab:CreateButton("Teleport to 1st Sea", function()
    print("[Teleport] 1st Sea")
end)

TeleportTab:CreateButton("Teleport to 2nd Sea", function()
    print("[Teleport] 2nd Sea")
end)

TeleportTab:CreateButton("Teleport to 3rd Sea", function()
    print("[Teleport] 3rd Sea")
end)

TeleportTab:CreateButton("Teleport to Islands (Safe)", function()
    print("[Teleport] Islands (ресет)")
end)

TeleportTab:CreateButton("Teleport to NPC", function()
    print("[Teleport] NPC")
end)

TeleportTab:CreateButton("Hop to Server", function()
    print("[Teleport] Hop to Server")
end)

-- ⚡ ВКЛАДКА PVP

PvPTab:CreateToggle("Fast Attack", true, function(state)
    print("[PvP] Fast Attack:", state)
end)

PvPTab:CreateToggle("Anti-Stun", false, function(state)
    print("[PvP] Anti-Stun:", state)
end)

PvPTab:CreateToggle("Infinite Energy", false, function(state)
    print("[PvP] Infinite Energy:", state)
end)

PvPTab:CreateSlider("Speed", 1, 10, 1, function(value)
    print("[PvP] Speed x", value)
end)

PvPTab:CreateSlider("Jump", 1, 10, 1, function(value)
    print("[PvP] Jump x", value)
end)

PvPTab:CreateSlider("Dash Length", 0, 200, 0, function(value)
    print("[PvP] Dash Length:", value)
end)

PvPTab:CreateToggle("Infinite Air Jumps", false, function(state)
    print("[PvP] Infinite Air Jumps:", state)
end)

-- Silent Aim секция
local SilentSection = PvPTab:CreateSection("Silent Aim")
SilentSection:CreateToggle("Silent Aim", false, function(state)
    print("[Silent Aim]", state)
end)

SilentSection:CreateDropdown("Режим", {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, "FOV", function(value)
    print("[Silent Aim] Режим:", value)
end)

SilentSection:CreateSlider("FOV", 0, 360, 90, function(value)
    print("[Silent Aim] FOV:", value)
end)

SilentSection:CreateSlider("Макс. дистанция", 0, 500, 200, function(value)
    print("[Silent Aim] Max Distance:", value)
end)

PvPTab:CreateToggle("Enable PvP Mode", false, function(state)
    print("[PvP] Enable PvP Mode:", state)
end)

-- 👁️ ВКЛАДКА ESP

ESPTab:CreateToggle("Fruit ESP", false, function(state)
    print("[ESP] Fruit ESP:", state)
end)

ESPTab:CreateToggle("Player ESP", false, function(state)
    print("[ESP] Player ESP:", state)
end)

ESPTab:CreateToggle("NPC ESP", false, function(state)
    print("[ESP] NPC ESP:", state)
end)

ESPTab:CreateToggle("Chest ESP", false, function(state)
    print("[ESP] Chest ESP:", state)
end)

ESPTab:CreateToggle("Island ESP", false, function(state)
    print("[ESP] Island ESP:", state)
end)

ESPTab:CreateToggle("Flower ESP", false, function(state)
    print("[ESP] Flower ESP:", state)
end)

ESPTab:CreateDropdown("Fruit Rarity Filter", {"Все", "Rare+", "Legendary+", "Mythical"}, "Все", function(value)
    print("[ESP] Fruit Filter:", value)
end)

-- 🔥 ВКЛАДКА RAID

local RaidSection = RaidTab:CreateSection("Auto Raid")
RaidSection:CreateToggle("Auto Raid", false, function(state)
    print("[Raid] Auto Raid:", state)
end)

RaidSection:CreateToggle("Авто-старт", false, function(state)
    print("[Raid] Auto Start:", state)
end)

RaidSection:CreateDropdown("Выбор рейда", {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, "Buddha", function(value)
    print("[Raid] Type:", value)
end)

RaidSection:CreateToggle("Авто-покупка рейда", false, function(state)
    print("[Raid] Auto Buy:", state)
end)

RaidSection:CreateToggle("Авто-доставание фрукта", false, function(state)
    print("[Raid] Auto Equip Fruit:", state)
end)

RaidSection:CreateSlider("Макс. цена фрукта (Beli)", 0, 1000000, 500000, function(value)
    print("[Raid] Max Fruit Price:", value)
end)

RaidTab:CreateToggle("Kill Aura (5 остров рейда)", false, function(state)
    print("[Raid] Kill Aura:", state)
end)

-- ⚙️ ВКЛАДКА НАСТРОЙКИ

-- Конфигурации
local ConfigSection = SettingsTab:CreateSection("Конфигурации")
ConfigSection:CreateButton("Создать конфиг", function()
    print("[Config] Create")
end)

ConfigSection:CreateButton("Сохранить конфиг", function()
    print("[Config] Save")
end)

ConfigSection:CreateButton("Загрузить конфиг", function()
    print("[Config] Load")
end)

ConfigSection:CreateButton("Авто-загрузка конфига", function()
    print("[Config] Auto Load")
end)

-- Общие настройки
SettingsTab:CreateButton("Auto Update", function()
    print("[Settings] Check Updates")
end)

SettingsTab:CreateButton("Unload Script", function()
    print("[Settings] Unloading...")
    Window:Destroy()
end)

SettingsTab:CreateToggle("Авто-запуск при переходе сервера", true, function(state)
    print("[Settings] Auto Rejoin:", state)
end)

-- Определяем мобильное устройство
local IsMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

SettingsTab:CreateToggle("Mobile Support", IsMobile, function(state)
    print("[Settings] Mobile Support:", state)
end)

SettingsTab:CreateSlider("UI Opacity", 0, 100, 85, function(value)
    Window:SetOpacity(value / 100)
end)

SettingsTab:CreateButton("Настройка цветов", function()
    print("[Settings] Color Settings (soon)")
end)

-- 🎉 ЗАВЕРШЕНИЕ
print("Abyss Hub загружен! (Blox Fruits)")
Window:Notify("Abyss Hub", "Скрипт успешно загружен!", 3)
