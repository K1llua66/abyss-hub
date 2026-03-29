-- Тест Starlight UI (простой)
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()
if not Starlight then return end

local Window = Starlight:CreateWindow({Title = "Test", Size = UDim2.new(0, 500, 0, 400)})

-- Пробуем создать вкладку
local Tab = Window:CreateTab("Test", "📁")
local Group = Tab:CreateGroupbox("Test Group")
Group:CreateButton("Click", function() print("click") end)

print("Готово")
