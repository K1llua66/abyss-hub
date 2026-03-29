--[[
    Abyss Hub
    Версия: 1.0 (рабочая)
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

-- Загрузка Starlight UI
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

if not Starlight then
    game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Starlight UI")
    return
end

-- Создание окна
local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Blox Fruits",
    Size = UDim2.new(0, 550, 0, 500),
    Theme = "Starlight",
    Minimizable = true
})

-- Создаём секцию вкладок (обязательно)
local MainSection = Window:CreateTabSection("Меню", true)

-- ============================================
-- ВКЛАДКА ФАРМ
-- ============================================
local FarmTab = MainSection:CreateTab({
    Name = "Фарм",
    Columns = 1,
    Icon = 6031097225  -- иконка по ID
}, "farm_tab")

-- Группа Auto Farm
local AutoFarmGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm",
    Column = 1,
    Style = 1
}, "autofarm_group")

AutoFarmGroup:CreateToggle({
    Name = "Auto Farm (Уровень)",
    CurrentValue = false,
    Callback = function(state)
        print("[Auto Farm] Уровень:", state)
    end
}, "farm_level")

AutoFarmGroup:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    CurrentValue = false,
    Callback = function(state)
        print("[Auto Farm] Ближайшие:", state)
    end
}, "farm_nearby")

AutoFarmGroup:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = {"Меч"},
    Callback = function(value)
        print("[Auto Farm] Оружие:", value[1])
    end
}, "farm_weapon")

-- Группа Auto Farm Boss
local BossGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm Boss",
    Column = 1,
    Style = 1
}, "boss_group")

BossGroup:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(state)
        print("[Auto Farm Boss]", state)
    end
}, "boss_toggle")

BossGroup:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral"},
    CurrentOption = {"Diamond"},
    Callback = function(value)
        print("[Auto Farm Boss] Босс:", value[1])
    end
}, "boss_select")

BossGroup:CreateDropdown({
    Name = "Способ передвижения",
    Options = {"Телепорт", "Бег"},
    CurrentOption = {"Телепорт"},
    Callback = function(value)
        print("[Auto Farm Boss] Способ:", value[1])
    end
}, "boss_move")

-- Группа Auto Mastery
local MasteryGroup = FarmTab:CreateGroupbox({
    Name = "Auto Mastery",
    Column = 1,
    Style = 1
}, "mastery_group")

MasteryGroup:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(state)
        print("[Auto Mastery]", state)
    end
}, "mastery_toggle")

MasteryGroup:CreateDropdown({
    Name = "Тип",
    Options = {"Фрукт", "Меч", "Ближний бой", "Оружие"},
    CurrentOption = {"Меч"},
    Callback = function(value)
        print("[Auto Mastery] Тип:", value[1])
    end
}, "mastery_type")

-- Группа Auto Fruit
local FruitGroup = FarmTab:CreateGroupbox({
    Name = "Auto Fruit",
    Column = 1,
    Style = 1
}, "fruit_group")

FruitGroup:CreateToggle({
    Name = "Auto Fruit (Spawn)",
    CurrentValue = false,
    Callback = function(state)
        print("[Auto Fruit] Сбор:", state)
    end
}, "fruit_spawn")

FruitGroup:CreateToggle({
    Name = "Auto Fruit (Dealer)",
    CurrentValue = false,
    Callback = function(state)
        print("[Auto Fruit] Покупка:", state)
    end
}, "fruit_dealer")

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================
local TeleportTab = MainSection:CreateTab({
    Name = "Телепорты",
    Columns = 1,
    Icon = 6031097225
}, "teleport_tab")

local TeleportGroup = TeleportTab:CreateGroupbox({
    Name = "Телепорты",
    Column = 1,
    Style = 1
}, "teleport_group")

TeleportGroup:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        print("[Teleport] 1st Sea")
    end
}, "t1")

TeleportGroup:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        print("[Teleport] 2nd Sea")
    end
}, "t2")

TeleportGroup:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        print("[Teleport] 3rd Sea")
    end
}, "t3")

-- ============================================
-- ВКЛАДКА PVP
-- ============================================
local PvPTab = MainSection:CreateTab({
    Name = "PvP",
    Columns = 1,
    Icon = 6031097225
}, "pvp_tab")

local PvPGroup = PvPTab:CreateGroupbox({
    Name = "PvP Functions",
    Column = 1,
    Style = 1
}, "pvp_group")

PvPGroup:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Callback = function(state)
        print("[PvP] Fast Attack:", state)
    end
}, "fast_attack")

PvPGroup:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(state)
        print("[PvP] Anti-Stun:", state)
    end
}, "anti_stun")

PvPGroup:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    CurrentValue = 0,
    Callback = function(value)
        print("[PvP] Dash Length:", value)
    end
}, "dash")

-- ============================================
-- ВКЛАДКА ESP
-- ============================================
local ESPTab = MainSection:CreateTab({
    Name = "ESP",
    Columns = 1,
    Icon = 6031097225
}, "esp_tab")

local ESPGroup = ESPTab:CreateGroupbox({
    Name = "ESP Functions",
    Column = 1,
    Style = 1
}, "esp_group")

ESPGroup:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Fruit ESP:", state)
    end
}, "fruit_esp")

ESPGroup:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        print("[ESP] Player ESP:", state)
    end
}, "player_esp")

-- ============================================
-- ВКЛАДКА RAID
-- ============================================
local RaidTab = MainSection:CreateTab({
    Name = "Raid",
    Columns = 1,
    Icon = 6031097225
}, "raid_tab")

local RaidGroup = RaidTab:CreateGroupbox({
    Name = "Auto Raid",
    Column = 1,
    Style = 1
}, "raid_group")

RaidGroup:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Callback = function(state)
        print("[Raid] Auto Raid:", state)
    end
}, "auto_raid")

RaidGroup:CreateToggle({
    Name = "Kill Aura (5 island)",
    CurrentValue = false,
    Callback = function(state)
        print("[Raid] Kill Aura:", state)
    end
}, "kill_aura")

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local SettingsTab = MainSection:CreateTab({
    Name = "Настройки",
    Columns = 1,
    Icon = 6031097225
}, "settings_tab")

local SettingsGroup = SettingsTab:CreateGroupbox({
    Name = "Settings",
    Column = 1,
    Style = 1
}, "settings_group")

SettingsGroup:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Window:Destroy()
    end
}, "unload")

-- Уведомление о загрузке
Window:Notify("Abyss Hub", "Скрипт успешно загружен!", 3)
print("Abyss Hub загружен!")
