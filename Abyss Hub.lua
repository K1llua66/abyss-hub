--[[
    Abyss Hub v2.2
    Полная версия со встроенным Luna UI
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
-- ВСТРОЕННЫЙ LUNA UI (упрощённая версия)
-- ============================================
local Luna = {}
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Создание GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LunaUI"
screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 550)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 48)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
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
closeBtn.Position = UDim2.new(1, -42, 0, 8)
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

-- Контейнер для вкладок
local tabsContainer = Instance.new("Frame")
tabsContainer.Size = UDim2.new(1, 0, 0, 45)
tabsContainer.Position = UDim2.new(0, 0, 0, 48)
tabsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabsContainer.BackgroundTransparency = 0.3
tabsContainer.BorderSizePixel = 0
tabsContainer.Parent = mainFrame

-- Скроллинг фрейм для контента
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, -93)
scrollFrame.Position = UDim2.new(0, 0, 0, 93)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- Таблицы для вкладок
local tabs = {}
local currentTab = nil

-- Функция для создания вкладки
function Luna:CreateTab(settings)
    local tabName = settings.Name
    local tabIcon = settings.Icon or "star"
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0, 100, 1, 0)
    tabFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    tabFrame.BackgroundTransparency = 0.5
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = tabsContainer
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = tabFrame
    
    local btnLabel = Instance.new("TextLabel")
    btnLabel.Size = UDim2.new(1, 0, 1, 0)
    btnLabel.BackgroundTransparency = 1
    btnLabel.Text = tabName
    btnLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    btnLabel.TextSize = 13
    btnLabel.Font = Enum.Font.Gotham
    btnLabel.Parent = tabFrame
    
    -- Контент вкладки
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 0, 0)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = scrollFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = content
    
    tabs[tabName] = {btn = tabFrame, content = content, layout = contentLayout}
    
    tabFrame.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.btn.BackgroundTransparency = 0.5
            t.btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
        content.Visible = true
        tabFrame.BackgroundTransparency = 0
        tabFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        currentTab = tabName
        updateCanvas()
    end)
    
    if not currentTab then
        content.Visible = true
        tabFrame.BackgroundTransparency = 0
        tabFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        currentTab = tabName
    end
    
    -- Возвращаем объект для создания секций
    local tabObj = {}
    function tabObj:CreateSection(name)
        local section = Instance.new("Frame")
        section.Size = UDim2.new(1, 0, 0, 38)
        section.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
        section.BackgroundTransparency = 0.5
        section.BorderSizePixel = 0
        section.Parent = content
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, 8)
        sectionCorner.Parent = section
        
        local sectionLabel = Instance.new("TextLabel")
        sectionLabel.Size = UDim2.new(1, -20, 1, 0)
        sectionLabel.Position = UDim2.new(0, 12, 0, 0)
        sectionLabel.BackgroundTransparency = 1
        sectionLabel.Text = name
        sectionLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
        sectionLabel.TextSize = 14
        sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
        sectionLabel.Font = Enum.Font.GothamBold
        sectionLabel.Parent = section
        
        local sectionObj = {}
        
        function sectionObj:CreateToggle(settings)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 44)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 0
            frame.Parent = content
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 8)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -80, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = settings.Name
            label.TextColor3 = Color3.fromRGB(210, 210, 220)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = frame
            
            if settings.Description then
                local desc = Instance.new("TextLabel")
                desc.Size = UDim2.new(1, -80, 0, 18)
                desc.Position = UDim2.new(0, 12, 0, 22)
                desc.BackgroundTransparency = 1
                desc.Text = settings.Description
                desc.TextColor3 = Color3.fromRGB(140, 140, 160)
                desc.TextSize = 11
                desc.TextXAlignment = Enum.TextXAlignment.Left
                desc.Font = Enum.Font.Gotham
                desc.Parent = frame
                frame.Size = UDim2.new(1, 0, 0, 62)
            end
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 55, 0, 30)
            toggleBtn.Position = UDim2.new(1, -67, 0, settings.Description and 16 or 7)
            toggleBtn.BackgroundColor3 = settings.CurrentValue and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(70, 70, 90)
            toggleBtn.Text = settings.CurrentValue and "ON" or "OFF"
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggleBtn.TextSize = 12
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.BorderSizePixel = 0
            toggleBtn.Parent = frame
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = toggleBtn
            
            local value = settings.CurrentValue
            toggleBtn.MouseButton1Click:Connect(function()
                value = not value
                toggleBtn.BackgroundColor3 = value and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(70, 70, 90)
                toggleBtn.Text = value and "ON" or "OFF"
                settings.Callback(value)
            end)
            
            updateCanvas()
            return toggleBtn
        end
        
        function sectionObj:CreateSlider(settings)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 70)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 0
            frame.Parent = content
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 8)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 0, 22)
            label.Position = UDim2.new(0, 12, 0, 6)
            label.BackgroundTransparency = 1
            label.Text = settings.Name
            label.TextColor3 = Color3.fromRGB(210, 210, 220)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = frame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0, 55, 0, 22)
            valueLabel.Position = UDim2.new(1, -67, 0, 6)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(settings.CurrentValue) .. "x"
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
            local percent = (settings.CurrentValue - settings.Range[1]) / (settings.Range[2] - settings.Range[1])
            fill.Size = UDim2.new(percent, 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
            fill.BorderSizePixel = 0
            fill.Parent = slider
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = fill
            
            local dragging = false
            local value = settings.CurrentValue
            
            local function updateValue(x)
                local pos = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                value = settings.Range[1] + pos * (settings.Range[2] - settings.Range[1])
                value = math.floor(value / settings.Increment + 0.5) * settings.Increment
                value = math.max(settings.Range[1], math.min(settings.Range[2], value))
                fill.Size = UDim2.new(pos, 0, 1, 0)
                valueLabel.Text = tostring(value) .. "x"
                settings.Callback(value)
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
        
        function sectionObj:CreateButton(settings)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 40)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            btn.Text = settings.Name
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.TextSize = 14
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            btn.Parent = content
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = btn
            
            btn.MouseButton1Click:Connect(settings.Callback)
            
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
            end)
            
            updateCanvas()
            return btn
        end
        
        function sectionObj:CreateDropdown(settings)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 48)
            frame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
            frame.BackgroundTransparency = 0.4
            frame.BorderSizePixel = 0
            frame.Parent = content
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 8)
            frameCorner.Parent = frame
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -120, 1, 0)
            label.Position = UDim2.new(0, 12, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = settings.Name
            label.TextColor3 = Color3.fromRGB(210, 210, 220)
            label.TextSize = 13
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = Enum.Font.Gotham
            label.Parent = frame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(0, 100, 0, 32)
            dropdownBtn.Position = UDim2.new(1, -112, 0, 8)
            dropdownBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
            dropdownBtn.Text = settings.CurrentOption
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
                listFrame.Size = UDim2.new(0, 100, 0, #settings.Options * 30)
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
                
                for _, opt in ipairs(settings.Options) do
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
                        settings.Callback(opt)
                        listFrame:Destroy()
                        listFrame = nil
                        isOpen = false
                    end)
                end
            end)
            
            updateCanvas()
            return dropdownBtn
        end
        
        return sectionObj
    end
    
    function tabObj:CreateHomeTab(settings)
        -- Домашняя вкладка (простая)
        local section = self:CreateSection("Информация")
        section:CreateButton({Name = "Discord: " .. settings.DiscordInvite, Callback = function() setclipboard("https://discord.gg/" .. settings.DiscordInvite) end})
        return {}
    end
    
    return tabObj
end

function Luna:CreateWindow(settings)
    -- Возвращаем объект окна
    return {CreateTab = Luna.CreateTab, CreateHomeTab = Luna.CreateHomeTab}
end

function Luna:Notification(settings)
    print("[Abyss Hub] " .. settings.Title .. ": " .. settings.Content)
end

-- Функция обновления CanvasSize
local function updateCanvas()
    local height = 0
    for _, child in ipairs(scrollFrame:GetChildren()) do
        if child:IsA("Frame") and child ~= tabsContainer and child ~= layout then
            height = height + child.Size.Y.Offset + 10
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, height + 20)
end

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

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- ============================================
-- ОСНОВНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
local LP = Players.LocalPlayer
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
    auto_farm_level = false,
    auto_farm_nearby = false,
    farm_weapon = "Меч",
    auto_farm_boss = false,
    selected_boss = "Diamond",
    boss_weapon = "Меч",
    boss_fast_attack = true,
    boss_move = "Телепорт",
    auto_mastery = false,
    mastery_type = "Меч",
    skills = {Z = true, X = true, C = false, V = false, F = false},
    auto_fruit_spawn = false,
    auto_fruit_dealer = false,
    auto_store_fruit = false,
    auto_chest = false,
    chest_mode = "Teleport Farm",
    auto_sea_beast = false,
    auto_elite = false,
    auto_observation = false,
    auto_factory = false,
    auto_mirage = false,
    auto_kitsune_collect = false,
    auto_kitsune_trade = false,
    kitsune_amount = 10,
    fast_attack = true,
    anti_stun = false,
    infinite_energy = false,
    speed_enabled = false,
    speed = 1,
    jump_enabled = false,
    jump = 1,
    dash_length = 0,
    infinite_air_jumps = false,
    silent_aim = false,
    silent_mode = "FOV",
    silent_fov = 90,
    silent_distance = 200,
    fruit_esp = false,
    player_esp = false,
    chest_esp = false,
    island_esp = false,
    fruit_filter = "Все",
    auto_raid = false,
    raid_auto_start = false,
    raid_type = "Buddha",
    raid_auto_buy = false,
    raid_auto_fruit = false,
    raid_max_price = 500000,
    kill_aura_raid = false,
    pvp_mode = false
}

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

-- ============================================
-- ESP
-- ============================================
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
                    local lvl = p.Data and p.Data.Level and p.Data.Level.Value or "?"
                    addLabel(c, p.Name .. " [Lv." .. lvl .. "]", p.TeamColor and p.TeamColor.Color or Color3.new(1, 0.5, 0.5), 3)
                end
            end
        end
    end
    
    if state.chest_esp then
        for _, c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                addLabel(c, "📦 " .. c.Name, Color3.new(1, 0.84, 0), 2)
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
    ["Port Town"] = Vector3.new(-1150, 80, 380),
    ["Hydra Island"] = Vector3.new(-1150, 80, 380),
    ["Great Tree"] = Vector3.new(-1150, 80, 380)
}

local npcs = {
    ["Monkey"] = Vector3.new(-1150, 80, 380),
    ["Bandit"] = Vector3.new(-1150, 80, 380),
    ["Gorilla"] = Vector3.new(-1150, 80, 380)
}

local function teleport(coords)
    if root then
        root.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- СОЗДАНИЕ ИНТЕРФЕЙСА
-- ============================================

-- Создаём окно
local Window = Luna:CreateWindow({Name = "Abyss Hub", Subtitle = "Blox Fruits"})

-- Домашняя вкладка
Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X", "Solara", "Hydrogen"}
})

-- Вкладка PvP
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma"})
local pvpSec = pvpTab:CreateSection("PvP Functions")

pvpSec:CreateToggle({
    Name = "Fast Attack",
    Description = "Автоматическая атака (быстрая)",
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

pvpSec:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Callback = function(v) state.anti_stun = v end
})

pvpSec:CreateToggle({
    Name = "Infinite Energy",
    CurrentValue = false,
    Callback = function(v) state.infinite_energy = v end
})

-- Вкладка ESP
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility"})
local espSec = espTab:CreateSection("ESP Functions")

espSec:CreateToggle({
    Name = "Fruit ESP",
    Description = "Показывает Devil Fruits",
    CurrentValue = false,
    Callback = function(v)
        state.fruit_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(v) state.fruit_filter = v end
})

espSec:CreateToggle({
    Name = "Player ESP",
    Description = "Показывает игроков",
    CurrentValue = false,
    Callback = function(v)
        state.player_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "Chest ESP",
    Description = "Показывает сундуки",
    CurrentValue = false,
    Callback = function(v)
        state.chest_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

espSec:CreateToggle({
    Name = "Island ESP",
    Description = "Показывает названия островов",
    CurrentValue = false,
    Callback = function(v)
        state.island_esp = v
        local any = state.fruit_esp or state.player_esp or state.chest_esp or state.island_esp
        if any then startESP() else stopESP() end
    end
})

-- Вкладка Телепорты
local teleTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation"})
local teleSec = teleTab:CreateSection("Моря")

teleSec:CreateButton({Name = "Teleport to 1st Sea", Callback = function() teleport(seaCoords["1st Sea"]) end})
teleSec:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() teleport(seaCoords["2nd Sea"]) end})
teleSec:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() teleport(seaCoords["3rd Sea"]) end})

local islandSec = teleTab:CreateSection("Острова")
islandSec:CreateButton({Name = "Pirate Starter", Callback = function() teleport(islands["Pirate Starter"]) end})
islandSec:CreateButton({Name = "Marine Starter", Callback = function() teleport(islands["Marine Starter"]) end})
islandSec:CreateButton({Name = "Jungle", Callback = function() teleport(islands["Jungle"]) end})
islandSec:CreateButton({Name = "Desert", Callback = function() teleport(islands["Desert"]) end})
islandSec:CreateButton({Name = "Sky Islands", Callback = function() teleport(islands["Sky Islands"]) end})
islandSec:CreateButton({Name = "Kingdom of Rose", Callback = function() teleport(islands["Kingdom of Rose"]) end})
islandSec:CreateButton({Name = "Port Town", Callback = function() teleport(islands["Port Town"]) end})

local npcSec = teleTab:CreateSection("NPC")
npcSec:CreateButton({Name = "Monkey", Callback = function() teleport(npcs["Monkey"]) end})
npcSec:CreateButton({Name = "Bandit", Callback = function() teleport(npcs["Bandit"]) end})
npcSec:CreateButton({Name = "Gorilla", Callback = function() teleport(npcs["Gorilla"]) end})

-- Вкладка Фарм
local farmTab = Window:CreateTab({Name = "Фарм", Icon = "grass"})
local farmSec = farmTab:CreateSection("Auto Farm")

farmSec:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(v) state.auto_farm_level = v end})
farmSec:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(v) state.auto_farm_nearby = v end})
farmSec:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.farm_weapon = v end})

local bossSec = farmTab:CreateSection("Auto Farm Boss")
bossSec:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(v) state.auto_farm_boss = v end})
bossSec:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral"}, CurrentOption = "Diamond", Callback = function(v) state.selected_boss = v end})

local chestSec = farmTab:CreateSection("Auto Chest")
chestSec:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(v) state.auto_chest = v end})

-- Вкладка Raid
local raidTab = Window:CreateTab({Name = "Raid", Icon = "whatshot"})
local raidSec = raidTab:CreateSection("Auto Raid")
raidSec:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(v) state.auto_raid = v end})
raidSec:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = "Buddha", Callback = function(v) state.raid_type = v end})
raidSec:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(v) state.kill_aura_raid = v end})

-- Вкладка Настройки
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings"})
local configSec = setTab:CreateSection("Конфигурации")
configSec:CreateButton({Name = "Создать конфиг", Callback = function() print("[Abyss] Конфиг в разработке") end})
configSec:CreateButton({Name = "Сохранить конфиг", Callback = function() print("[Abyss] Конфиг в разработке") end})
configSec:CreateButton({Name = "Загрузить конфиг", Callback = function() print("[Abyss] Конфиг в разработке") end})

local generalSec = setTab:CreateSection("Общие")
generalSec:CreateButton({Name = "Unload Script", Callback = function() 
    stopFastAttack()
    stopESP()
    screenGui:Destroy()
    print("Abyss Hub выгружен")
end})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША (Right Control)
-- ============================================
local visible = true

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        screenGui.Enabled = visible
    end
end)

-- Показываем интерфейс
screenGui.Enabled = true
print("Abyss Hub загружен! Клавиша: Right Control")
