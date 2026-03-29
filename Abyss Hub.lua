--[[
    Abyss Hub v2.4
    Luna UI + Исправленный Fast Attack (только первая M1)
]]

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

-- Загрузка Luna UI (используем надёжный источник)
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Luna%20UI.lua"))()
if not Luna then
    -- Fallback: создаём простой GUI если Luna не загрузилась
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AbyssHub"
    screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.5, -200)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "Abyss Hub"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, -40)
    label.Position = UDim2.new(0, 0, 0, 40)
    label.Text = "Ошибка загрузки Luna UI\nПожалуйста, перезапустите скрипт"
    label.TextColor3 = Color3.fromRGB(255, 100, 100)
    label.TextWrapped = true
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Luna UI")
    return
end

-- Создание окна
local Window = Luna:CreateWindow({
    Name = "Abyss Hub",
    Subtitle = "Blox Fruits",
    LogoID = "6031097225",
    LoadingEnabled = true,
    LoadingTitle = "Abyss Hub",
    LoadingSubtitle = "Loading...",
    KeySystem = false
})

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VU = syn and syn.virtual_user or (getrenv and getrenv().virtual_user)

local char, root, hum
local function updateChar()
    char = LP.Character
    if char then
        root = char:FindFirstChild("HumanoidRootPart")
        hum = char:FindFirstChild("Humanoid")
    end
end
LP.CharacterAdded:Connect(updateChar)
updateChar()

-- Состояние
local state = {
    fast_attack = true,
    pvp_mode = false,
    speed_enabled = false,
    speed = 1,
    jump_enabled = false,
    jump = 1,
    fruit_esp = false,
    player_esp = false,
    npc_esp = false,
    chest_esp = false,
    island_esp = false,
    fruit_filter = "Все",
    window_bind = "RightControl"
}

-- ============================================
-- ОТКЛЮЧЕНИЕ РАЗМЫТИЯ
-- ============================================
local function killBlur()
    for _, e in ipairs(game:GetService("Lighting"):GetChildren()) do
        if e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then
            e:Destroy()
        end
    end
    local p = gethui and gethui() or game:GetService("CoreGui")
    for _, g in ipairs(p:GetDescendants()) do
        if g:IsA("DepthOfFieldEffect") or g:IsA("BlurEffect") then
            g:Destroy()
        end
    end
end
_G.BlurModule = function() end
killBlur()

-- ============================================
-- СКОРОСТЬ И ПРЫЖОК
-- ============================================
local function updateSpeed()
    if hum then
        hum.WalkSpeed = state.speed_enabled and 16 * state.speed or 16
    end
end

local function updateJump()
    if hum then
        hum.JumpPower = state.jump_enabled and 50 * state.jump or 50
    end
end

RS.Heartbeat:Connect(function()
    updateChar()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- FAST ATTACK (ТОЛЬКО ПЕРВАЯ M1 АТАКА)
-- ============================================
local attackRunning = false
local lastAttack = 0
local attackCooldown = 0.18

-- Функция для получения ближайшей цели
local function getNearestTarget()
    if not root then return nil end
    local nearest, nearestDist = nil, 22
    local pos = root.Position
    
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, npc in ipairs(enemies:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                if npcRoot then
                    local dist = (pos - npcRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest = npc
                    end
                end
            end
        end
    end
    
    if state.pvp_mode then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP then
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local charRoot = char:FindFirstChild("HumanoidRootPart")
                    if charRoot then
                        local dist = (pos - charRoot.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearest = char
                        end
                    end
                end
            end
        end
    end
    
    return nearest
end

-- Атака только первой M1 (короткий клик без задержки)
local function performFirstM1Attack()
    if not state.fast_attack then return end
    local target = getNearestTarget()
    if not target then return end
    
    local now = tick()
    if now - lastAttack < attackCooldown then return end
    
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if targetRoot and root then
        -- Поворачиваемся к цели
        root.CFrame = CFrame.new(root.Position, targetRoot.Position)
        
        -- Только первая M1 атака (очень короткий клик)
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            -- Короткий клик мыши (только первая атака)
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02) -- Минимальная задержка для регистрации клика
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
        
        lastAttack = now
    end
end

-- Запуск цикла атаки
local function startFastAttack()
    if attackRunning then return end
    attackRunning = true
    task.spawn(function()
        while attackRunning do
            performFirstM1Attack()
            task.wait(attackCooldown)
        end
    end)
end

local function stopFastAttack()
    attackRunning = false
end

-- Запускаем по умолчанию
startFastAttack()

-- ============================================
-- ESP (только Devil Fruits)
-- ============================================
local espLabels = {}
local espActive = false

-- Список настоящих Devil Fruits
local devilFruits = {
    "Bomb", "Spike", "Chop", "Spring", "Kilo", "Spin",
    "Flame", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake",
    "Buddha", "Love", "Spider", "Phoenix", "Portal", "Rumble",
    "Dragon", "Leopard", "Mammoth", "T-Rex", "Spirit", "Venom", "Control", "Gravity", "Shadow", "Dough"
}

local function isDevilFruit(obj)
    if not obj:IsA("Tool") then return false end
    local name = obj.Name
    for _, fruit in ipairs(devilFruits) do
        if name:find(fruit) then return true end
    end
    return false
end

local function getFruitRarity(name)
    local common = {"Bomb", "Spike", "Chop", "Spring", "Kilo", "Spin"}
    local rare = {"Flame", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake"}
    local legendary = {"Buddha", "Love", "Spider", "Phoenix", "Portal", "Rumble"}
    local mythical = {"Dragon", "Leopard", "Mammoth", "T-Rex", "Spirit", "Venom", "Control", "Gravity", "Shadow", "Dough"}
    
    for _, n in ipairs(common) do if name:find(n) then return "Common" end end
    for _, n in ipairs(rare) do if name:find(n) then return "Rare" end end
    for _, n in ipairs(legendary) do if name:find(n) then return "Legendary" end end
    for _, n in ipairs(mythical) do if name:find(n) then return "Mythical" end end
    return "Unknown"
end

local function shouldShowFruit(rarity)
    local f = state.fruit_filter
    if f == "Все" then return true end
    if f == "Rare+" then return rarity == "Rare" or rarity == "Legendary" or rarity == "Mythical" end
    if f == "Legendary+" then return rarity == "Legendary" or rarity == "Mythical" end
    if f == "Mythical" then return rarity == "Mythical" end
    return true
end

local function addLabel(obj, text, color, offset)
    if not obj then return end
    for o, l in pairs(espLabels) do
        if l and l.Adornee == obj then
            local tl = l:FindFirstChild("TextLabel")
            if tl then tl.Text = text end
            return
        end
    end
    
    local bill = Instance.new("BillboardGui")
    bill.Adornee = obj
    bill.Size = UDim2.new(0, 140, 0, 24)
    bill.StudsOffset = Vector3.new(0, offset or 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = obj
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    
    espLabels[obj] = bill
end

local function clearESP()
    for _, l in pairs(espLabels) do
        pcall(function() l:Destroy() end)
    end
    espLabels = {}
end

local function updateESP()
    if not espActive then return end
    
    if state.fruit_esp then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if isDevilFruit(obj) then
                local r = getFruitRarity(obj.Name)
                if shouldShowFruit(r) then
                    local color = r == "Mythical" and Color3.new(1, 0.33, 1) or 
                                  r == "Legendary" and Color3.new(1, 0.84, 0) or 
                                  r == "Rare" and Color3.new(0, 0.59, 1) or 
                                  Color3.new(0.78, 0.78, 0.78)
                    addLabel(obj, obj.Name .. " [" .. r .. "]", color, 2.5)
                end
            end
        end
    end
    
    if state.player_esp then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid and c.Humanoid.Health > 0 then
                    addLabel(c, p.Name, p.TeamColor and p.TeamColor.Color or Color3.new(1, 0.5, 0.5), 3)
                end
            end
        end
    end
    
    if state.npc_esp then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, n in ipairs(enemies:GetChildren()) do
                if n:IsA("Model") and n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 then
                    addLabel(n, n.Name, Color3.new(1, 0.7, 0), 3)
                end
            end
        end
    end
    
    if state.chest_esp then
        for _, c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                addLabel(c, "📦 Chest", Color3.new(1, 0.84, 0), 2)
            end
        end
    end
    
    if state.island_esp then
        for _, i in ipairs(workspace:GetChildren()) do
            if i:IsA("Model") and (i.Name:lower():find("island") or i.Name:lower():find("town") or i.Name:lower():find("port")) then
                addLabel(i, "🏝️ " .. i.Name, Color3.new(0.5, 0.8, 1), 12)
            end
        end
    end
    
    for obj, label in pairs(espLabels) do
        if not obj or not obj.Parent then
            pcall(function() label:Destroy() end)
            espLabels[obj] = nil
        end
    end
end

local function startESP()
    if espActive then return end
    espActive = true
    task.spawn(function()
        while espActive do
            updateESP()
            task.wait(0.35)
        end
    end)
end

local function stopESP()
    espActive = false
    clearESP()
end

-- ============================================
-- ТЕЛЕПОРТЫ
-- ============================================
local seaCoords = {
    ["1st Sea"] = Vector3.new(-1250, 80, 330),
    ["2nd Sea"] = Vector3.new(-1250, 80, 330),
    ["3rd Sea"] = Vector3.new(-1250, 80, 330)
}

local islands = {
    ["Pirate Starter"] = Vector3.new(-1150, 80, 380),
    ["Marine Starter"] = Vector3.new(-1150, 80, 380),
    ["Jungle"] = Vector3.new(-1150, 80, 380),
    ["Desert"] = Vector3.new(-1150, 80, 380),
    ["Sky Islands"] = Vector3.new(-1150, 80, 380),
    ["Kingdom of Rose"] = Vector3.new(-1150, 80, 380),
    ["Port Town"] = Vector3.new(-1150, 80, 380)
}

local function teleport(coords)
    if root then
        root.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- СОЗДАНИЕ ВКЛАДОК
-- ============================================

Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X", "Solara", "Hydrogen"}
})

-- Вкладка PvP
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака (только первая M1)",
    CurrentValue = true,
    Callback = function(v)
        state.fast_attack = v
        if v then startFastAttack() else stopFastAttack() end
    end
})

pvpSec:CreateToggle({
    Name = "PvP Mode",
    Description = "Атаковать игроков",
    CurrentValue = false,
    Callback = function(v) state.pvp_mode = v end
})

pvpSec:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(v)
        state.speed_enabled = v
        updateSpeed()
    end
})

pvpSec:CreateSlider({
    Name = "Speed Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v)
        state.speed = v
        if state.speed_enabled then updateSpeed()
    end
})

pvpSec:CreateToggle({
    Name = "Jump Boost",
    CurrentValue = false,
    Callback = function(v)
        state.jump_enabled = v
        updateJump()
    end
})

pvpSec:CreateSlider({
    Name = "Jump Multiplier",
    Range = {1, 10},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v)
        state.jump = v
        if state.jump_enabled then updateJump()
    end
})

-- Вкладка ESP
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")

espSec:CreateToggle({
    Name = "Fruit ESP",
    Description = "Показывает Devil Fruits на карте",
    CurrentValue = false,
    Callback = function(v)
        state.fruit_esp = v
        local any = state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(v)
        state.fruit_filter = v
        if state.fruit_esp then updateESP() end
    end
})

espSec:CreateToggle({
    Name = "Player ESP",
    Description = "Показывает игроков",
    CurrentValue = false,
    Callback = function(v)
        state.player_esp = v
        local any = state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "NPC ESP",
    Description = "Показывает NPC и мобов",
    CurrentValue = false,
    Callback = function(v)
        state.npc_esp = v
        local any = state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "Chest ESP",
    Description = "Показывает сундуки",
    CurrentValue = false,
    Callback = function(v)
        state.chest_esp = v
        local any = state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "Island ESP",
    Description = "Показывает названия островов",
    CurrentValue = false,
    Callback = function(v)
        state.island_esp = v
        local any = state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

-- Вкладка Телепорты
local teleTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local teleSec = teleTab:CreateSection("Телепорт между морями")

teleSec:CreateButton({
    Name = "Teleport to 1st Sea",
    Callback = function()
        teleport(seaCoords["1st Sea"])
        Luna:Notification({Title = "Телепорт", Content = "1st Sea"})
    end
})

teleSec:CreateButton({
    Name = "Teleport to 2nd Sea",
    Callback = function()
        teleport(seaCoords["2nd Sea"])
        Luna:Notification({Title = "Телепорт", Content = "2nd Sea"})
    end
})

teleSec:CreateButton({
    Name = "Teleport to 3rd Sea",
    Callback = function()
        teleport(seaCoords["3rd Sea"])
        Luna:Notification({Title = "Телепорт", Content = "3rd Sea"})
    end
})

local islandSec = teleTab:CreateSection("Острова")
islandSec:CreateButton({Name = "Pirate Starter", Callback = function() teleport(islands["Pirate Starter"]) end})
islandSec:CreateButton({Name = "Marine Starter", Callback = function() teleport(islands["Marine Starter"]) end})
islandSec:CreateButton({Name = "Jungle", Callback = function() teleport(islands["Jungle"]) end})
islandSec:CreateButton({Name = "Desert", Callback = function() teleport(islands["Desert"]) end})
islandSec:CreateButton({Name = "Sky Islands", Callback = function() teleport(islands["Sky Islands"]) end})
islandSec:CreateButton({Name = "Kingdom of Rose", Callback = function() teleport(islands["Kingdom of Rose"]) end})
islandSec:CreateButton({Name = "Port Town", Callback = function() teleport(islands["Port Town"]) end})

-- Вкладка Фарм
local farmTab = Window:CreateTab({Name = "Фарм", Icon = "grass", ImageSource = "Material"})
local farmSec = farmTab:CreateSection("Auto Farm")

farmSec:CreateToggle({
    Name = "Auto Farm (Уровень)",
    Description = "Автоматический фарм для поднятия уровня",
    CurrentValue = false,
    Callback = function(v) print("[Farm] Auto Farm Level:", v) end
})

farmSec:CreateToggle({
    Name = "Auto Farm (Ближайшие)",
    Description = "Фарм ближайших мобов",
    CurrentValue = false,
    Callback = function(v) print("[Farm] Auto Farm Nearby:", v) end
})

farmSec:CreateDropdown({
    Name = "Оружие",
    Options = {"Фрукт", "Меч", "Ближний бой"},
    CurrentOption = "Меч",
    Callback = function(v) print("[Farm] Weapon:", v) end
})

local bossSec = farmTab:CreateSection("Auto Farm Boss")
bossSec:CreateToggle({
    Name = "Auto Farm Boss",
    Description = "Автоматический фарм боссов",
    CurrentValue = false,
    Callback = function(v) print("[Farm] Auto Boss:", v) end
})

bossSec:CreateDropdown({
    Name = "Выбор босса",
    Options = {"Diamond", "Thunder God", "Vice Admiral"},
    CurrentOption = "Diamond",
    Callback = function(v) print("[Farm] Boss:", v) end
})

local chestSec = farmTab:CreateSection("Auto Chest")
chestSec:CreateToggle({
    Name = "Auto Chest",
    Description = "Автоматический сбор сундуков",
    CurrentValue = false,
    Callback = function(v) print("[Farm] Auto Chest:", v) end
})

-- Вкладка Raid
local raidTab = Window:CreateTab({Name = "Raid", Icon = "whatshot", ImageSource = "Material"})
local raidSec = raidTab:CreateSection("Auto Raid")

raidSec:CreateToggle({
    Name = "Auto Raid",
    Description = "Автоматический проход рейдов",
    CurrentValue = false,
    Callback = function(v) print("[Raid] Auto Raid:", v) end
})

raidSec:CreateDropdown({
    Name = "Выбор рейда",
    Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"},
    CurrentOption = "Buddha",
    Callback = function(v) print("[Raid] Type:", v) end
})

raidSec:CreateToggle({
    Name = "Kill Aura",
    Description = "Аура убийства в рейде (5 остров)",
    CurrentValue = false,
    Callback = function(v) print("[Raid] Kill Aura:", v) end
})

-- Вкладка Настройки
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})

local configSec = setTab:CreateSection("Конфигурации")
configSec:CreateButton({Name = "Создать конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
configSec:CreateButton({Name = "Сохранить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
configSec:CreateButton({Name = "Загрузить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})

local generalSec = setTab:CreateSection("Общие")

local keyOptions = {"RightControl", "RightShift", "LeftShift", "K", "L", "U", "I", "O", "P", "Q", "E", "R", "T", "Y"}
local keyDropdown = generalSec:CreateDropdown({
    Name = "Клавиша открытия",
    Options = keyOptions,
    CurrentOption = "RightControl",
    Callback = function(opt)
        local newKey = opt
        if type(opt) == "table" then newKey = opt[1] or "RightControl" end
        state.window_bind = newKey
        updateKeybind()
        Luna:Notification({Title = "Настройки", Content = "Клавиша изменена на " .. newKey, Duration = 1})
    end
})

generalSec:CreateButton({Name = "Auto Update", Callback = function() Luna:Notification({Title = "Обновление", Content = "Последняя версия"}) end})
generalSec:CreateButton({Name = "Unload Script", Callback = function()
    stopFastAttack()
    stopESP()
    Window:Destroy()
    print("Abyss Hub выгружен")
end})
generalSec:CreateToggle({Name = "Mobile Support", CurrentValue = UIS.TouchEnabled, Callback = function(v) print("[Settings] Mobile:", v) end})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША
-- ============================================
local mainFrame = nil
local shadowHolder = nil
local visible = true

local function findLunaWindow()
    local parent = gethui and gethui() or game:GetService("CoreGui")
    for _, gui in ipairs(parent:GetChildren()) do
        if gui.Name == "Luna UI" or (gui.Name and string.find(gui.Name, "Luna")) then
            if gui:FindFirstChild("SmartWindow") then
                mainFrame = gui.SmartWindow
                shadowHolder = gui:FindFirstChild("ShadowHolder")
                return true
            end
        end
    end
    return false
end

findLunaWindow()
if not mainFrame then
    task.wait(1)
    findLunaWindow()
end

-- Отключаем встроенный бинд
pcall(function()
    if Window._bindConnection then
        Window._bindConnection:Disconnect()
    end
    Window.Bind = Enum.KeyCode.Unknown
end)

local function updateKeybind()
    if _G.__keyConnection then
        _G.__keyConnection:Disconnect()
    end
    
    local currentBind = state.window_bind
    
    _G.__keyConnection = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local keyName = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
        
        if keyName == currentBind then
            visible = not visible
            if mainFrame then
                mainFrame.Visible = visible
                if shadowHolder then
                    shadowHolder.Visible = visible
                end
            end
        end
    end)
end

updateKeybind()

-- Показываем интерфейс
task.wait(0.5)
if mainFrame then
    mainFrame.Visible = true
    if shadowHolder then
        shadowHolder.Visible = true
    end
end

-- Уведомление
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт загружен! Клавиша: " .. state.window_bind,
    Icon = "sparkle",
    ImageSource = "Material",
    Duration = 3
})

print("Abyss Hub загружен! Клавиша открытия:", state.window_bind)
