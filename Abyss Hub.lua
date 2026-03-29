--[[
    Abyss Hub
    Версия: 1.0 (исправленный скроллинг)
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

-- Создание окна (увеличиваем высоту)
local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Blox Fruits",
    Size = UDim2.new(0, 650, 0, 700),  -- Увеличил высоту
    Theme = "Starlight"
})

-- Секция вкладок
local MainSection = Window:CreateTabSection("Главная", true)

-- ============================================
-- ВКЛАДКА ФАРМ (все группы)
-- ============================================
local FarmTab = MainSection:CreateTab({Name = "Фарм", Columns = 1, Icon = 6031097225}, "farm")

-- Группа 1: Auto Farm
local Group1 = FarmTab:CreateGroupbox({Name = "Auto Farm", Column = 1, Style = 1}, "farm_group")
Group1:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(s) print("[Farm] Level:", s) end}, "farm_level")
Group1:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(s) print("[Farm] Nearby:", s) end}, "farm_nearby")
Group1:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Farm] Weapon:", v[1]) end}, "weapon")

-- Группа 2: Auto Farm Boss
local Group2 = FarmTab:CreateGroupbox({Name = "Auto Farm Boss", Column = 1, Style = 1}, "boss")
Group2:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(s) print("[Boss]", s) end}, "boss_toggle")
Group2:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"}, CurrentOption = {"Diamond"}, Callback = function(v) print("[Boss] Select:", v[1]) end}, "boss_select")
Group2:CreateDropdown({Name = "Оружие (босс)", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Boss] Weapon:", v[1]) end}, "boss_weapon")
Group2:CreateToggle({Name = "Использовать Fast Attack", CurrentValue = true, Callback = function(s) print("[Boss] Fast Attack:", s) end}, "boss_fast")
Group2:CreateDropdown({Name = "Способ передвижения", Options = {"Телепорт", "Бег"}, CurrentOption = {"Телепорт"}, Callback = function(v) print("[Boss] Move:", v[1]) end}, "boss_move")

-- Группа 3: Auto Mastery
local Group3 = FarmTab:CreateGroupbox({Name = "Auto Mastery", Column = 1, Style = 1}, "mastery")
Group3:CreateToggle({Name = "Auto Mastery", CurrentValue = false, Callback = function(s) print("[Mastery]", s) end}, "mastery_toggle")
Group3:CreateDropdown({Name = "Тип", Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Mastery] Type:", v[1]) end}, "mastery_type")
Group3:CreateToggle({Name = "Использовать Z", CurrentValue = true, Callback = function(s) print("[Mastery] Z:", s) end}, "skill_z")
Group3:CreateToggle({Name = "Использовать X", CurrentValue = true, Callback = function(s) print("[Mastery] X:", s) end}, "skill_x")
Group3:CreateToggle({Name = "Использовать C", CurrentValue = false, Callback = function(s) print("[Mastery] C:", s) end}, "skill_c")
Group3:CreateToggle({Name = "Использовать V", CurrentValue = false, Callback = function(s) print("[Mastery] V:", s) end}, "skill_v")
Group3:CreateToggle({Name = "Использовать F", CurrentValue = false, Callback = function(s) print("[Mastery] F:", s) end}, "skill_f")

-- Группа 4: Auto Fruit
local Group4 = FarmTab:CreateGroupbox({Name = "Auto Fruit", Column = 1, Style = 1}, "fruit")
Group4:CreateToggle({Name = "Auto Fruit (Spawn)", CurrentValue = false, Callback = function(s) print("[Fruit] Spawn:", s) end}, "fruit_spawn")
Group4:CreateToggle({Name = "Auto Fruit (Dealer)", CurrentValue = false, Callback = function(s) print("[Fruit] Dealer:", s) end}, "fruit_dealer")
Group4:CreateToggle({Name = "Auto Store Fruit", CurrentValue = false, Callback = function(s) print("[Fruit] Store:", s) end}, "fruit_store")

-- Группа 5: Auto Chest
local Group5 = FarmTab:CreateGroupbox({Name = "Auto Chest", Column = 1, Style = 1}, "chest")
Group5:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(s) print("[Chest]", s) end}, "chest_toggle")
Group5:CreateDropdown({Name = "Режим", Options = {"Teleport Farm", "Tween Farm"}, CurrentOption = {"Teleport Farm"}, Callback = function(v) print("[Chest] Mode:", v[1]) end}, "chest_mode")

-- Группа 6: Другие функции
local Group6 = FarmTab:CreateGroupbox({Name = "Другие функции", Column = 1, Style = 1}, "other")
Group6:CreateToggle({Name = "Auto Sea Beast", CurrentValue = false, Callback = function(s) print("[Sea Beast]", s) end}, "sea_beast")
Group6:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Callback = function(s) print("[Elite Hunter]", s) end}, "elite")
Group6:CreateToggle({Name = "Auto Observation (Ken Haki)", CurrentValue = false, Callback = function(s) print("[Observation]", s) end}, "observation")
Group6:CreateToggle({Name = "Auto Factory", CurrentValue = false, Callback = function(s) print("[Factory]", s) end}, "factory")
Group6:CreateToggle({Name = "Auto Mirage Island", CurrentValue = false, Callback = function(s) print("[Mirage]", s) end}, "mirage")

-- Группа 7: Auto Kitsune Island
local Group7 = FarmTab:CreateGroupbox({Name = "Auto Kitsune Island", Column = 1, Style = 1}, "kitsune")
Group7:CreateToggle({Name = "Авто-сбор Azure Embers", CurrentValue = false, Callback = function(s) print("[Kitsune] Collect:", s) end}, "embers_collect")
Group7:CreateToggle({Name = "Сдавать Azure Embers", CurrentValue = false, Callback = function(s) print("[Kitsune] Trade:", s) end}, "embers_trade")
Group7:CreateSlider({Name = "Количество для сдачи", Range = {0, 20}, CurrentValue = 10, Callback = function(v) print("[Kitsune] Amount:", v) end}, "embers_amount")

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================
local TeleportTab = MainSection:CreateTab({Name = "Телепорты", Columns = 1, Icon = 6031097225}, "teleport")
local TeleportGroup = TeleportTab:CreateGroupbox({Name = "Телепорты", Column = 1, Style = 1}, "teleport_group")
TeleportGroup:CreateButton({Name = "Teleport to 1st Sea", Callback = function() print("[Teleport] 1st Sea") end}, "tp1")
TeleportGroup:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() print("[Teleport] 2nd Sea") end}, "tp2")
TeleportGroup:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() print("[Teleport] 3rd Sea") end}, "tp3")
TeleportGroup:CreateButton({Name = "Teleport to Islands (Safe)", Callback = function() print("[Teleport] Islands") end}, "islands")
TeleportGroup:CreateButton({Name = "Teleport to NPC", Callback = function() print("[Teleport] NPC") end}, "npc")
TeleportGroup:CreateButton({Name = "Hop to Server", Callback = function() print("[Teleport] Hop") end}, "hop")

-- ============================================
-- ВКЛАДКА PVP
-- ============================================
local PvPTab = MainSection:CreateTab({Name = "PvP", Columns = 1, Icon = 6031097225}, "pvp")
local PvPGroup = PvPTab:CreateGroupbox({Name = "PvP Functions", Column = 1, Style = 1}, "pvp")
PvPGroup:CreateToggle({Name = "Fast Attack", CurrentValue = true, Callback = function(s) print("[PvP] Fast Attack:", s) end}, "fast")
PvPGroup:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(s) print("[PvP] Anti-Stun:", s) end}, "stun")
PvPGroup:CreateToggle({Name = "Infinite Energy", CurrentValue = false, Callback = function(s) print("[PvP] Infinite Energy:", s) end}, "energy")
PvPGroup:CreateSlider({Name = "Speed", Range = {1, 10}, CurrentValue = 1, Callback = function(v) print("[PvP] Speed x", v) end}, "speed")
PvPGroup:CreateSlider({Name = "Jump", Range = {1, 10}, CurrentValue = 1, Callback = function(v) print("[PvP] Jump x", v) end}, "jump")
PvPGroup:CreateSlider({Name = "Dash Length", Range = {0, 200}, CurrentValue = 0, Callback = function(v) print("[PvP] Dash:", v) end}, "dash")
PvPGroup:CreateToggle({Name = "Infinite Air Jumps", CurrentValue = false, Callback = function(s) print("[PvP] Air Jumps:", s) end}, "air_jumps")

-- Silent Aim
local SilentGroup = PvPTab:CreateGroupbox({Name = "Silent Aim", Column = 1, Style = 1}, "silent")
SilentGroup:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(s) print("[Silent]", s) end}, "silent_toggle")
SilentGroup:CreateDropdown({Name = "Режим", Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, CurrentOption = {"FOV"}, Callback = function(v) print("[Silent] Mode:", v[1]) end}, "silent_mode")
SilentGroup:CreateSlider({Name = "FOV", Range = {0, 360}, CurrentValue = 90, Callback = function(v) print("[Silent] FOV:", v) end}, "silent_fov")
SilentGroup:CreateSlider({Name = "Макс. дистанция", Range = {0, 500}, CurrentValue = 200, Callback = function(v) print("[Silent] Distance:", v) end}, "silent_dist")
PvPGroup:CreateToggle({Name = "Enable PvP Mode", CurrentValue = false, Callback = function(s) print("[PvP] PvP Mode:", s) end}, "pvp_mode")

-- ============================================
-- ВКЛАДКА ESP
-- ============================================
local ESPTab = MainSection:CreateTab({Name = "ESP", Columns = 1, Icon = 6031097225}, "esp")
local ESPGroup = ESPTab:CreateGroupbox({Name = "ESP Functions", Column = 1, Style = 1}, "esp")
ESPGroup:CreateToggle({Name = "Fruit ESP", CurrentValue = false, Callback = function(s) print("[ESP] Fruit:", s) end}, "fruit_esp")
ESPGroup:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(s) print("[ESP] Player:", s) end}, "player_esp")
ESPGroup:CreateToggle({Name = "NPC ESP", CurrentValue = false, Callback = function(s) print("[ESP] NPC:", s) end}, "npc_esp")
ESPGroup:CreateToggle({Name = "Chest ESP", CurrentValue = false, Callback = function(s) print("[ESP] Chest:", s) end}, "chest_esp")
ESPGroup:CreateToggle({Name = "Island ESP", CurrentValue = false, Callback = function(s) print("[ESP] Island:", s) end}, "island_esp")
ESPGroup:CreateToggle({Name = "Flower ESP", CurrentValue = false, Callback = function(s) print("[ESP] Flower:", s) end}, "flower_esp")
ESPGroup:CreateDropdown({Name = "Fruit Rarity Filter", Options = {"Все", "Rare+", "Legendary+", "Mythical"}, CurrentOption = {"Все"}, Callback = function(v) print("[ESP] Filter:", v[1]) end}, "fruit_filter")

-- ============================================
-- ВКЛАДКА RAID
-- ============================================
local RaidTab = MainSection:CreateTab({Name = "Raid", Columns = 1, Icon = 6031097225}, "raid")
local RaidGroup = RaidTab:CreateGroupbox({Name = "Auto Raid", Column = 1, Style = 1}, "raid")
RaidGroup:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(s) print("[Raid] Auto:", s) end}, "auto_raid")
RaidGroup:CreateToggle({Name = "Авто-старт", CurrentValue = false, Callback = function(s) print("[Raid] Auto Start:", s) end}, "auto_start")
RaidGroup:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = {"Buddha"}, Callback = function(v) print("[Raid] Type:", v[1]) end}, "raid_type")
RaidGroup:CreateToggle({Name = "Авто-покупка рейда", CurrentValue = false, Callback = function(s) print("[Raid] Auto Buy:", s) end}, "auto_buy")
RaidGroup:CreateToggle({Name = "Авто-доставание фрукта", CurrentValue = false, Callback = function(s) print("[Raid] Auto Fruit:", s) end}, "auto_fruit")
RaidGroup:CreateSlider({Name = "Макс. цена фрукта (Beli)", Range = {0, 1000000}, CurrentValue = 500000, Callback = function(v) print("[Raid] Max Price:", v) end}, "max_price")
RaidTab:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(s) print("[Raid] Kill Aura:", s) end}, "kill_aura")

-- ============================================
-- ВКЛАДКА НАСТРОЙКИ
-- ============================================
local SettingsTab = MainSection:CreateTab({Name = "Настройки", Columns = 1, Icon = 6031097225}, "settings")
local ConfigGroup = SettingsTab:CreateGroupbox({Name = "Конфигурации", Column = 1, Style = 1}, "config")
ConfigGroup:CreateButton({Name = "Создать конфиг", Callback = function() print("[Config] Create") end}, "create")
ConfigGroup:CreateButton({Name = "Сохранить конфиг", Callback = function() print("[Config] Save") end}, "save")
ConfigGroup:CreateButton({Name = "Загрузить конфиг", Callback = function() print("[Config] Load") end}, "load")
ConfigGroup:CreateButton({Name = "Авто-загрузка конфига", Callback = function() print("[Config] Auto Load") end}, "auto_load")

local SettingsGroup = SettingsTab:CreateGroupbox({Name = "Общие", Column = 1, Style = 1}, "general")
SettingsGroup:CreateButton({Name = "Auto Update", Callback = function() print("[Settings] Update") end}, "update")
SettingsGroup:CreateButton({Name = "Unload Script", Callback = function() Window:Destroy() end}, "unload")
SettingsGroup:CreateToggle({Name = "Авто-запуск при переходе сервера", CurrentValue = true, Callback = function(s) print("[Settings] Auto Rejoin:", s) end}, "rejoin")
SettingsGroup:CreateToggle({Name = "Mobile Support", CurrentValue = game:GetService("UserInputService").TouchEnabled, Callback = function(s) print("[Settings] Mobile:", s) end}, "mobile")
SettingsGroup:CreateButton({Name = "Настройка цветов", Callback = function() print("[Settings] Colors") end}, "colors")

-- Уведомление
Window:Notify("Abyss Hub", "Скрипт загружен! Прокрутите вниз.", 4)
print("Abyss Hub загружен! Прокрутите вниз во вкладке Фарм, чтобы увидеть все функции.")
