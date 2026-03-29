--[[
    Abyss Hub
    Версия: 1.0 (одна группа на вкладку)
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
    Theme = "Starlight"
})

-- ============================================
-- ВКЛАДКА 1: AUTO FARM
-- ============================================
local FarmSection = Window:CreateTabSection("Auto Farm", true)
local FarmTab = FarmSection:CreateTab({Name = "Auto Farm", Columns = 1}, "farm")
local FarmGroup = FarmTab:CreateGroupbox({Name = "Auto Farm", Column = 1, Style = 1}, "farm_group")
FarmGroup:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(s) print("[Farm] Level:", s) end}, "farm_level")
FarmGroup:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(s) print("[Farm] Nearby:", s) end}, "farm_nearby")
FarmGroup:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Farm] Weapon:", v[1]) end}, "weapon")

-- ============================================
-- ВКЛАДКА 2: AUTO FARM BOSS
-- ============================================
local BossSection = Window:CreateTabSection("Auto Farm Boss", true)
local BossTab = BossSection:CreateTab({Name = "Auto Farm Boss", Columns = 1}, "boss")
local BossGroup = BossTab:CreateGroupbox({Name = "Auto Farm Boss", Column = 1, Style = 1}, "boss_group")
BossGroup:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(s) print("[Boss]", s) end}, "boss_toggle")
BossGroup:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral", "Awakened Ice Admiral"}, CurrentOption = {"Diamond"}, Callback = function(v) print("[Boss] Select:", v[1]) end}, "boss_select")
BossGroup:CreateDropdown({Name = "Оружие (босс)", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Boss] Weapon:", v[1]) end}, "boss_weapon")
BossGroup:CreateToggle({Name = "Использовать Fast Attack", CurrentValue = true, Callback = function(s) print("[Boss] Fast Attack:", s) end}, "boss_fast")
BossGroup:CreateDropdown({Name = "Способ передвижения", Options = {"Телепорт", "Бег"}, CurrentOption = {"Телепорт"}, Callback = function(v) print("[Boss] Move:", v[1]) end}, "boss_move")

-- ============================================
-- ВКЛАДКА 3: AUTO MASTERY
-- ============================================
local MasterySection = Window:CreateTabSection("Auto Mastery", true)
local MasteryTab = MasterySection:CreateTab({Name = "Auto Mastery", Columns = 1}, "mastery")
local MasteryGroup = MasteryTab:CreateGroupbox({Name = "Auto Mastery", Column = 1, Style = 1}, "mastery_group")
MasteryGroup:CreateToggle({Name = "Auto Mastery", CurrentValue = false, Callback = function(s) print("[Mastery]", s) end}, "mastery_toggle")
MasteryGroup:CreateDropdown({Name = "Тип", Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, CurrentOption = {"Меч"}, Callback = function(v) print("[Mastery] Type:", v[1]) end}, "mastery_type")
MasteryGroup:CreateToggle({Name = "Использовать Z", CurrentValue = true, Callback = function(s) print("[Mastery] Z:", s) end}, "skill_z")
MasteryGroup:CreateToggle({Name = "Использовать X", CurrentValue = true, Callback = function(s) print("[Mastery] X:", s) end}, "skill_x")
MasteryGroup:CreateToggle({Name = "Использовать C", CurrentValue = false, Callback = function(s) print("[Mastery] C:", s) end}, "skill_c")
MasteryGroup:CreateToggle({Name = "Использовать V", CurrentValue = false, Callback = function(s) print("[Mastery] V:", s) end}, "skill_v")
MasteryGroup:CreateToggle({Name = "Использовать F", CurrentValue = false, Callback = function(s) print("[Mastery] F:", s) end}, "skill_f")

-- ============================================
-- ВКЛАДКА 4: AUTO FRUIT
-- ============================================
local FruitSection = Window:CreateTabSection("Auto Fruit", true)
local FruitTab = FruitSection:CreateTab({Name = "Auto Fruit", Columns = 1}, "fruit")
local FruitGroup = FruitTab:CreateGroupbox({Name = "Auto Fruit", Column = 1, Style = 1}, "fruit_group")
FruitGroup:CreateToggle({Name = "Auto Fruit (Spawn)", CurrentValue = false, Callback = function(s) print("[Fruit] Spawn:", s) end}, "fruit_spawn")
FruitGroup:CreateToggle({Name = "Auto Fruit (Dealer)", CurrentValue = false, Callback = function(s) print("[Fruit] Dealer:", s) end}, "fruit_dealer")
FruitGroup:CreateToggle({Name = "Auto Store Fruit", CurrentValue = false, Callback = function(s) print("[Fruit] Store:", s) end}, "fruit_store")

-- ============================================
-- ВКЛАДКА 5: AUTO CHEST
-- ============================================
local ChestSection = Window:CreateTabSection("Auto Chest", true)
local ChestTab = ChestSection:CreateTab({Name = "Auto Chest", Columns = 1}, "chest")
local ChestGroup = ChestTab:CreateGroupbox({Name = "Auto Chest", Column = 1, Style = 1}, "chest_group")
ChestGroup:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(s) print("[Chest]", s) end}, "chest_toggle")
ChestGroup:CreateDropdown({Name = "Режим", Options = {"Teleport Farm", "Tween Farm"}, CurrentOption = {"Teleport Farm"}, Callback = function(v) print("[Chest] Mode:", v[1]) end}, "chest_mode")

-- ============================================
-- ВКЛАДКА 6: ДРУГИЕ ФУНКЦИИ
-- ============================================
local OtherSection = Window:CreateTabSection("Другие функции", true)
local OtherTab = OtherSection:CreateTab({Name = "Другие", Columns = 1}, "other")
local OtherGroup = OtherTab:CreateGroupbox({Name = "Другие функции", Column = 1, Style = 1}, "other_group")
OtherGroup:CreateToggle({Name = "Auto Sea Beast", CurrentValue = false, Callback = function(s) print("[Sea Beast]", s) end}, "sea_beast")
OtherGroup:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Callback = function(s) print("[Elite Hunter]", s) end}, "elite")
OtherGroup:CreateToggle({Name = "Auto Observation (Ken Haki)", CurrentValue = false, Callback = function(s) print("[Observation]", s) end}, "observation")
OtherGroup:CreateToggle({Name = "Auto Factory", CurrentValue = false, Callback = function(s) print("[Factory]", s) end}, "factory")
OtherGroup:CreateToggle({Name = "Auto Mirage Island", CurrentValue = false, Callback = function(s) print("[Mirage]", s) end}, "mirage")

-- ============================================
-- ВКЛАДКА 7: KITSUNE ISLAND
-- ============================================
local KitsuneSection = Window:CreateTabSection("Kitsune Island", true)
local KitsuneTab = KitsuneSection:CreateTab({Name = "Kitsune", Columns = 1}, "kitsune")
local KitsuneGroup = KitsuneTab:CreateGroupbox({Name = "Auto Kitsune", Column = 1, Style = 1}, "kitsune_group")
KitsuneGroup:CreateToggle({Name = "Авто-сбор Azure Embers", CurrentValue = false, Callback = function(s) print("[Kitsune] Collect:", s) end}, "embers_collect")
KitsuneGroup:CreateToggle({Name = "Сдавать Azure Embers", CurrentValue = false, Callback = function(s) print("[Kitsune] Trade:", s) end}, "embers_trade")
KitsuneGroup:CreateSlider({Name = "Количество для сдачи", Range = {0, 20}, CurrentValue = 10, Callback = function(v) print("[Kitsune] Amount:", v) end}, "embers_amount")

-- ============================================
-- ВКЛАДКА 8: ТЕЛЕПОРТЫ
-- ============================================
local TeleportSection = Window:CreateTabSection("Телепорты", true)
local TeleportTab = TeleportSection:CreateTab({Name = "Телепорты", Columns = 1}, "teleport")
local TeleportGroup = TeleportTab:CreateGroupbox({Name = "Телепорты", Column = 1, Style = 1}, "teleport_group")
TeleportGroup:CreateButton({Name = "Teleport to 1st Sea", Callback = function() print("[Teleport] 1st Sea") end}, "tp1")
TeleportGroup:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() print("[Teleport] 2nd Sea") end}, "tp2")
TeleportGroup:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() print("[Teleport] 3rd Sea") end}, "tp3")
TeleportGroup:CreateButton({Name = "Teleport to Islands (Safe)", Callback = function() print("[Teleport] Islands") end}, "islands")
TeleportGroup:CreateButton({Name = "Teleport to NPC", Callback = function() print("[Teleport] NPC") end}, "npc")
TeleportGroup:CreateButton({Name = "Hop to Server", Callback = function() print("[Teleport] Hop") end}, "hop")

-- ============================================
-- ВКЛАДКА 9: PVP
-- ============================================
local PvPSection = Window:CreateTabSection("PvP", true)
local PvPTab = PvPSection:CreateTab({Name = "PvP", Columns = 1}, "pvp")
local PvPGroup = PvPTab:CreateGroupbox({Name = "PvP Functions", Column = 1, Style = 1}, "pvp_group")
PvPGroup:CreateToggle({Name = "Fast Attack", CurrentValue = true, Callback = function(s) print("[PvP] Fast Attack:", s) end}, "fast")
PvPGroup:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(s) print("[PvP] Anti-Stun:", s) end}, "stun")
PvPGroup:CreateToggle({Name = "Infinite Energy", CurrentValue = false, Callback = function(s) print("[PvP] Infinite Energy:", s) end}, "energy")
PvPGroup:CreateSlider({Name = "Speed", Range = {1, 10}, CurrentValue = 1, Callback = function(v) print("[PvP] Speed x", v) end}, "speed")
PvPGroup:CreateSlider({Name = "Jump", Range = {1, 10}, CurrentValue = 1, Callback = function(v) print("[PvP] Jump x", v) end}, "jump")
PvPGroup:CreateSlider({Name = "Dash Length", Range = {0, 200}, CurrentValue = 0, Callback = function(v) print("[PvP] Dash:", v) end}, "dash")
PvPGroup:CreateToggle({Name = "Infinite Air Jumps", CurrentValue = false, Callback = function(s) print("[PvP] Air Jumps:", s) end}, "air_jumps")

-- ============================================
-- ВКЛАДКА 10: SILENT AIM
-- ============================================
local SilentSection = Window:CreateTabSection("Silent Aim", true)
local SilentTab = SilentSection:CreateTab({Name = "Silent Aim", Columns = 1}, "silent")
local SilentGroup = SilentTab:CreateGroupbox({Name = "Silent Aim", Column = 1, Style = 1}, "silent_group")
SilentGroup:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(s) print("[Silent]", s) end}, "silent_toggle")
SilentGroup:CreateDropdown({Name = "Режим", Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, CurrentOption = {"FOV"}, Callback = function(v) print("[Silent] Mode:", v[1]) end}, "silent_mode")
SilentGroup:CreateSlider({Name = "FOV", Range = {0, 360}, CurrentValue = 90, Callback = function(v) print("[Silent] FOV:", v) end}, "silent_fov")
SilentGroup:CreateSlider({Name = "Макс. дистанция", Range = {0, 500}, CurrentValue = 200, Callback = function(v) print("[Silent] Distance:", v) end}, "silent_dist")

-- ============================================
-- ВКЛАДКА 11: ESP
-- ============================================
local EspSection = Window:CreateTabSection("ESP", true)
local EspTab = EspSection:CreateTab({Name = "ESP", Columns = 1}, "esp")
local EspGroup = EspTab:CreateGroupbox({Name = "ESP Functions", Column = 1, Style = 1}, "esp_group")
EspGroup:CreateToggle({Name = "Fruit ESP", CurrentValue = false, Callback = function(s) print("[ESP] Fruit:", s) end}, "fruit_esp")
EspGroup:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(s) print("[ESP] Player:", s) end}, "player_esp")
EspGroup:CreateToggle({Name = "NPC ESP", CurrentValue = false, Callback = function(s) print("[ESP] NPC:", s) end}, "npc_esp")
EspGroup:CreateToggle({Name = "Chest ESP", CurrentValue = false, Callback = function(s) print("[ESP] Chest:", s) end}, "chest_esp")
EspGroup:CreateToggle({Name = "Island ESP", CurrentValue = false, Callback = function(s) print("[ESP] Island:", s) end}, "island_esp")
EspGroup:CreateToggle({Name = "Flower ESP", CurrentValue = false, Callback = function(s) print("[ESP] Flower:", s) end}, "flower_esp")
EspGroup:CreateDropdown({Name = "Fruit Rarity Filter", Options = {"Все", "Rare+", "Legendary+", "Mythical"}, CurrentOption = {"Все"}, Callback = function(v) print("[ESP] Filter:", v[1]) end}, "fruit_filter")

-- ============================================
-- ВКЛАДКА 12: RAID
-- ============================================
local RaidSection = Window:CreateTabSection("Raid", true)
local RaidTab = RaidSection:CreateTab({Name = "Raid", Columns = 1}, "raid")
local RaidGroup = RaidTab:CreateGroupbox({Name = "Auto Raid", Column = 1, Style = 1}, "raid_group")
RaidGroup:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(s) print("[Raid] Auto:", s) end}, "auto_raid")
RaidGroup:CreateToggle({Name = "Авто-старт", CurrentValue = false, Callback = function(s) print("[Raid] Auto Start:", s) end}, "auto_start")
RaidGroup:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = {"Buddha"}, Callback = function(v) print("[Raid] Type:", v[1]) end}, "raid_type")
RaidGroup:CreateToggle({Name = "Авто-покупка рейда", CurrentValue = false, Callback = function(s) print("[Raid] Auto Buy:", s) end}, "auto_buy")
RaidGroup:CreateToggle({Name = "Авто-доставание фрукта", CurrentValue = false, Callback = function(s) print("[Raid] Auto Fruit:", s) end}, "auto_fruit")
RaidGroup:CreateSlider({Name = "Макс. цена фрукта (Beli)", Range = {0, 1000000}, CurrentValue = 500000, Callback = function(v) print("[Raid] Max Price:", v) end}, "max_price")
RaidTab:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(s) print("[Raid] Kill Aura:", s) end}, "kill_aura")

-- ============================================
-- ВКЛАДКА 13: НАСТРОЙКИ
-- ============================================
local SettingsSection = Window:CreateTabSection("Настройки", true)
local SettingsTab = SettingsSection:CreateTab({Name = "Настройки", Columns = 1}, "settings")
local ConfigGroup = SettingsTab:CreateGroupbox({Name = "Конфигурации", Column = 1, Style = 1}, "config")
ConfigGroup:CreateButton({Name = "Создать конфиг", Callback = function() print("[Config] Create") end}, "create")
ConfigGroup:CreateButton({Name = "Сохранить конфиг", Callback = function() print("[Config] Save") end}, "save")
ConfigGroup:CreateButton({Name = "Загрузить конфиг", Callback = function() print("[Config] Load") end}, "load")
ConfigGroup:CreateButton({Name = "Авто-загрузка конфига", Callback = function() print("[Config] Auto Load") end}, "auto_load")

local GeneralGroup = SettingsTab:CreateGroupbox({Name = "Общие", Column = 1, Style = 1}, "general")
GeneralGroup:CreateButton({Name = "Auto Update", Callback = function() print("[Settings] Update") end}, "update")
GeneralGroup:CreateButton({Name = "Unload Script", Callback = function() Window:Destroy() end}, "unload")
GeneralGroup:CreateToggle({Name = "Авто-запуск при переходе сервера", CurrentValue = true, Callback = function(s) print("[Settings] Auto Rejoin:", s) end}, "rejoin")
GeneralGroup:CreateToggle({Name = "Mobile Support", CurrentValue = game:GetService("UserInputService").TouchEnabled, Callback = function(s) print("[Settings] Mobile:", s) end}, "mobile")
GeneralGroup:CreateButton({Name = "Настройка цветов", Callback = function() print("[Settings] Colors") end}, "colors")

-- Уведомление
Window:Notify("Abyss Hub", "Скрипт загружен! 13 вкладок", 4)
print("Abyss Hub загружен! 13 вкладок")
