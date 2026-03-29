-- Тест правильного API Starlight UI
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

if not Starlight then return end

local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Test",
    Size = UDim2.new(0, 550, 0, 450),
    Theme = "Starlight"
})

-- СОЗДАНИЕ ВКЛАДОК (правильный способ)
local FarmTab = Window:CreateTab("Фарм", "⚔️")
local TeleportTab = Window:CreateTab("Телепорты", "🌀")
local PvPTab = Window:CreateTab("PvP", "⚡")
local ESPTab = Window:CreateTab("ESP", "👁️")
local RaidTab = Window:CreateTab("Raid", "🔥")
local SettingsTab = Window:CreateTab("Настройки", "⚙️")

-- ДОБАВЛЯЕМ ЭЛЕМЕНТЫ В КАЖДУЮ ВКЛАДКУ

-- Фарм
local FarmGroup = FarmTab:CreateGroupbox("Auto Farm")
FarmGroup:CreateToggle("Auto Farm (Level)", false, function(state)
    print("[Farm] Level:", state)
end)

FarmGroup:CreateToggle("Auto Farm (Nearby)", false, function(state)
    print("[Farm] Nearby:", state)
end)

local BossGroup = FarmTab:CreateGroupbox("Auto Farm Boss")
BossGroup:CreateToggle("Auto Farm Boss", false, function(state)
    print("[Boss]", state)
end)

-- Телепорты
local TeleportGroup = TeleportTab:CreateGroupbox("Teleports")
TeleportGroup:CreateButton("Teleport to 1st Sea", function()
    print("[Teleport] 1st Sea")
end)

TeleportGroup:CreateButton("Teleport to 2nd Sea", function()
    print("[Teleport] 2nd Sea")
end)

-- PvP
local PvPGroup = PvPTab:CreateGroupbox("PvP Functions")
PvPGroup:CreateToggle("Fast Attack", true, function(state)
    print("[PvP] Fast Attack:", state)
end)

PvPGroup:CreateSlider("Dash Length", 0, 200, 0, function(value)
    print("[PvP] Dash Length:", value)
end)

-- ESP
local ESPGroup = ESPTab:CreateGroupbox("ESP")
ESPGroup:CreateToggle("Fruit ESP", false, function(state)
    print("[ESP] Fruit:", state)
end)

-- Raid
local RaidGroup = RaidTab:CreateGroupbox("Auto Raid")
RaidGroup:CreateToggle("Auto Raid", false, function(state)
    print("[Raid]", state)
end)

-- Настройки
local SettingsGroup = SettingsTab:CreateGroupbox("Settings")
SettingsGroup:CreateButton("Unload", function()
    Window:Destroy()
end)

Window:Notify("Abyss Hub", "Тест загружен!", 3)
print("Все вкладки созданы")
