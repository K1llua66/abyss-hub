--[[
    Abyss Hub
    Версия: 1.0 (Rayfield)
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

-- Загрузка Rayfield
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "Abyss Hub",
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "Blox Fruits",
    Theme = "Dark",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- ============================================
-- ВКЛАДКИ
-- ============================================
local FarmTab = Window:CreateTab("⚔️ Фарм")
local TeleportTab = Window:CreateTab("🌀 Телепорты")
local PvPTab = Window:CreateTab("⚡ PvP")
local ESPTab = Window:CreateTab("👁️ ESP")
local RaidTab = Window:CreateTab("🔥 Raid")
local SettingsTab = Window:CreateTab("⚙️ Настройки")

-- ============================================
-- ФАРМ
-- ============================================

FarmTab:CreateSection("Auto Farm")

FarmTab:CreateToggle({
    Name = "Auto Farm (Уровень)",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Farm] Уровень:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Farm] Ближайшие:", Value)
    end
})

FarmTab:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = {"Меч"},
    Callback = function(Option)
        print("[Auto Farm] Оружие:", Option)
    end
})

FarmTab:CreateSection("Auto Farm Boss")

FarmTab:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Farm Boss]", Value)
    end
})

FarmTab:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"},
    CurrentOption = {"Diamond"},
    Callback = function(Option)
        print("[Auto Farm Boss] Босс:", Option)
    end
})

FarmTab:CreateDropdown({
    Name = "Оружие (босс)",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = {"Меч"},
    Callback = function(Option)
        print("[Auto Farm Boss] Оружие:", Option)
    end
})

FarmTab:CreateToggle({
    Name = "Использовать Fast Attack",
    CurrentValue = true,
    Callback = function(Value)
        print("[Auto Farm Boss] Fast Attack:", Value)
    end
})

FarmTab:CreateDropdown({
    Name = "Способ передвижения",
    Options = {"Телепорт", "Бег"},
    CurrentOption = {"Телепорт"},
    Callback = function(Option)
        print("[Auto Farm Boss] Способ:", Option)
    end
})

FarmTab:CreateSection("Auto Mastery")

FarmTab:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Mastery]", Value)
    end
})

FarmTab:CreateDropdown({
    Name = "Тип",
    Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"},
    CurrentOption = {"Меч"},
    Callback = function(Option)
        print("[Auto Mastery] Тип:", Option)
    end
})

FarmTab:CreateToggle({
    Name = "Использовать Z",
    CurrentValue = true,
    Callback = function(Value)
        print("[Mastery] Z skill:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Использовать X",
    CurrentValue = true,
    Callback = function(Value)
        print("[Mastery] X skill:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Использовать C",
    CurrentValue = false,
    Callback = function(Value)
        print("[Mastery] C skill:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Использовать V",
    CurrentValue = false,
    Callback = function(Value)
        print("[Mastery] V skill:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Использовать F",
    CurrentValue = false,
    Callback = function(Value)
        print("[Mastery] F skill:", Value)
    end
})

FarmTab:CreateSection("Auto Fruit")

FarmTab:CreateToggle({
    Name = "Auto Fruit (Spawn)",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Fruit] Сбор на карте:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Fruit (Dealer)",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Fruit] Покупка:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Store Fruit",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Fruit] Сохранять:", Value)
    end
})

FarmTab:CreateSection("Auto Chest")

FarmTab:CreateToggle({
    Name = "Auto Chest",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Chest]", Value)
    end
})

FarmTab:CreateDropdown({
    Name = "Режим",
    Options = {"Teleport Farm", "Tween Farm"},
    CurrentOption = {"Teleport Farm"},
    Callback = function(Option)
        print("[Auto Chest] Режим:", Option)
    end
})

FarmTab:CreateSection("Другие функции")

FarmTab:CreateToggle({
    Name = "Auto Sea Beast",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Sea Beast]", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Elite Hunter",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Elite Hunter]", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Observation (Ken Haki)",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Observation]", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Factory",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Factory]", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Auto Mirage Island",
    CurrentValue = false,
    Callback = function(Value)
        print("[Auto Mirage Island]", Value)
    end
})

FarmTab:CreateSection("Auto Kitsune Island")

FarmTab:CreateToggle({
    Name = "Авто-сбор Azure Embers",
    CurrentValue = false,
    Callback = function(Value)
        print("[Kitsune] Сбор Azure Embers:", Value)
    end
})

FarmTab:CreateToggle({
    Name = "Сдавать Azure Embers",
    CurrentValue = false,
    Callback = function(Value)
        print("[Kitsune] Сдача Azure Embers:", Value)
    end
})

FarmTab:CreateSlider({
    Name = "Количество для сдачи",
    Range = {0, 20},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        print("[Kitsune] Сдавать при:", Value)
    end
})

-- ============================================
-- ТЕЛЕПОРТЫ
-- ============================================

TeleportTab:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        print("[Teleport] 1st Sea")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        print("[Teleport] 2nd Sea")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        print("[Teleport] 3rd Sea")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Islands (Safe)",
    Callback = function()
        print("[Teleport] Islands")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to NPC",
    Callback = function()
        print("[Teleport] NPC")
    end
})

TeleportTab:CreateButton({
    Name = "Hop to Server",
    Callback = function()
        print("[Teleport] Hop")
    end
})

-- ============================================
-- PVP
-- ============================================

PvPTab:CreateSection("PvP Functions")

PvPTab:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Callback = function(Value)
        print("[PvP] Fast Attack:", Value)
    end
})

PvPTab:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(Value)
        print("[PvP] Anti-Stun:", Value)
    end
})

PvPTab:CreateToggle({
    Name = "Infinite Energy",
    CurrentValue = false,
    Callback = function(Value)
        print("[PvP] Infinite Energy:", Value)
    end
})

PvPTab:CreateSlider({
    Name = "Speed",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        print("[PvP] Speed x", Value)
    end
})

PvPTab:CreateSlider({
    Name = "Jump",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        print("[PvP] Jump x", Value)
    end
})

PvPTab:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    Increment = 1,
    CurrentValue = 0,
    Callback = function(Value)
        print("[PvP] Dash Length:", Value)
    end
})

PvPTab:CreateToggle({
    Name = "Infinite Air Jumps",
    CurrentValue = false,
    Callback = function(Value)
        print("[PvP] Air Jumps:", Value)
    end
})

PvPTab:CreateSection("Silent Aim")

PvPTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Callback = function(Value)
        print("[Silent Aim]", Value)
    end
})

PvPTab:CreateDropdown({
    Name = "Режим",
    Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"},
    CurrentOption = {"FOV"},
    Callback = function(Option)
        print("[Silent Aim] Режим:", Option)
    end
})

PvPTab:CreateSlider({
    Name = "FOV",
    Range = {0, 360},
    Increment = 1,
    CurrentValue = 90,
    Callback = function(Value)
        print("[Silent Aim] FOV:", Value)
    end
})

PvPTab:CreateSlider({
    Name = "Макс. дистанция",
    Range = {0, 500},
    Increment = 10,
    CurrentValue = 200,
    Callback = function(Value)
        print("[Silent Aim] Max Distance:", Value)
    end
})

PvPTab:CreateToggle({
    Name = "Enable PvP Mode",
    CurrentValue = false,
    Callback = function(Value)
        print("[PvP] PvP Mode:", Value)
    end
})

-- ============================================
-- ESP
-- ============================================

ESPTab:CreateSection("ESP Functions")

ESPTab:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(Value)
        print("[ESP] Fruit ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        print("[ESP] Player ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(Value)
        print("[ESP] NPC ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Callback = function(Value)
        print("[ESP] Chest ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Island ESP",
    CurrentValue = false,
    Callback = function(Value)
        print("[ESP] Island ESP:", Value)
    end
})

ESPTab:CreateToggle({
    Name = "Flower ESP",
    CurrentValue = false,
    Callback = function(Value)
        print("[ESP] Flower ESP:", Value)
    end
})

ESPTab:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = {"Все"},
    Callback = function(Option)
        print("[ESP] Fruit Filter:", Option)
    end
})

-- ============================================
-- RAID
-- ============================================

RaidTab:CreateSection("Auto Raid")

RaidTab:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Callback = function(Value)
        print("[Raid] Auto Raid:", Value)
    end
})

RaidTab:CreateToggle({
    Name = "Авто-старт",
    CurrentValue = false,
    Callback = function(Value)
        print("[Raid] Auto Start:", Value)
    end
})

RaidTab:CreateDropdown({
    Name = "Выбор рейда",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"},
    CurrentOption = {"Buddha"},
    Callback = function(Option)
        print("[Raid] Type:", Option)
    end
})

RaidTab:CreateToggle({
    Name = "Авто-покупка рейда",
    CurrentValue = false,
    Callback = function(Value)
        print("[Raid] Auto Buy:", Value)
    end
})

RaidTab:CreateToggle({
    Name = "Авто-доставание фрукта",
    CurrentValue = false,
    Callback = function(Value)
        print("[Raid] Auto Equip:", Value)
    end
})

RaidTab:CreateSlider({
    Name = "Макс. цена фрукта (Beli)",
    Range = {0, 1000000},
    Increment = 10000,
    CurrentValue = 500000,
    Callback = function(Value)
        print("[Raid] Max Price:", Value)
    end
})

RaidTab:CreateToggle({
    Name = "Kill Aura (5 остров рейда)",
    CurrentValue = false,
    Callback = function(Value)
        print("[Raid] Kill Aura:", Value)
    end
})

-- ============================================
-- НАСТРОЙКИ
-- ============================================

SettingsTab:CreateSection("Конфигурации")

SettingsTab:CreateButton({
    Name = "Создать конфиг",
    Callback = function()
        print("[Config] Create")
    end
})

SettingsTab:CreateButton({
    Name = "Сохранить конфиг",
    Callback = function()
        print("[Config] Save")
    end
})

SettingsTab:CreateButton({
    Name = "Загрузить конфиг",
    Callback = function()
        print("[Config] Load")
    end
})

SettingsTab:CreateButton({
    Name = "Авто-загрузка конфига",
    Callback = function()
        print("[Config] Auto Load")
    end
})

SettingsTab:CreateSection("Общие")

SettingsTab:CreateButton({
    Name = "Auto Update",
    Callback = function()
        print("[Settings] Update")
    end
})

SettingsTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Window:Destroy()
    end
})

SettingsTab:CreateToggle({
    Name = "Авто-запуск при переходе сервера",
    CurrentValue = true,
    Callback = function(Value)
        print("[Settings] Auto Rejoin:", Value)
    end
})

local IsMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled

SettingsTab:CreateToggle({
    Name = "Mobile Support",
    CurrentValue = IsMobile,
    Callback = function(Value)
        print("[Settings] Mobile:", Value)
    end
})

SettingsTab:CreateButton({
    Name = "Настройка цветов",
    Callback = function()
        print("[Settings] Colors")
    end
})

-- Уведомление
Rayfield:Notify({
    Title = "Abyss Hub",
    Content = "Скрипт успешно загружен!",
    Duration = 3
})

print("Abyss Hub загружен!")
