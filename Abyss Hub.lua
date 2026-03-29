-- Тест: 3 группы в одной вкладке
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

local Window = Starlight:CreateWindow({
    Title = "Test",
    Size = UDim2.new(0, 600, 0, 600)
})

local MainSection = Window:CreateTabSection("Main", true)
local Tab = MainSection:CreateTab({Name = "Test", Columns = 1}, "test")

-- Группа 1
local G1 = Tab:CreateGroupbox({Name = "Group 1 - Auto Farm", Column = 1, Style = 1}, "g1")
G1:CreateToggle({Name = "Toggle 1", CurrentValue = false, Callback = function(s) print("1:", s) end}, "t1")
G1:CreateToggle({Name = "Toggle 2", CurrentValue = false, Callback = function(s) print("2:", s) end}, "t2")

-- Группа 2
local G2 = Tab:CreateGroupbox({Name = "Group 2 - Auto Farm Boss", Column = 1, Style = 1}, "g2")
G2:CreateToggle({Name = "Toggle 3", CurrentValue = false, Callback = function(s) print("3:", s) end}, "t3")

-- Группа 3
local G3 = Tab:CreateGroupbox({Name = "Group 3 - Auto Mastery", Column = 1, Style = 1}, "g3")
G3:CreateToggle({Name = "Toggle 4", CurrentValue = false, Callback = function(s) print("4:", s) end}, "t4")

print("Тест: 3 группы добавлены")
