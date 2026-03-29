-- ПРОСТЕЙШИЙ ТЕСТ STARLIGHT UI
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

if not Starlight then
    warn("Starlight не загрузился")
    return
end

print("Starlight загружен, создаём окно")

local Window = Starlight:CreateWindow({
    Title = "ABYSS HUB",
    Subtitle = "Test",
    Size = UDim2.new(0, 500, 0, 400)
})

print("Окно создано, создаём вкладку")

local TestTab = Window:CreateTab("Test", "📁")

print("Вкладка создана, создаём группу")

local Group = TestTab:CreateGroupbox("Test Group")

print("Группа создана, добавляем кнопку")

Group:CreateButton("Click Me", function()
    print("CLICKED!")
    Window:Notify("Test", "Button clicked!", 2)
end)

print("Всё создано, ждём...")
