-- Abyss Hub на Rayfield (рабочая версия)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Проверка игры
local gameId = game.PlaceId
local validIds = {2753915549, 4442272183, 7449423635}
local isValid = false
for _, id in ipairs(validIds) do
    if gameId == id then isValid = true break end
end
if not isValid then
    game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub работает только в Blox Fruits!")
    return
end

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "Abyss Hub",
    Icon = 0,
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "by Me",
    Theme = "Dark",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Вкладка Фарм
local FarmTab = Window:CreateTab("Фарм", 0)

-- Секция
local FarmSection = FarmTab:CreateSection("Auto Farm")

-- Кнопка
FarmTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked!")
    end
})

-- Тоггл
FarmTab:CreateToggle({
    Name = "Auto Farm (Level)",
    CurrentValue = false,
    Callback = function(Value)
        print("Auto Farm Level:", Value)
    end
})

-- Дропдаун
FarmTab:CreateDropdown({
    Name = "Weapon",
    Options = {"Fruit", "Sword", "Melee"},
    CurrentOption = {"Sword"},
    Callback = function(Option)
        print("Weapon:", Option)
    end
})

-- Слайдер
FarmTab:CreateSlider({
    Name = "Speed",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(Value)
        print("Speed:", Value)
    end
})

-- Уведомление
Rayfield:Notify({
    Title = "Abyss Hub",
    Content = "Скрипт загружен!",
    Duration = 3
})

print("Abyss Hub загружен (Rayfield)")
