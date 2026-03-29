--[[
    Abyss Hub v1.5
    Исправленный
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

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local VU = syn and syn.virtual_user or (getrenv and getrenv().virtual_user)
local TweenService = game:GetService("TweenService")

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
    window_bind = "RightShift",
    ui_visible = true
}

-- ============================================
-- СОЗДАНИЕ GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbyssHub"
screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 550)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Скругление углов
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Abyss Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Контент (скроллинг)
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -45)
scrollFrame.Position = UDim2.new(0, 0, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ GUI
-- ============================================
local function createSection(parent, text)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 38)
    section.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = section
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(180, 180, 255)
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = section
    
    return section
end

local function createToggle(parent, text, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 52, 0, 30)
    toggleBtn.Position = UDim2.new(1, -64, 0, 7)
    toggleBtn.BackgroundColor3 = defaultValue and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(70, 70, 90)
    toggleBtn.Text = defaultValue and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = toggleBtn
    
    local value = defaultValue
    toggleBtn.MouseButton1Click:Connect(function()
        value = not value
        toggleBtn.BackgroundColor3 = value and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(70, 70, 90)
        toggleBtn.Text = value and "ON" or "OFF"
        callback(value)
    end)
    
    return toggleBtn
end

local function createSlider(parent, text, min, max, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 55, 0, 22)
    valueLabel.Position = UDim2.new(1, -67, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(defaultValue) .. "x"
    valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    valueLabel.TextSize = 13
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -24, 0, 4)
    slider.Position = UDim2.new(0, 12, 0, 40)
    slider.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 2)
    sliderCorner.Parent = slider
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = fill
    
    local dragging = false
    local value = defaultValue
    
    local function updateValue(x)
        local pos = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        value = min + pos * (max - min)
        value = math.floor(value * 10) / 10
        fill.Size = UDim2.new(pos, 0, 1, 0)
        valueLabel.Text = tostring(value) .. "x"
        callback(value)
    end
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input.Position.X)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    slider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)
    
    return slider
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
    end)
    
    return btn
end

-- ============================================
-- СКОРОСТЬ И ПРЫЖОК (исправлено)
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

-- Постоянное обновление
RS.Heartbeat:Connect(function()
    updateChar()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- FAST ATTACK (только первая M1 атака)
-- ============================================
local attackRunning = false
local lastAttack = 0
local attackCooldown = 0.18

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
        
        -- Эмулируем только первую M1 атаку (короткий клик)
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            -- Короткий клик мыши (только первая атака)
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.03)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            
            -- Дополнительный способ для некоторых экзекуторов
            if VU then
                VU:ClickButton1()
            end
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

-- Запускаем
startFastAttack()

-- ============================================
-- ESP
-- ============================================
local espLabels = {}

local function addLabel(obj, text, color)
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
    bill.Size = UDim2.new(0, 120, 0, 22)
    bill.StudsOffset = Vector3.new(0, 2.8, 0)
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

local espActive = false
local function updateESP()
    if not espActive then return end
    
    if state.player_esp then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid and c.Humanoid.Health > 0 then
                    local lvl = p.Data and p.Data.Level and p.Data.Level.Value or "?"
                    addLabel(c, p.Name .. " [Lv." .. lvl .. "]", p.TeamColor and p.TeamColor.Color or Color3.new(1, 0.5, 0.5))
                end
            end
        end
    end
    
    if state.npc_esp then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, n in ipairs(enemies:GetChildren()) do
                if n:IsA("Model") and n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 then
                    local lvl = n:FindFirstChild("Level") and n.Level.Value or "?"
                    addLabel(n, n.Name .. " [Lv." .. lvl .. "]", Color3.new(1, 0.7, 0))
                end
            end
        end
    end
    
    if state.fruit_esp then
        for _, f in ipairs(workspace:GetDescendants()) do
            if f:IsA("Tool") and f:FindFirstChild("Handle") then
                addLabel(f, f.Name, Color3.new(0, 1, 0))
            end
        end
    end
    
    if state.chest_esp then
        for _, c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                addLabel(c, "📦 Chest", Color3.new(1, 0.8, 0))
            end
        end
    end
    
    if state.island_esp then
        for _, i in ipairs(workspace:GetChildren()) do
            if i:IsA("Model") and (i.Name:lower():find("island") or i.Name:lower():find("town") or i.Name:lower():find("port")) then
                addLabel(i, "🏝️ " .. i.Name, Color3.new(0.5, 0.8, 1), 15)
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
-- СОЗДАНИЕ GUI (все секции)
-- ============================================

-- PvP секция
createSection(scrollFrame, "⚔️ PvP Functions")
createToggle(scrollFrame, "Fast Attack", true, function(v)
    state.fast_attack = v
    if v then startFastAttack() else stopFastAttack() end
end)
createToggle(scrollFrame, "PvP Mode", false, function(v) state.pvp_mode = v end)
createToggle(scrollFrame, "Speed Boost", false, function(v) 
    state.speed_enabled = v
    updateSpeed()
end)
createSlider(scrollFrame, "Speed Multiplier", 1, 10, 1, function(v) 
    state.speed = v
    if state.speed_enabled then updateSpeed() end
end)
createToggle(scrollFrame, "Jump Boost", false, function(v) 
    state.jump_enabled = v
    updateJump()
end)
createSlider(scrollFrame, "Jump Multiplier", 1, 10, 1, function(v) 
    state.jump = v
    if state.jump_enabled then updateJump() end
end)

-- ESP секция
createSection(scrollFrame, "👁️ ESP Functions")
createToggle(scrollFrame, "Player ESP", false, function(v)
    state.player_esp = v
    local any = state.player_esp or state.npc_esp or state.fruit_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createToggle(scrollFrame, "NPC ESP", false, function(v)
    state.npc_esp = v
    local any = state.player_esp or state.npc_esp or state.fruit_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createToggle(scrollFrame, "Fruit ESP", false, function(v)
    state.fruit_esp = v
    local any = state.player_esp or state.npc_esp or state.fruit_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createToggle(scrollFrame, "Chest ESP", false, function(v)
    state.chest_esp = v
    local any = state.player_esp or state.npc_esp or state.fruit_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createToggle(scrollFrame, "Island ESP", false, function(v)
    state.island_esp = v
    local any = state.player_esp or state.npc_esp or state.fruit_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)

-- Телепорты секция
createSection(scrollFrame, "🌀 Teleports")
createButton(scrollFrame, "Teleport to 1st Sea", function() teleport(seaCoords["1st Sea"]) end)
createButton(scrollFrame, "Teleport to 2nd Sea", function() teleport(seaCoords["2nd Sea"]) end)
createButton(scrollFrame, "Teleport to 3rd Sea", function() teleport(seaCoords["3rd Sea"]) end)

-- Настройки секция
createSection(scrollFrame, "⚙️ Settings")

-- Кнопка смены клавиши
local keyBtn = createButton(scrollFrame, "Change Keybind (Current: " .. state.window_bind .. ")", nil)
local keyOptions = {"RightShift", "LeftShift", "K", "L", "U", "I", "O", "P", "Q", "E", "R", "T", "Y", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"}
local keyIndex = 1
for i, k in ipairs(keyOptions) do
    if k == state.window_bind then keyIndex = i break end
end

keyBtn.MouseButton1Click:Connect(function()
    keyIndex = keyIndex % #keyOptions + 1
    local newKey = keyOptions[keyIndex]
    state.window_bind = newKey
    keyBtn.Text = "Change Keybind (Current: " .. newKey .. ")"
    updateKeybind()
end)

createButton(scrollFrame, "Unload Script", function()
    stopFastAttack()
    stopESP()
    screenGui:Destroy()
    print("Abyss Hub выгружен")
end)

-- Обновляем CanvasSize
local function updateCanvas()
    local height = 0
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") then
            height = height + child.Size.Y.Offset + 10
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, height + 20)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
task.wait(0.1)
updateCanvas()

-- ============================================
-- ГОРЯЧАЯ КЛАВИША
-- ============================================
local visible = true

closeBtn.MouseButton1Click:Connect(function()
    visible = false
    mainFrame.Visible = false
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
            mainFrame.Visible = visible
        end
    end)
end

updateKeybind()

-- Перетаскивание окна
local dragging = false
local dragStart, frameStart

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStart = mainFrame.Position
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X, frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- Уведомление
print("Abyss Hub загружен! Клавиша: " .. state.window_bind)
