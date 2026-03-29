-- Загрузка Starlight
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

-- Создание окна
local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Blox Fruits",
    Size = UDim2.new(0, 550, 0, 500),
    Theme = "Starlight"
})

-- СОЗДАНИЕ СЕКЦИИ ВКЛАДОК (обязательно)
local MainSection = Window:CreateTabSection("Главная", true)

-- СОЗДАНИЕ ВКЛАДОК через секцию
local FarmTab = MainSection:CreateTab({
    Name = "Фарм",
    Columns = 1,
    Icon = 6031097225
}, "farm")

local TeleportTab = MainSection:CreateTab({
    Name = "Телепорты",
    Columns = 1,
    Icon = 6031097225
}, "teleport")

local PvPTab = MainSection:CreateTab({
    Name = "PvP",
    Columns = 1,
    Icon = 6031097225
}, "pvp")

local ESPTab = MainSection:CreateTab({
    Name = "ESP",
    Columns = 1,
    Icon = 6031097225
}, "esp")

local RaidTab = MainSection:CreateTab({
    Name = "Raid",
    Columns = 1,
    Icon = 6031097225
}, "raid")

local SettingsTab = MainSection:CreateTab({
    Name = "Настройки",
    Columns = 1,
    Icon = 6031097225
}, "settings")

-- ============================================
-- ДОБАВЛЯЕМ ЭЛЕМЕНТЫ В ВКЛАДКУ ФАРМ
-- ============================================

-- Создаём группу в вкладке
local FarmGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm",
    Column = 1,
    Style = 1
}, "farm_group")

-- Добавляем элементы
FarmGroup:CreateToggle({
    Name = "Auto Farm (Уровень)",
    CurrentValue = false,
    Callback = function(state)
        print("[Farm] Level:", state)
    end
}, "farm_level")

FarmGroup:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    CurrentValue = false,
    Callback = function(state)
        print("[Farm] Nearby:", state)
    end
}, "farm_nearby")

FarmGroup:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = {"Меч"},
    Callback = function(value)
        print("[Farm] Weapon:", value[1])
    end
}, "weapon")

-- Вторая группа
local BossGroup = FarmTab:CreateGroupbox({
    Name = "Auto Farm Boss",
    Column = 1,
    Style = 1
}, "boss_group")

BossGroup:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(state)
        print("[Boss]", state)
    end
}, "boss_toggle")

BossGroup:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral"},
    CurrentOption = {"Diamond"},
    Callback = function(value)
        print("[Boss] Select:", value[1])
    end
}, "boss_select")

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
        print("[Teleport] 1st Sea")
    end
}, "tp1")

TeleportGroup:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        print("[Teleport] 2nd Sea")
    end
}, "tp2")

TeleportGroup:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        print("[Teleport] 3rd Sea")
    end
}, "tp3")

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
        print("[PvP] Fast Attack:", state)
    end
}, "fast")

PvPGroup:CreateSlider({
    Name = "Dash Length",
    Range = {0, 200},
    CurrentValue = 0,
    Callback = function(value)
        print("[PvP] Dash Length:", value)
    end
}, "dash")

-- ============================================
-- УВЕДОМЛЕНИЕ
-- ============================================
Window:Notify("Abyss Hub", "Скрипт загружен!", 3)
print("Abyss Hub loaded!")
