-- Тест Starlight UI с gethui
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

if not Starlight then return end

-- Создаём окно с указанием родителя
local Window = Starlight:CreateWindow({
    Title = "Abyss Hub",
    Subtitle = "Test",
    Size = UDim2.new(0, 500, 0, 400),
    Parent = gethui and gethui() or game:GetService("CoreGui")
})

local Tab = Window:CreateTab("Test", "📁")
local Group = Tab:CreateGroupbox("Test Group")
Group:CreateButton("Click Me", function()
    print("Clicked!")
end)

print("Тест завершён")
