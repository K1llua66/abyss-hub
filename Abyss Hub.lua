-- ФИНАЛЬНЫЙ ТЕСТ: 3 группы в одной вкладке
print("=== СТАРТ ТЕСТА ===")

local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()
if not Starlight then
    print("❌ Starlight не загрузился")
    return
end
print("✅ Starlight загружен")

local Window = Starlight:CreateWindow({
    Title = "TEST",
    Subtitle = "3 Groups Test",
    Size = UDim2.new(0, 550, 0, 500)
})
print("✅ Окно создано")

local MainSection = Window:CreateTabSection("Test Section", true)
print("✅ Секция создана")

local TestTab = MainSection:CreateTab({Name = "TEST TAB", Columns = 1}, "test")
print("✅ Вкладка создана")

-- ГРУППА 1
local G1 = TestTab:CreateGroupbox({Name = "GROUP 1 - Auto Farm", Column = 1, Style = 1}, "g1")
print("✅ Группа 1 создана")
G1:CreateToggle({Name = "Toggle 1", CurrentValue = false, Callback = print}, "t1")
G1:CreateToggle({Name = "Toggle 2", CurrentValue = false, Callback = print}, "t2")
print("✅ Toggle 1 и 2 добавлены")

-- ГРУППА 2
local G2 = TestTab:CreateGroupbox({Name = "GROUP 2 - Auto Farm Boss", Column = 1, Style = 1}, "g2")
print("✅ Группа 2 создана")
G2:CreateToggle({Name = "Toggle 3", CurrentValue = false, Callback = print}, "t3")
print("✅ Toggle 3 добавлен")

-- ГРУППА 3
local G3 = TestTab:CreateGroupbox({Name = "GROUP 3 - Auto Mastery", Column = 1, Style = 1}, "g3")
print("✅ Группа 3 создана")
G3:CreateToggle({Name = "Toggle 4", CurrentValue = false, Callback = print}, "t4")
print("✅ Toggle 4 добавлен")

print("=== ТЕСТ ЗАВЕРШЁН ===")
print("Должно быть 3 группы с тогглами. Если видите только одну группу -> лимит Starlight.")
Window:Notify("Test", "3 groups added. Scroll down!", 3)
