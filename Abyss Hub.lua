--[[
    Abyss Hub
    Версия: 1.0 (упрощённая)
]]

-- 🔍 ПРОВЕРКА ИГРЫ
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

-- 🔧 ЗАГРУЗКА STARLIGHT UI
local Starlight = nil
local success, result = pcall(function()
    return game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua")
end)

if success and result then
    local func, err = loadstring(result)
    if func then Starlight = func() end
end

if not Starlight then
    game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Starlight UI.")
    return
end

-- 🎨 СОЗДАНИЕ ОКНА
local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Blox Fruits",
    Size = UDim2.new(0, 550, 0, 500),
    Theme = "Dark",
    Minimizable = true,
    Resizable = false
})

-- 📑 СОЗДАНИЕ СЕКЦИИ И ВКЛАДОК
local MainSection = Window:CreateTabSection("Меню", true)

-- Вкладка Фарм
local FarmTab = MainSection:CreateTab({
    Name = "Фарм",
    Columns = 1,
    Icon = "⚔️"
}, "farm")

-- Вкладка Телепорты
local TeleportTab = MainSection:CreateTab({
    Name = "Телепорты",
    Columns = 1,
    Icon = "🌀"
}, "teleport")

-- Вкладка PvP
local PvPTab = MainSection:CreateTab({
    Name = "PvP",
    Columns = 1,
    Icon = "⚡"
}, "pvp")

-- Вкладка ESP
local ESPTab = MainSection:CreateTab({
    Name = "ESP",
    Columns = 1,
    Icon = "👁️"
}, "esp")

-- Вкладка Raid
local RaidTab = MainSection:CreateTab({
    Name = "Raid",
    Columns = 1,
    Icon = "🔥"
}, "raid")

-- Вкладка Настройки
local SettingsTab = MainSection:CreateTab({
    Name = "Настройки",
    Columns = 1,
    Icon = "⚙️"
}, "settings")

-- ============================================
-- ФАРМ
-- ============================================

-- Создаём группу
local FarmGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm",
    Column = 1,
    Style = 1
}, "farm_group")

-- Добавляем элементы (используем правильный API)
FarmGroup:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked!")
    end
}, "test_btn")

FarmGroup:CreateToggle({
    Name = "Auto Farm (Level)",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Farm Level:", state)
    end
}, "farm_level")

FarmGroup:CreateToggle({
    Name = "Auto Farm (Nearby)",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Farm Nearby:", state)
    end
}, "farm_nearby")

FarmGroup:CreateDropdown({
    Name = "Weapon",
    Options = {"Fruit", "Sword", "Melee"},
    CurrentOption = {"Sword"},
    Callback = function(value)
        print("Weapon:", value[1])
    end
}, "weapon")

-- Auto Farm Boss
local BossGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm Boss",
    Column = 1,
    Style = 1
}, "boss_group")

BossGroup:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Farm Boss:", state)
    end
}, "boss_toggle")

BossGroup:CreateDropdown({
    Name = "Select Boss",
    Options = {"Diamond", "Thunder God", "Vice Admiral"},
    CurrentOption = {"Diamond"},
    Callback = function(value)
        print("Boss:", value[1])
    end
}, "boss_select")

-- Auto Mastery
local MasteryGroup = FarmTab:CreateGroupbox({
    Name = "Auto Mastery",
    Column = 1,
    Style = 1
}, "mastery_group")

MasteryGroup:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Mastery:", state)
    end
}, "mastery_toggle")

MasteryGroup:CreateDropdown({
    Name = "Type",
    Options = {"Fruit", "Sword", "Melee", "Gun"},
    CurrentOption = {"Sword"},
    Callback = function(value)
        print("Mastery Type:", value[1])
    end
}, "mastery_type")

-- ============================================
-- ТЕЛЕПОРТЫ
-- ============================================

local TeleportGroup = TeleportTab:CreateGroupbox({
    Name = "Teleports",
    Column = 1,
    Style = 1
}, "teleport_group")

TeleportGroup:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        print("Teleport to 1st Sea")
    end
}, "t1")

TeleportGroup:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        print("Teleport to 2nd Sea")
    end
}, "t2")

TeleportGroup:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        print("Teleport to 3rd Sea")
    end
}, "t3")

TeleportGroup:CreateButton({
    Name = "Teleport to Islands",
    Callback = function()
        print("Teleport to Islands")
    end
}, "islands")

-- ============================================
-- PVP
-- ============================================

local PvPGroup = PvPTab:CreateGroupbox({
    Name = "PvP Functions",
    Column = 1,
    Style = 1
}, "pvp_group")

PvPGroup:CreateToggle({
    Name = "Fast Attack",
    CurrentValue = true,
    Callback = function(state)
        print("Fast Attack:", state)
    end
}, "fast_attack")

PvPGroup:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(state)
        print("Anti-Stun:", state)
    end
}, "anti_stun")

PvPGroup:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    CurrentValue = 0,
    Callback = function(value)
        print("Dash Length:", value)
    end
}, "dash")

PvPGroup:CreateToggle({
    Name = "Infinite Air Jumps",
    CurrentValue = false,
    Callback = function(state)
        print("Infinite Air Jumps:", state)
    end
}, "air_jumps")

-- ============================================
-- ESP
-- ============================================

local EspGroup = ESPTab:CreateGroupbox({
    Name = "ESP Functions",
    Column = 1,
    Style = 1
}, "esp_group")

EspGroup:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(state)
        print("Fruit ESP:", state)
    end
}, "fruit_esp")

EspGroup:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(state)
        print("Player ESP:", state)
    end
}, "player_esp")

EspGroup:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(state)
        print("NPC ESP:", state)
    end
}, "npc_esp")

-- ============================================
-- RAID
-- ============================================

local RaidGroup = RaidTab:CreateGroupbox({
    Name = "Auto Raid",
    Column = 1,
    Style = 1
}, "raid_group")

RaidGroup:CreateToggle({
    Name = "Auto Raid",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Raid:", state)
    end
}, "auto_raid")

RaidGroup:CreateDropdown({
    Name = "Raid Type",
    Options = {"Flame", "Ice", "Buddha", "Dough"},
    CurrentOption = {"Buddha"},
    Callback = function(value)
        print("Raid Type:", value[1])
    end
}, "raid_type")

RaidGroup:CreateToggle({
    Name = "Auto Buy Raid",
    CurrentValue = false,
    Callback = function(state)
        print("Auto Buy Raid:", state)
    end
}, "auto_buy")

RaidTab:CreateToggle({
    Name = "Kill Aura (Raid Island 5)",
    CurrentValue = false,
    Callback = function(state)
        print("Kill Aura Raid:", state)
    end
}, "kill_aura")

-- ============================================
-- НАСТРОЙКИ
-- ============================================

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

SettingsGroup:CreateToggle({
    Name = "Auto Rejoin",
    CurrentValue = true,
    Callback = function(state)
        print("Auto Rejoin:", state)
    end
}, "auto_rejoin")

-- Уведомление
Window:Notify("Abyss Hub", "Скрипт загружен!", 3)
print("Abyss Hub загружен!")
