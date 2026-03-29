--[[
    Abyss Hub v1.3
    Исправленная версия
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

-- Загрузка Luna UI
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Luna%20UI.lua"))()
if not Luna then
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
    flower_esp = false,
    fruit_filter = "Все",
    window_bind = "RightShift"
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
        if state.speed_enabled then
            hum.WalkSpeed = 16 * state.speed
        else
            hum.WalkSpeed = 16
        end
    end
end

local function updateJump()
    if hum then
        if state.jump_enabled then
            hum.JumpPower = 50 * state.jump
        else
            hum.JumpPower = 50
        end
    end
end

RS.Heartbeat:Connect(function()
    updateChar()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- FAST ATTACK
-- ============================================
local attackRunning = false
local lastAttack = 0
local attackCooldown = 0.25

local function getNearestTarget()
    if not root then return nil end
    local nearest, nearestDist = nil, 25
    local pos = root.Position
    
    -- Поиск NPC
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
    
    -- Поиск игроков (если PvP режим)
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

local function performAttack()
    if not state.fast_attack then return end
    local target = getNearestTarget()
    if not target then return end
    
    local now = tick()
    if now - lastAttack < attackCooldown then return end
    
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if targetRoot and root then
        -- Поворачиваемся к цели
        root.CFrame = CFrame.new(root.Position, targetRoot.Position)
        
        -- Эмулируем атаку
        pcall(function()
            if VU then
                VU:ClickButton1()
            end
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
        
        lastAttack = now
    end
end

local function startFastAttack()
    if attackRunning then return end
    attackRunning = true
    task.spawn(function()
        while attackRunning do
            performAttack()
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
-- ESP (компактная версия)
-- ============================================
local espActive = false
local espLabels = {}

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
    bill.Size = UDim2.new(0, 150, 0, 25)
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
    
    -- Fruit ESP
    if state.fruit_esp then
        for _, f in ipairs(workspace:GetDescendants()) do
            if f:IsA("Tool") and f:FindFirstChild("Handle") then
                local r = getFruitRarity(f.Name)
                if shouldShowFruit(r) then
                    local color = r == "Mythical" and Color3.new(1, 0.33, 1) or 
                                  r == "Legendary" and Color3.new(1, 0.84, 0) or 
                                  r == "Rare" and Color3.new(0, 0.59, 1) or 
                                  Color3.new(0.78, 0.78, 0.78)
                    addLabel(f, f.Name .. " [" .. r .. "]", color, 2.5)
                else
                    pcall(function() if espLabels[f] then espLabels[f]:Destroy() end end)
                end
            end
        end
    end
    
    -- Player ESP
    if state.player_esp then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid and c.Humanoid.Health > 0 then
                    local lvl = p.Data and p.Data.Level and p.Data.Level.Value or "?"
                    addLabel(c, p.Name .. " [Lv." .. lvl .. "]", p.TeamColor and p.TeamColor.Color or Color3.new(1, 0.39, 0.39), 3)
                end
            end
        end
    end
    
    -- NPC ESP
    if state.npc_esp then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, n in ipairs(enemies:GetChildren()) do
                if n:IsA("Model") and n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 then
                    local lvl = n:FindFirstChild("Level") and n.Level.Value or "?"
                    addLabel(n, n.Name .. " [Lv." .. lvl .. "]", Color3.new(1, 0.65, 0), 3)
                end
            end
        end
    end
    
    -- Chest ESP
    if state.chest_esp then
        for _, c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                addLabel(c, "📦 " .. c.Name, Color3.new(1, 0.84, 0), 2)
            end
        end
    end
    
    -- Очистка уничтоженных объектов
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
            task.wait(0.3)
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

local function teleport(coords)
    if root then
        root.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- ИНТЕРФЕЙС
-- ============================================

Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X"}
})

-- PvP вкладка
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака врагов",
    CurrentValue = true,
    Callback = function(v)
        state.fast_attack = v
        if v then
            startFastAttack()
        else
            stopFastAttack()
        end
    end
})

pvpSec:CreateToggle({
    Name = "PvP Mode",
    Description = "Атаковать игроков",
    CurrentValue = false,
    Callback = function(v)
        state.pvp_mode = v
    end
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
        if state.speed_enabled then updateSpeed() end
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
        if state.jump_enabled then updateJump() end
    end
})

-- ESP вкладка
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")

espSec:CreateToggle({
    Name = "Fruit ESP",
    CurrentValue = false,
    Callback = function(v)
        state.fruit_esp = v
        if state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp then
            startESP()
        else
            stopESP()
        end
    end
})

espSec:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        state.player_esp = v
        if state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp then
            startESP()
        else
            stopESP()
        end
    end
})

espSec:CreateToggle({
    Name = "NPC ESP",
    CurrentValue = false,
    Callback = function(v)
        state.npc_esp = v
        if state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp then
            startESP()
        else
            stopESP()
        end
    end
})

espSec:CreateToggle({
    Name = "Chest ESP",
    CurrentValue = false,
    Callback = function(v)
        state.chest_esp = v
        if state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp then
            startESP()
        else
            stopESP()
        end
    end
})

espSec:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(v)
        state.fruit_filter = v
    end
})

-- Телепорты
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

-- Настройки
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})
local setSec = setTab:CreateSection("Общие")

local keyOptions = {"RightShift", "LeftShift", "RightControl", "LeftControl", "K", "L", "U", "I", "O", "P", "Q", "E", "R", "T", "Y", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"}

local keyDropdown = setSec:CreateDropdown({
    Name = "Клавиша открытия",
    Options = keyOptions,
    CurrentOption = state.window_bind,
    Callback = function(opt)
        local newKey = opt
        if type(opt) == "table" then
            newKey = opt[1] or state.window_bind
        end
        state.window_bind = newKey
        updateKeybind()
        Luna:Notification({Title = "Настройки", Content = "Клавиша изменена на " .. newKey, Duration = 1})
    end
})

setSec:CreateButton({
    Name = "Unload Script",
    Callback = function()
        stopFastAttack()
        stopESP()
        Window:Destroy()
        print("Abyss Hub выгружен")
    end
})

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
        _G.__keyConnection = nil
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

print("Abyss Hub загружен!")
