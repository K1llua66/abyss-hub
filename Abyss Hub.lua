-- Тест: несколько групп в одной вкладке
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

if not Starlight then return end

local Window = Starlight:CreateWindow({
    Title = "Test",
    Subtitle = "Multiple Groups",
    Size = UDim2.new(0, 500, 0, 400),
    Theme = "Starlight"
})

local MainSection = Window:CreateTabSection("Test", true)

-- Одна вкладка
local TestTab = MainSection:CreateTab({
    Name = "Test Tab",
    Columns = 1
}, "test")

-- Группа 1
local Group1 = TestTab:CreateGroupbox({
    Name = "Group 1 - Auto Farm",
    Column = 1,
    Style = 1
}, "group1")

Group1:CreateToggle({
    Name = "Auto Farm (Level)",
    CurrentValue = false,
    Callback = function(s) print("Level:", s) end
}, "test1")

Group1:CreateToggle({
    Name = "Auto Farm (Nearby)",
    CurrentValue = false,
    Callback = function(s) print("Nearby:", s) end
}, "test2")

-- Группа 2
local Group2 = TestTab:CreateGroupbox({
    Name = "Group 2 - Auto Farm Boss",
    Column = 1,
    Style = 1
}, "group2")

Group2:CreateToggle({
    Name = "Auto Farm Boss",
    CurrentValue = false,
    Callback = function(s) print("Boss:", s) end
}, "test3")

Group2:CreateDropdown({
    Name = "Select Boss",
    Options = {"Diamond", "Thunder God"},
    CurrentOption = {"Diamond"},
    Callback = function(v) print("Boss:", v[1]) end
}, "boss")

-- Группа 3
local Group3 = TestTab:CreateGroupbox({
    Name = "Group 3 - Auto Mastery",
    Column = 1,
    Style = 1
}, "group3")

Group3:CreateToggle({
    Name = "Auto Mastery",
    CurrentValue = false,
    Callback = function(s) print("Mastery:", s) end
}, "test4")

print("Тест: 3 группы, каждая с элементами")
Window:Notify("Test", "3 groups added", 3)
