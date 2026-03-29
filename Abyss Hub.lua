--[[
    Abyss Hub v2.3
    Полностью автономная версия
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
-- СОЗДАНИЕ GUI
-- ============================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VU = syn and syn.virtual_user or (getrenv and getrenv().virtual_user)

-- Создание ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbyssHub"
screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
screenGui.ResetOnSpawn = false
screenGui.Enabled = true

-- ============================================
-- ГЛАВНОЕ ОКНО
-- ============================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 580)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -290)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Тень
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 0, 1, 0)
shadow.Position = UDim2.new(0, 0, 0, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 12)
shadowCorner.Parent = shadow

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Abyss Hub"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -100, 1, 0)
subtitle.Position = UDim2.new(0, 15, 0, 28)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Blox Fruits"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = titleBar

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -42, 0, 9)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Панель вкладок
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 45)
tabBar.Position = UDim2.new(0, 0, 0, 50)
tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
tabBar.BackgroundTransparency = 0.5
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

-- Скроллинг контент
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -105)
scrollFrame.Position = UDim2.new(0, 10, 0, 105)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
scrollFrame.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = scrollFrame

-- ============================================
-- ПЕРЕМЕННЫЕ
-- ============================================
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
    chest_esp = false,
    island_esp = false,
    fruit_filter = "Все",
    auto_farm = false,
    auto_chest = false,
    auto_raid = false,
    kill_aura = false
}

-- Текущая вкладка
local currentTab = nil
local tabContents = {}
local tabButtons = {}

-- ============================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ GUI
-- ============================================
local function updateCanvas()
    local height = 0
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= contentLayout then
            height = height + child.Size.Y.Offset + 10
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, height + 20)
end

local function createSection(parent, name)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 38)
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
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
    label.Text = name
    label.TextColor3 = Color3.fromRGB(180, 180, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.Parent = section
    
    return section
end

local function createToggle(parent, name, description, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, description and 62 or 44)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    if description then
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -80, 0, 18)
        desc.Position = UDim2.new(0, 12, 0, 22)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = Color3.fromRGB(140, 140, 160)
        desc.TextSize = 11
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Font = Enum.Font.Gotham
        desc.Parent = frame
    end
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 55, 0, 30)
    toggleBtn.Position = UDim2.new(1, -67, 0, description and 16 or 7)
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
    
    updateCanvas()
    return toggleBtn
end

local function createSlider(parent, name, min, max, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = name
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
    local percent = (defaultValue - min) / (max - min)
    fill.Size = UDim2.new(percent, 0, 1, 0)
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
        value = math.floor(value / 0.1 + 0.5) * 0.1
        value = math.max(min, math.min(max, value))
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
    
    updateCanvas()
    return slider
end

local function createButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    btn.Text = name
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
    
    updateCanvas()
    return btn
end

local function createDropdown(parent, name, options, defaultValue, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 48)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -120, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 100, 0, 32)
    dropdownBtn.Position = UDim2.new(1, -112, 0, 8)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    dropdownBtn.Text = defaultValue
    dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    dropdownBtn.TextSize = 12
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = dropdownBtn
    
    local isOpen = false
    local listFrame = nil
    
    dropdownBtn.MouseButton1Click:Connect(function()
        if listFrame then
            listFrame:Destroy()
            listFrame = nil
            isOpen = false
            return
        end
        
        listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(0, 100, 0, #options * 30)
        listFrame.Position = UDim2.new(1, -112, 0, 40)
        listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        listFrame.BackgroundTransparency = 0.1
        listFrame.BorderSizePixel = 0
        listFrame.Parent = frame
        
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 6)
        listCorner.Parent = listFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent = listFrame
        
        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 28)
            optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.Gotham
            optBtn.BorderSizePixel = 0
            optBtn.Parent = listFrame
            
            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn
            
            optBtn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = opt
                callback(opt)
                listFrame:Destroy()
                listFrame = nil
                isOpen = false
            end)
        end
    end)
    
    updateCanvas()
    return dropdownBtn
end

-- ============================================
-- ФУНКЦИИ СКРИПТА
-- ============================================

-- Скорость
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

-- Fast Attack
local attackRunning = false
local lastAttack = 0
local attackCooldown = 0.12

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
        root.CFrame = CFrame.new(root.Position, targetRoot.Position)
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.02)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            if VU then VU:ClickButton1() end
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

startFastAttack()

-- ESP
local espLabels = {}
local espActive = false

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

-- Телепорты
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
    ["Port Town"] = Vector3.new(-1150, 80, 380),
    ["Hydra Island"] = Vector3.new(-1150, 80, 380),
    ["Great Tree"] = Vector3.new(-1150, 80, 380)
}

local function teleport(coords)
    if root then
        root.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- СОЗДАНИЕ ВКЛАДОК
-- ============================================

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.BorderSizePixel = 0
    btn.Parent = tabBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = scrollFrame
    
    local contentLayoutInner = Instance.new("UIListLayout")
    contentLayoutInner.Padding = UDim.new(0, 8)
    contentLayoutInner.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayoutInner.Parent = content
    
    tabButtons[name] = btn
    tabContents[name] = {content = content, layout = contentLayoutInner}
    
    btn.MouseButton1Click:Connect(function()
        for _, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            tb.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
        for _, tc in pairs(tabContents) do
            tc.content.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 85)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
        currentTab = name
        updateCanvas()
    end)
    
    if not currentTab then
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 85)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        content.Visible = true
        currentTab = name
    end
    
    return content
end

-- Создание вкладок
local pvpContent = createTab("PvP", "⚔️")
local espContent = createTab("ESP", "👁️")
local teleContent = createTab("Телепорты", "🌀")
local farmContent = createTab("Фарм", "🌾")
local raidContent = createTab("Raid", "🔥")
local settingsContent = createTab("Настройки", "⚙️")

-- PvP вкладка
local pvpSection = createSection(pvpContent, "PvP Functions")
createToggle(pvpSection, "Fast Attack", "Автоматическая атака", true, function(v)
    state.fast_attack = v
    if v then startFastAttack() else stopFastAttack() end
end)
createToggle(pvpSection, "PvP Mode", "Атаковать игроков", false, function(v) state.pvp_mode = v end)
createToggle(pvpSection, "Speed Boost", "Увеличивает скорость", false, function(v) state.speed_enabled = v; updateSpeed() end)
createSlider(pvpSection, "Speed", 1, 10, 1, function(v) state.speed = v; if state.speed_enabled then updateSpeed() end end)
createToggle(pvpSection, "Jump Boost", "Увеличивает прыжок", false, function(v) state.jump_enabled = v; updateJump() end)
createSlider(pvpSection, "Jump", 1, 10, 1, function(v) state.jump = v; if state.jump_enabled then updateJump() end end)

-- ESP вкладка
local espSection = createSection(espContent, "ESP Functions")
createToggle(espSection, "Fruit ESP", "Показывает Devil Fruits", false, function(v)
    state.fruit_esp = v
    local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createDropdown(espSection, "Fruit Rarity Filter", {"Все", "Rare+", "Legendary+", "Mythical"}, "Все", function(v)
    state.fruit_filter = v
end)
createToggle(espSection, "Player ESP", "Показывает игроков", false, function(v)
    state.player_esp = v
    local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createToggle(espSection, "Chest ESP", "Показывает сундуки", false, function(v)
    state.chest_esp = v
    local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)
createToggle(espSection, "Island ESP", "Показывает названия островов", false, function(v)
    state.island_esp = v
    local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
    if any then startESP() else stopESP() end
end)

-- Телепорты вкладка
local seaSection = createSection(teleContent, "Моря")
createButton(seaSection, "Teleport to 1st Sea", function() teleport(seaCoords["1st Sea"]) end)
createButton(seaSection, "Teleport to 2nd Sea", function() teleport(seaCoords["2nd Sea"]) end)
createButton(seaSection, "Teleport to 3rd Sea", function() teleport(seaCoords["3rd Sea"]) end)

local islandSection = createSection(teleContent, "Острова")
createButton(islandSection, "Pirate Starter", function() teleport(islands["Pirate Starter"]) end)
createButton(islandSection, "Marine Starter", function() teleport(islands["Marine Starter"]) end)
createButton(islandSection, "Jungle", function() teleport(islands["Jungle"]) end)
createButton(islandSection, "Desert", function() teleport(islands["Desert"]) end)
createButton(islandSection, "Sky Islands", function() teleport(islands["Sky Islands"]) end)
createButton(islandSection, "Kingdom of Rose", function() teleport(islands["Kingdom of Rose"]) end)
createButton(islandSection, "Port Town", function() teleport(islands["Port Town"]) end)

-- Фарм вкладка
local farmSection = createSection(farmContent, "Auto Farm")
createToggle(farmSection, "Auto Farm (Уровень)", "Автоматический фарм", false, function(v) state.auto_farm = v end)
createToggle(farmSection, "Auto Farm (Ближайшие)", "Фарм ближайших мобов", false, function(v) state.auto_farm = v end)
createDropdown(farmSection, "Оружие", {"Фрукт", "Меч", "Ближний бой"}, "Меч", function(v) print("Оружие:", v) end)

local bossSection = createSection(farmContent, "Auto Farm Boss")
createToggle(bossSection, "Auto Farm Boss", "Автоматический фарм боссов", false, function(v) end)
createDropdown(bossSection, "Выбор босса", {"Diamond", "Thunder God", "Vice Admiral"}, "Diamond", function(v) end)

local chestSection = createSection(farmContent, "Auto Chest")
createToggle(chestSection, "Auto Chest", "Автоматический сбор сундуков", false, function(v) state.auto_chest = v end)

-- Raid вкладка
local raidSection = createSection(raidContent, "Auto Raid")
createToggle(raidSection, "Auto Raid", "Автоматический рейд", false, function(v) state.auto_raid = v end)
createDropdown(raidSection, "Выбор рейда", {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, "Buddha", function(v) state.raid_type = v end)
createToggle(raidSection, "Kill Aura", "Аура убийства в рейде", false, function(v) state.kill_aura = v end)

-- Настройки вкладка
local configSection = createSection(settingsContent, "Конфигурации")
createButton(configSection, "Создать конфиг", function() print("Конфиг в разработке") end)
createButton(configSection, "Сохранить конфиг", function() print("Конфиг в разработке") end)
createButton(configSection, "Загрузить конфиг", function() print("Конфиг в разработке") end)

local generalSection = createSection(settingsContent, "Общие")
createButton(generalSection, "Unload Script", function()
    stopFastAttack()
    stopESP()
    screenGui:Destroy()
    print("Abyss Hub выгружен")
end)

-- ============================================
-- ПЕРЕТАСКИВАНИЕ ОКНА
-- ============================================
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

-- ============================================
-- ГОРЯЧАЯ КЛАВИША (Right Control)
-- ============================================
local visible = true

closeBtn.MouseButton1Click:Connect(function()
    visible = false
    screenGui.Enabled = false
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        screenGui.Enabled = visible
    end
end)

-- ============================================
-- ЗАПУСК
-- ============================================
updateCanvas()
print("Abyss Hub загружен! Клавиша: Right Control")
