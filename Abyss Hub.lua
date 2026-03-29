-- Тест Rayfield с gethui
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Создаём окно с указанием родителя через gethui
local Window = Rayfield:CreateWindow({
    Name = "Abyss Hub",
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "Testing",
    Theme = "Dark",
    Parent = gethui and gethui() or game:GetService("CoreGui")
})

local Tab = Window:CreateTab("Test")

Tab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Clicked!")
    end
})

Rayfield:Notify({
    Title = "Test",
    Content = "If you see this, it works!",
    Duration = 3
})
