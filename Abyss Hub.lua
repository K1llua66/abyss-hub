--[[
    Abyss Hub
    Версия: 1.0 (полная)
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
    Size = UDim2.new(0, 600, 0, 550),
    Theme = "Starlight",
    Minimizable = true
})

-- Создаём секцию вкладок
local MainSection = Window:CreateTabSection("Меню", true)

-- ============================================
-- ВКЛАДКА ФАРМ (полная)
-- ============================================
local FarmTab = MainSection:CreateTab({
    Name = "Фарм",
    Columns = 1,
    Icon = 6031097225
}, "farm_tab")

-- Auto Farm
local AutoFarmGroup = FarmTab:CreateGroupbox({Name = "Auto Farm", Column = 1, Style = 1}, "autofarm")
AutoFarmGroup:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(s) print("[Auto Farm] Уровень:", s) end}, "farm_level")
AutoFarmGroup:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(s) print("[Auto Farm] Ближайшие:", s) end}, "farm_nearby")
AutoFarmGroup:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Auto Farm] Оружие:", v[1]) end}, "farm_weapon")

-- Auto Farm Boss
local BossGroup = FarmTab:CreateGroupbox({Name = "Auto Farm Boss", Column = 1, Style = 1}, "boss")
BossGroup:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(s) print("[Auto Farm Boss]", s) end}, "boss_toggle")
BossGroup:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"}, CurrentOption = {"Diamond"}, Callback = function(v) print("[Auto Farm Boss] Босс:", v[1]) end}, "boss_select")
BossGroup:CreateDropdown({Name = "Оружие (босс)", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Auto Farm Boss] Оружие:", v[1]) end}, "boss_weapon")
BossGroup:CreateToggle({Name = "Использовать Fast Attack", CurrentValue = true, Callback = function(s) print("[Auto Farm Boss] Fast Attack:", s) end}, "boss_fast")
BossGroup:CreateDropdown({Name = "Способ передвижения", Options = {"Телепорт", "Бег"}, CurrentOption = {"Телепорт"}, Callback = function(v) print("[Auto Farm Boss] Способ:", v[1]) end}, "boss_move")

-- Auto Mastery
local MasteryGroup = FarmTab:CreateGroupbox({Name = "Auto Mastery", Column = 1, Style = 1}, "mastery")
MasteryGroup:CreateToggle({Name = "Auto Mastery", CurrentValue = false, Callback = function(s) print("[Auto Mastery]", s) end}, "mastery_toggle")
MasteryGroup:CreateDropdown({Name = "Тип", Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Auto Mastery] Тип:", v[1]) end}, "mastery_type")
MasteryGroup:CreateToggle({Name = "Использовать Z", CurrentValue = true, Callback = function(s) print("[Mastery] Z skill:", s) end}, "skill_z")
MasteryGroup:CreateToggle({Name = "Использовать X", CurrentValue = true, Callback = function(s) print("[Mastery] X skill:", s) end}, "skill_x")
MasteryGroup:CreateToggle({Name = "Использовать C", CurrentValue = false, Callback = function(s) print("[Mastery] C skill:", s) end}, "skill_c")
MasteryGroup:CreateToggle({Name = "Использовать V", CurrentValue = false, Callback = function(s) print("[Mastery] V skill:", s) end}, "skill_v")
MasteryGroup:CreateToggle({Name = "Использовать F", CurrentValue = false, Callback = function(s) print("[Mastery] F skill:", s) end}, "skill_f")

-- Auto Fruit
local FruitGroup = FarmTab:CreateGroupbox({Name = "Auto Fruit", Column = 1, Style = 1}, "fruit")
FruitGroup:CreateToggle({Name = "Auto Fruit (Spawn)", CurrentValue = false, Callback = function(s) print("[Auto Fruit] Сбор на карте:", s) end}, "fruit_spawn")
FruitGroup:CreateToggle({Name = "Auto Fruit (Dealer)", CurrentValue = false, Callback = function(s) print("[Auto Fruit] Покупка:", s) end}, "fruit_dealer")
FruitGroup:CreateToggle({Name = "Auto Store Fruit", CurrentValue = false, Callback = function(s) print("[Auto Fruit] Сохранять:", s) end}, "fruit_store")

-- Auto Chest
local ChestGroup = FarmTab:CreateGroupbox({Name = "Auto Chest", Column = 1, Style = 1}, "chest")
ChestGroup:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(s) print("[Auto Chest]", s) end}, "chest_toggle")
ChestGroup:CreateDropdown({Name = "Режим", Options = {"Teleport Farm", "Tween Farm"}, CurrentOption = {"Teleport Farm"}, Callback = function(v) print("[Auto Chest] Режим:", v[1]) end}, "chest_mode")

-- Другие функции фарма
local OtherGroup = FarmTab:CreateGroupbox({Name = "Другие функции", Column = 1, Style = 1}, "other")
OtherGroup:CreateToggle({Name = "Auto Sea Beast", CurrentValue = false, Callback = function(s) print("[Auto Sea Beast]", s) end}, "sea_beast")
OtherGroup:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Callback = function(s) print("[Auto Elite Hunter]", s) end}, "elite_hunter")
OtherGroup:CreateToggle({Name = "Auto Observation (Ken Haki)", CurrentValue = false, Callback = function(s) print("[Auto Observation]", s) end}, "observation")
OtherGroup:CreateToggle({Name = "Auto Factory", CurrentValue = false, Callback = function(s) print("[Auto Factory]", s) end}, "factory")
OtherGroup:CreateToggle({Name = "Auto Mirage Island", CurrentValue = false, Callback = function(s) print("[Auto Mirage Island]", s) end}, "mirage")

-- Auto Kitsune Island
local KitsuneGroup = FarmTab:CreateGroupbox({Name = "Auto Kitsune Island", Column = 1, Style = 1}, "kitsune")
KitsuneGroup:CreateToggle({Name = "Авто-сбор Azure Embers", CurrentValue = false, Callback = function(s) print("[Kitsune] Сбор:", s) end}, "embers_collect")
KitsuneGroup:CreateToggle({Name = "Сдавать Azure Embers", CurrentValue = false, Callback = function(s) print("[Kitsune] Сдача:", s) end}, "embers_trade")
KitsuneGroup:CreateSlider({Name = "Количество для сдачи", Range = {0, 20}, CurrentValue = 10, Callback = function(v) print("[Kitsune] Сдавать при:", v) end}, "embers_amount")

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================
local TeleportTab = MainSection:CreateTab({Name = "Телепорты", Columns = 1, Icon = 6031097225}, "teleport_tab")
local TeleportGroup = TeleportTab:CreateGroupbox({Name = "Телепорты", Column = 1, Style = 1}, "teleport")
TeleportGroup:CreateButton({Name = "Teleport to 1st Sea", Callback = function() print("[Teleport] 1st Sea") end}, "t1")
TeleportGroup:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() print("[Teleport] 2nd Sea") end}, "t2")
TeleportGroup:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() print("[Teleport] 3rd Sea") end}, "t3")
TeleportGroup:CreateButton({Name = "Teleport to Islands (Safe)", Callback = function() print("[Teleport] Islands") end}, "islands")
TeleportGroup:CreateButton({Name = "Teleport to NPC", Callback = function() print("[Teleport] NPC") end}, "npc")
TeleportGroup:CreateButton({Name = "Hop to Server", Callback = function() print("[Teleport] Hop") end}, "hop")

-- ============================================
-- ВКЛАДКА PVP
-- ============================================
local PvPTab = MainSection:CreateTab({Name = "PvP", Columns = 1, Icon = 6031097225}, "pvp_tab")
local PvPGroup = PvPTab:CreateGroupbox({Name = "PvP Functions", Column = 1, Style = 1}, "pvp")
PvPGroup:CreateToggle({Name = "Fast Attack", CurrentValue = true, Callback = function(s) print("[PvP] Fast Attack:", s) end}, "fast_attack")
PvPGroup:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(s) print("[PvP] Anti-Stun:", s) end}, "anti_stun")
PvPGroup:CreateToggle({Name = "Infinite Energy", CurrentValue = false, Callback = function(s) print("[PvP] Infinite Energy:", s) end}, "inf_energy")
PvPGroup:CreateSlider({Name = "Speed", Range = {1, 10}, CurrentValue = 1, Callback = function(v) print("[PvP] Speed x", v) end}, "speed")
PvPGroup:CreateSlider({Name = "Jump", Range = {1, 10}, CurrentValue = 1, Callback = function(v) print("[PvP] Jump x", v) end}, "jump")
PvPGroup:CreateSlider({Name = "Dash Length", Range = {0, 200}, CurrentValue = 0, Callback = function(v) print("[PvP] Dash Length:", v) end}, "dash")
PvPGroup:CreateToggle({Name = "Infinite Air Jumps", CurrentValue = false, Callback = function(s) print("[PvP] Air Jumps:", s) end}, "air_jumps")

-- Silent Aim
local SilentGroup = PvPTab:CreateGroupbox({Name = "Silent Aim", Column = 1, Style = 1}, "silent")
SilentGroup:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(s) print("[Silent Aim]", s) end}, "silent_toggle")
SilentGroup:CreateDropdown({Name = "Режим", Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, CurrentOption = {"FOV"}, Callback = function(v) print("[Silent Aim] Режим:", v[1]) end}, "silent_mode")
SilentGroup:CreateSlider({Name = "FOV", Range = {0, 360}, CurrentValue = 90, Callback = function(v) print("[Silent Aim] FOV:", v) end}, "silent_fov")
SilentGroup:CreateSlider({Name = "Макс. дистанция", Range = {0, 500}, CurrentValue = 200, Callback = function(v) print("[Silent Aim] Max Distance:", v) end}, "silent_dist")
PvPGroup:CreateToggle({Name = "Enable PvP Mode", CurrentValue = false, Callback = function(s) print("[PvP] PvP Mode:", s) end}, "pvp_mode")

-- ============================================
-- ВКЛАДКА ESP
-- ============================================
local ESPTab = MainSection:CreateTab({Name = "ESP", Columns = 1, Icon = 6031097225}, "esp_tab")
local ESPGroup = ESPTab:CreateGroupbox({Name = "ESP Functions", Column = 1, Style = 1}, "esp")
ESPGroup:CreateToggle({Name = "Fruit ESP", CurrentValue = false, Callback = function(s) print("[ESP] Fruit ESP:", s) end}, "fruit_esp")
ESPGroup:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(s) print("[ESP] Player ESP:", s) end}, "player_esp")
ESPGroup:CreateToggle({Name = "NPC ESP", CurrentValue = false, Callback = function(s) print("[ESP] NPC ESP:", s) end}, "npc_esp")
ESPGroup:CreateToggle({Name = "Chest ESP", CurrentValue = false, Callback = function(s) print("[ESP] Chest ESP:", s) end}, "chest_esp")
ESPGroup:CreateToggle({Name = "Island ESP", CurrentValue = false, Callback = function(s) print("[ESP] Island ESP:", s) end}, "island_esp")
ESPGroup:CreateToggle({Name = "Flower ESP", CurrentValue = false, Callback = function(s) print("[ESP] Flower ESP:", s) end}, "flower_esp")
ESPGroup:CreateDropdown({Name = "Fruit Rarity Filter", Options = {"Все", "Rare+", "Legendary+", "Mythical"}, CurrentOption = {"Все"}, Callback = function(v) print("[ESP] Fruit Filter:", v[1]) end}, "fruit_filter")

-- ============================================
-- ВКЛАДКА RAID
-- ============================================
local RaidTab = MainSection:CreateTab({Name = "Raid", Columns = 1, Icon = 6031097225}, "raid_tab")
local RaidGroup = RaidTab:CreateGroupbox({Name = "Auto Raid", Column = 1, Style = 1}, "raid")
RaidGroup:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(s) print("[Raid] Auto Raid:", s) end}, "auto_raid")
RaidGroup:CreateToggle({Name = "Авто-старт", CurrentValue = false, Callback = function(s) print("[Raid] Auto Start:", s) end}, "auto_start")
RaidGroup:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = {"Buddha"}, Callback = function(v) print("[Raid] Type:", v[1]) end}, "raid_type")
RaidGroup:CreateToggle({Name = "Авто-покупка рейда", CurrentValue = false, Callback = function(s) print("[Raid] Auto Buy:", s) end}, "auto_buy")
RaidGroup:CreateToggle({Name = "Авто-доставание фрукта", CurrentValue = false, Callback = function(s) print("[Raid] Auto Equip:", s) end}, "auto_fruit")
RaidGroup:CreateSlider({Name = "Макс. цена фрукта (Beli)", Range = {0, 1000000}, CurrentValue = 500000, Callback = function(v) print("[Raid] Max Price:", v) end}, "max_price")
RaidTab:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(s) print("[Raid] Kill Aura:", s) end}, "kill_aura")

-- ============================================
-- ВКЛАДКА НАСТРОЙКИ
-- ============================================
local SettingsTab = MainSection:CreateTab({Name = "Настройки", Columns = 1, Icon = 6031097225}, "settings_tab")

local ConfigGroup = SettingsTab:CreateGroupbox({Name = "Конфигурации", Column = 1, Style = 1}, "config")
ConfigGroup:CreateButton({Name = "Создать конфиг", Callback = function() print("[Config] Create") end}, "create")
ConfigGroup:CreateButton({Name = "Сохранить конфиг", Callback = function() print("[Config] Save") end}, "save")
ConfigGroup:CreateButton({Name = "Загрузить конфиг", Callback = function() print("[Config] Load") end}, "load")
ConfigGroup:CreateButton({Name = "Авто-загрузка конфига", Callback = function() print("[Config] Auto Load") end}, "auto_load")

local OtherSettings = SettingsTab:CreateGroupbox({Name = "Общие", Column = 1, Style = 1}, "general")
OtherSettings:CreateButton({Name = "Auto Update", Callback = function() print("[Settings] Update") end}, "update")
OtherSettings:CreateButton({Name = "Unload Script", Callback = function() Window:Destroy() end}, "unload")
OtherSettings:CreateToggle({Name = "Авто-запуск при переходе сервера", CurrentValue = true, Callback = function(s) print("[Settings] Auto Rejoin:", s) end}, "rejoin")

local IsMobile = game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").KeyboardEnabled
OtherSettings:CreateToggle({Name = "Mobile Support", CurrentValue = IsMobile, Callback = function(s) print("[Settings] Mobile:", s) end}, "mobile")
OtherSettings:CreateButton({Name = "Настройка цветов", Callback = function() print("[Settings] Colors") end}, "colors")

-- Уведомление
Window:Notify("Abyss Hub", "Скрипт успешно загружен!", 3)
print("Abyss Hub загружен!")
