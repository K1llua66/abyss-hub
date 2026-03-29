-- XUI тест (встроенный GUI Xeno)
local XUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xeno-executor/xui/main/source.lua"))()

local Window = XUI:CreateWindow("Abyss Hub", "Blox Fruits")
local FarmTab = Window:CreateTab("Farm")

FarmTab:CreateToggle("Auto Farm (Level)", false, function(state)
    print("[Farm] Level:", state)
end)

FarmTab:CreateToggle("Auto Farm (Nearby)", false, function(state)
    print("[Farm] Nearby:", state)
end)

FarmTab:CreateButton("Teleport to 1st Sea", function()
    print("[Teleport] 1st Sea")
end)

print("XUI loaded")
