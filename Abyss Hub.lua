--[[
    Abyss Hub v3.0
    Модульная версия с Luna UI
]]

-- Проверка игры
if not table.find({2753915549,4442272183,7449423635}, game.PlaceId) then
    return game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub только для Blox Fruits!")
end

-- Загрузка модулей
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/ESP.lua"))()
local FastAttack = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/FastAttack.lua"))()
local Player = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/Player.lua"))()
local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Libs/Teleport.lua"))()

-- Загрузка Luna UI
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/main/Luna%20UI.lua"))()
if not Luna then return game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Luna UI") end

-- Создание окна
local Window = Luna:CreateWindow({
    Name = "Abyss Hub",
    Subtitle = "Blox Fruits",
    LogoID = "6031097225",
    LoadingEnabled = true,
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "Loading...",
    KeySystem = false
})

-- Отключение размытия
_G.BlurModule = function() end
for _,e in ipairs(game:GetService("Lighting"):GetChildren()) do
    if e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then e:Destroy() end
end

-- Домашняя вкладка
Window:CreateHomeTab({DiscordInvite = "abysshub", SupportedExecutors = {"Xeno","Delta","Vega X","Arceus X"}})

-- ============================================
-- PVP ВКЛАДКА
-- ============================================
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака (только первая M1)",
    CurrentValue = true,
    Callback = function(v) if v then FastAttack:Start() else FastAttack:Stop() end end
})

pvpSec:CreateToggle({
    Name = "PvP Mode",
    Description = "Атаковать игроков",
    CurrentValue = false,
    Callback = function(v) FastAttack.PvPMode = v end
})

pvpSec:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(v) Player.SpeedEnabled = v; Player:Update() end
})

pvpSec:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1,10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) Player:SetSpeed(v) end
})

pvpSec:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(v) Player.JumpEnabled = v; Player:Update() end
})

pvpSec:CreateSlider({
    Name = "Jump Multiplier",
    Range = {1,10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v) Player:SetJump(v) end
})

-- ============================================
-- ESP ВКЛАДКА
-- ============================================
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")

local function updateESP()
    local any = ESP.Objects.Fruits or ESP.Objects.Players or ESP.Objects.NPC or ESP.Objects.Chests
    if any then ESP:Start() else ESP:Stop() end
end

espSec:CreateToggle({
    Name = "Fruit ESP",
    Description = "Показывает Devil Fruits",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Fruits = v; updateESP() end
})

espSec:CreateToggle({
    Name = "Player ESP",
    Description = "Показывает игроков",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Players = v; updateESP() end
})

espSec:CreateToggle({
    Name = "NPC ESP",
    Description = "Показывает NPC и мобов",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.NPC = v; updateESP() end
})

espSec:CreateToggle({
    Name = "Chest ESP",
    Description = "Показывает сундуки",
    CurrentValue = false,
    Callback = function(v) ESP.Objects.Chests = v; updateESP() end
})

-- ============================================
-- ТЕЛЕПОРТЫ ВКЛАДКА
-- ============================================
local teleTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local teleSec = teleTab:CreateSection("Моря")

teleSec:CreateButton({Name = "1st Sea", Callback = function() Teleport.Teleport(Teleport.Coords.Sea1) end})
teleSec:CreateButton({Name = "2nd Sea", Callback = function() Teleport.Teleport(Teleport.Coords.Sea2) end})
teleSec:CreateButton({Name = "3rd Sea", Callback = function() Teleport.Teleport(Teleport.Coords.Sea3) end})

local islandSec = teleTab:CreateSection("Острова")
islandSec:CreateButton({Name = "Pirate Starter", Callback = function() Teleport.Teleport(Teleport.Coords.PirateStarter) end})
islandSec:CreateButton({Name = "Marine Starter", Callback = function() Teleport.Teleport(Teleport.Coords.MarineStarter) end})
islandSec:CreateButton({Name = "Jungle", Callback = function() Teleport.Teleport(Teleport.Coords.Jungle) end})
islandSec:CreateButton({Name = "Desert", Callback = function() Teleport.Teleport(Teleport.Coords.Desert) end})
islandSec:CreateButton({Name = "Sky Islands", Callback = function() Teleport.Teleport(Teleport.Coords.SkyIslands) end})
islandSec:CreateButton({Name = "Kingdom of Rose", Callback = function() Teleport.Teleport(Teleport.Coords.KingdomRose) end})
islandSec:CreateButton({Name = "Port Town", Callback = function() Teleport.Teleport(Teleport.Coords.PortTown) end})

-- ============================================
-- НАСТРОЙКИ ВКЛАДКА
-- ============================================
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})
local genSec = setTab:CreateSection("Общие")

genSec:CreateButton({Name = "Unload Script", Callback = function()
    FastAttack:Stop()
    ESP:Stop()
    Window:Destroy()
end})

-- Горячая клавиша (Right Control)
local mainFrame = nil
local function findFrame()
    local p = gethui and gethui() or game:GetService("CoreGui")
    for _,g in ipairs(p:GetChildren()) do
        if g.Name == "Luna UI" and g:FindFirstChild("SmartWindow") then
            mainFrame = g.SmartWindow
            return true
        end
    end
    return false
end
findFrame() or task.wait(1) and findFrame()
pcall(function() Window.Bind = Enum.KeyCode.Unknown end)

local visible = true
game:GetService("UserInputService").InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        if mainFrame then mainFrame.Visible = visible end
    end
end)

if mainFrame then mainFrame.Visible = true end

-- Запуск Fast Attack по умолчанию
FastAttack:Start()

print("Abyss Hub загружен! Клавиша: Right Control")
