-- Минимальный тест Starlight UI

-- Загрузка Starlight
local Starlight = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Starlight%20UI.lua"))()

if not Starlight then
    warn("Starlight не загрузился")
    return
end

print("Starlight загружен, создаём окно...")

-- Создание окна
local Window = Starlight:CreateWindow({
    Title = "TEST WINDOW",
    Subtitle = "If you see this, Starlight works",
    Size = UDim2.new(0, 500, 0, 400),
    Theme = "Starlight"
})

print("Окно создано, создаём секцию...")

-- Создаём секцию вкладок (ОБЯЗАТЕЛЬНО)
local MainSection = Window:CreateTabSection("Main", true)

print("Секция создана, создаём вкладку...")

-- Создаём одну вкладку
local TestTab = MainSection:CreateTab({
    Name = "TEST",
    Columns = 1
}, "test_tab")

print("Вкладка создана, создаём группу...")

-- Создаём группу
local TestGroup = TestTab:CreateGroupbox({
    Name = "Test Group",
    Column = 1
}, "test_group")

print("Группа создана, добавляем кнопку...")

-- Добавляем кнопку
TestGroup:CreateButton({
    Name = "CLICK ME",
    Callback = function()
        print("BUTTON CLICKED!")
        Window:Notify("Test", "Button clicked!", 2)
    end
}, "test_btn")

print("Кнопка добавлена, добавляем тоггл...")

-- Добавляем тоггл
TestGroup:CreateToggle({
    Name = "Test Toggle",
    CurrentValue = false,
    Callback = function(state)
        print("Toggle state:", state)
    end
}, "test_toggle")

print("Тоггл добавлен!")

-- Уведомление
Window:Notify("Abyss Hub", "Тестовое окно загружено!", 3)
print("Тест завершён, интерфейс должен появиться")
