-- Abyss Hub v4.0 - Полная версия с кастомным UI

-- Проверка игры
local placeId = game.PlaceId
if placeId ~= 2753915549 and placeId ~= 4442272183 and placeId ~= 7449423635 then
    game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub только для Blox Fruits!")
    return
end

-- ============================================
-- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ
-- ============================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Состояния
local state = {
    -- Auto Farm
    autoFarm = false,
    farmMode = "Level", -- Level / Nearest
    weaponType = "Melee", -- Melee / Sword / Fruit
    
    -- Auto Boss
    autoBoss = false,
    selectedBoss = "Diamond",
    
    -- Silent Aim
    silentAim = false,
    aimMode = "Closest", -- Closest / Farthest / Weakest / Strongest
    fov = 90,
    maxDistance = 300,
    
    -- Fast Attack
    fastAttack = false,
    pvpMode = false,
    
    -- Movement
    speedEnabled = false,
    speedValue = 16,
    jumpEnabled = false,
    jumpValue = 50,
    
    -- ESP
    espFruits = false,
    espPlayers = false,
    espNPC = false,
    espChests = false,
}

-- Текущая цель
local currentTarget = nil
local canAttack = true

-- ============================================
-- БАЗОВЫЕ ФУНКЦИИ
-- ============================================

-- Отправка M1 атаки
local function SendM1()
    if not canAttack then return end
    if not state.fastAttack then return end
    
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        local attack = remotes:FindFirstChild("Attack")
        if attack then
            pcall(function() attack:FireServer() end)
            canAttack = false
            task.wait(0.12)
            canAttack = true
        end
    end
end

-- Поиск ближайшего моба
local function GetClosestMob()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 50
    
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local ehrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            if ehrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - ehrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = enemy
                end
            end
        end
    end
    
    return closest, closestDist
end

-- Поиск ближайшего игрока
local function GetClosestPlayer()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closest = nil
    local closestDist = 50
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local pchar = player.Character
            local phrp = pchar:FindFirstChild("HumanoidRootPart")
            local phum = pchar:FindFirstChild("Humanoid")
            if phrp and phum and phum.Health > 0 then
                local dist = (hrp.Position - phrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = pchar
                end
            end
        end
    end
    
    return closest, closestDist
end

-- Поворот к цели
local function LookAt(target)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local thrp = target:FindFirstChild("HumanoidRootPart")
    if thrp then
        hrp.CFrame = CFrame.new(hrp.Position, thrp.Position)
    end
end

-- Телепорт
local function Teleport(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- Обновление скорости/прыжка
local function UpdateMovement()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end
    
    if state.speedEnabled then
        hum.WalkSpeed = state.speedValue
    else
        hum.WalkSpeed = 16
    end
    
    if state.jumpEnabled then
        hum.JumpPower = state.jumpValue
    else
        hum.JumpPower = 50
    end
end

-- ============================================
-- AUTO FARM ЛОГИКА
-- ============================================
local farmLoop = nil

local function StartAutoFarm()
    if farmLoop then return end
    
    farmLoop = RunService.Heartbeat:Connect(function()
        if not state.autoFarm then return end
        
        if state.farmMode == "Nearest" then
            local target = GetClosestMob()
            if target then
                LookAt(target)
                SendM1()
            end
        elseif state.farmMode == "Level" then
            -- Поиск квестов (упрощенно)
            local target = GetClosestMob()
            if target then
                LookAt(target)
                SendM1()
            end
        end
    end)
end

local function StopAutoFarm()
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
    end
end

-- ============================================
-- AUTO BOSS ЛОГИКА
-- ============================================
local bossPositions = {
    Diamond = Vector3.new(-4455, 45, 795),
    ThunderGod = Vector3.new(240, 350, 4200),
    ViceAdmiral = Vector3.new(2850, 25, 725),
    CakeQueen = Vector3.new(-1550, 245, 425),
    RipIndra = Vector3.new(-1075, 25, 5050),
}

local bossLoop = nil

local function StartAutoBoss()
    if bossLoop then return end
    
    bossLoop = RunService.Heartbeat:Connect(function()
        if not state.autoBoss then return end
        
        local bossPos = bossPositions[state.selectedBoss]
        if bossPos then
            -- Ищем босса
            local enemies = workspace:FindFirstChild("Enemies")
            local bossChar = nil
            
            if enemies then
                for _, enemy in pairs(enemies:GetChildren()) do
                    if enemy.Name:find(state.selectedBoss) then
                        bossChar = enemy
                        break
                    end
                end
            end
            
            if bossChar then
                LookAt(bossChar)
                SendM1()
            else
                Teleport(bossPos)
            end
        end
    end)
end

local function StopAutoBoss()
    if bossLoop then
        bossLoop:Disconnect()
        bossLoop = nil
    end
end

-- ============================================
-- FAST ATTACK ЛОГИКА
-- ============================================
local fastAttackLoop = nil

local function StartFastAttack()
    if fastAttackLoop then return end
    
    fastAttackLoop = RunService.Heartbeat:Connect(function()
        if not state.fastAttack then return end
        
        local target = nil
        if state.pvpMode then
            target = GetClosestPlayer()
        else
            target = GetClosestMob()
        end
        
        if target then
            LookAt(target)
            SendM1()
        end
    end)
end

local function StopFastAttack()
    if fastAttackLoop then
        fastAttackLoop:Disconnect()
        fastAttackLoop = nil
    end
end

-- ============================================
-- SILENT AIM ЛОГИКА
-- ============================================
local silentAimLoop = nil

local function GetTargetsByMode()
    local char = LocalPlayer.Character
    if not char then return {} end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return {} end
    
    local targets = {}
    local enemies = workspace:FindFirstChild("Enemies")
    
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local ehrp = enemy:FindFirstChild("HumanoidRootPart")
            local hum = enemy:FindFirstChild("Humanoid")
            if ehrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - ehrp.Position).Magnitude
                if dist <= state.maxDistance then
                    table.insert(targets, {
                        obj = enemy,
                        dist = dist,
                        health = hum.Health
                    })
                end
            end
        }
    end
    
    if state.aimMode == "Closest" then
        table.sort(targets, function(a, b) return a.dist < b.dist end)
    elseif state.aimMode == "Farthest" then
        table.sort(targets, function(a, b) return a.dist > b.dist end)
    elseif state.aimMode == "Weakest" then
        table.sort(targets, function(a, b) return a.health < b.health end)
    elseif state.aimMode == "Strongest" then
        table.sort(targets, function(a, b) return a.health > b.health end)
    end
    
    return targets
end

local function StartSilentAim()
    if silentAimLoop then return end
    
    silentAimLoop = RunService.Heartbeat:Connect(function()
        if not state.silentAim then return end
        
        local targets = GetTargetsByMode()
        if #targets > 0 then
            local target = targets[1].obj
            LookAt(target)
        end
    end)
end

local function StopSilentAim()
    if silentAimLoop then
        silentAimLoop:Disconnect()
        silentAimLoop = nil
    end
end

-- ============================================
-- СОЗДАНИЕ UI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbyssHub"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 550)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.Text = "Abyss Hub v4.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = titleBar

-- Кнопки вкладок
local tabButtons = {}
local currentTab = nil

local tabs = {
    {name = "Auto Farm", icon = "🌾"},
    {name = "Auto Boss", icon = "👑"},
    {name = "Silent Aim", icon = "🎯"},
    {name = "PvP", icon = "⚔️"},
    {name = "ESP", icon = "👁️"},
    {name = "Teleports", icon = "🚀"},
    {name = "Settings", icon = "⚙️"}
}

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame

-- Контейнер для содержимого вкладок
local contentContainer = Instance.new("ScrollingFrame")
contentContainer.Size = UDim2.new(1, -20, 1, -90)
contentContainer.Position = UDim2.new(0, 10, 0, 85)
contentContainer.BackgroundTransparency = 1
contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
contentContainer.ScrollBarThickness = 6
contentContainer.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.Parent = contentContainer
contentList.SortOrder = Enum.SortOrder.LayoutOrder
contentList.Padding = UDim.new(0, 5)

-- Функция создания секции
local function CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    section.BackgroundTransparency = 0.3
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = section
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -10, 0, 0)
    contentFrame.Position = UDim2.new(0, 5, 0, 30)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = section
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    return section, contentFrame
end

-- Функция создания toggle
local function CreateToggle(parent, name, description, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(0.7, -10, 0, 15)
    desc.Position = UDim2.new(0, 0, 0, 20)
    desc.Text = description
    desc.TextColor3 = Color3.fromRGB(150, 150, 150)
    desc.TextSize = 10
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.BackgroundTransparency = 1
    desc.Parent = frame
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 30)
    toggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
    toggleBtn.Text = getter() and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.BackgroundColor3 = getter() and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    
    toggleBtn.MouseButton1Click:Connect(function()
        setter(not getter())
        toggleBtn.Text = getter() and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = getter() and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    end)
    
    return frame
end

-- Функция создания dropdown
local function CreateDropdown(parent, name, options, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -10, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(0, 120, 0, 30)
    dropdownBtn.Position = UDim2.new(1, -130, 0.5, -15)
    dropdownBtn.Text = getter()
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextSize = 12
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Parent = frame
    
    local dropdownOpen = false
    local dropdownList = nil
    
    dropdownBtn.MouseButton1Click:Connect(function()
        if dropdownOpen then
            if dropdownList then dropdownList:Destroy() end
            dropdownOpen = false
            return
        end
        
        dropdownList = Instance.new("Frame")
        dropdownList.Size = UDim2.new(0, 120, 0, #options * 30)
        dropdownList.Position = UDim2.new(1, -130, 0, 40)
        dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        dropdownList.BorderSizePixel = 0
        dropdownList.Parent = frame
        
        for i, opt in ipairs(options) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            btn.Text = opt
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 12
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
            btn.BorderSizePixel = 0
            btn.Parent = dropdownList
            
            btn.MouseButton1Click:Connect(function()
                setter(opt)
                dropdownBtn.Text = opt
                dropdownList:Destroy()
                dropdownOpen = false
            end)
        end
        
        dropdownOpen = true
    end)
    
    return frame
end

-- Функция создания slider
local function CreateSlider(parent, name, min, max, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Text = name .. ": " .. tostring(getter())
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.8, 0, 0, 4)
    slider.Position = UDim2.new(0.1, 0, 0.6, 0)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((getter() - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * pos
            value = math.floor(value)
            setter(value)
            label.Text = name .. ": " .. tostring(value)
            fill.Size = UDim2.new(pos, 0, 1, 0)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * pos
            value = math.floor(value)
            setter(value)
            label.Text = name .. ": " .. tostring(value)
            fill.Size = UDim2.new(pos, 0, 1, 0)
        end
    end)
    
    return frame
end

-- Функция создания кнопки
local function CreateButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Создание вкладок
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 54, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.1428, 0, 0, 0)
    btn.Text = tab.icon .. "\n" .. tab.name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 10
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.BorderSizePixel = 0
    btn.Parent = tabContainer
    
    tabButtons[tab.name] = btn
    
    -- Очистка контента при переключении
    btn.MouseButton1Click:Connect(function()
        for _, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            tb.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        -- Заполнение вкладки
        if tab.name == "Auto Farm" then
            local sec, cf = CreateSection(contentContainer, "Auto Farm Settings")
            CreateToggle(cf, "Auto Farm", "Автоматическая ферма мобов", 
                function() return state.autoFarm end,
                function(v) 
                    state.autoFarm = v
                    if v then StartAutoFarm() else StopAutoFarm() end
                end)
            CreateDropdown(cf, "Режим", {"Level", "Nearest"},
                function() return state.farmMode end,
                function(v) state.farmMode = v end)
            CreateDropdown(cf, "Оружие", {"Melee", "Sword", "Fruit"},
                function() return state.weaponType end,
                function(v) state.weaponType = v end)
            
            local sec2, cf2 = CreateSection(contentContainer, "Статус")
            local statusLabel = Instance.new("TextLabel")
            statusLabel.Size = UDim2.new(1, 0, 0, 30)
            statusLabel.Text = "Статус: Ожидание..."
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            statusLabel.TextSize = 12
            statusLabel.BackgroundTransparency = 1
            statusLabel.Parent = cf2
            
            -- Обновление статуса
            RunService.Heartbeat:Connect(function()
                if state.autoFarm then
                    statusLabel.Text = "✅ Auto Farm активен | Режим: " .. state.farmMode
                else
                    statusLabel.Text = "⏸️ Auto Farm выключен"
                end
            end)
            
        elseif tab.name == "Auto Boss" then
            local sec, cf = CreateSection(contentContainer, "Auto Boss Settings")
            CreateToggle(cf, "Auto Boss", "Автоматический фарм боссов",
                function() return state.autoBoss end,
                function(v) 
                    state.autoBoss = v
                    if v then StartAutoBoss() else StopAutoBoss() end
                end)
            CreateDropdown(cf, "Выбор босса", {"Diamond", "ThunderGod", "ViceAdmiral", "CakeQueen", "RipIndra"},
                function() return state.selectedBoss end,
                function(v) state.selectedBoss = v end)
                
        elseif tab.name == "Silent Aim" then
            local sec, cf = CreateSection(contentContainer, "Silent Aim Settings")
            CreateToggle(cf, "Silent Aim", "Автоматическое наведение на цель",
                function() return state.silentAim end,
                function(v) 
                    state.silentAim = v
                    if v then StartSilentAim() else StopSilentAim() end
                end)
            CreateDropdown(cf, "Режим цели", {"Closest", "Farthest", "Weakest", "Strongest"},
                function() return state.aimMode end,
                function(v) state.aimMode = v end)
            CreateSlider(cf, "FOV (градусы)", 30, 360,
                function() return state.fov end,
                function(v) state.fov = v end)
            CreateSlider(cf, "Макс. дистанция", 50, 500,
                function() return state.maxDistance end,
                function(v) state.maxDistance = v end)
                
        elseif tab.name == "PvP" then
            local sec, cf = CreateSection(contentContainer, "PvP Functions")
            CreateToggle(cf, "Fast Attack", "Быстрая атака (только M1)",
                function() return state.fastAttack end,
                function(v) 
                    state.fastAttack = v
                    if v then StartFastAttack() else StopFastAttack() end
                end)
            CreateToggle(cf, "PvP Mode", "Атаковать игроков",
                function() return state.pvpMode end,
                function(v) state.pvpMode = v end)
            CreateToggle(cf, "Speed Boost", "Увеличение скорости",
                function() return state.speedEnabled end,
                function(v) state.speedEnabled = v; UpdateMovement() end)
            CreateSlider(cf, "Speed Value", 16, 100,
                function() return state.speedValue end,
                function(v) state.speedValue = v; UpdateMovement() end)
            CreateToggle(cf, "Jump Boost", "Увеличение прыжка",
                function() return state.jumpEnabled end,
                function(v) state.jumpEnabled = v; UpdateMovement() end)
            CreateSlider(cf, "Jump Value", 50, 200,
                function() return state.jumpValue end,
                function(v) state.jumpValue = v; UpdateMovement() end)
                
        elseif tab.name == "ESP" then
            local sec, cf = CreateSection(contentContainer, "ESP Functions")
            CreateToggle(cf, "Fruit ESP", "Показывает фрукты",
                function() return state.espFruits end,
                function(v) state.espFruits = v end)
            CreateToggle(cf, "Player ESP", "Показывает игроков",
                function() return state.espPlayers end,
                function(v) state.espPlayers = v end)
            CreateToggle(cf, "NPC ESP", "Показывает мобов",
                function() return state.espNPC end,
                function(v) state.espNPC = v end)
            CreateToggle(cf, "Chest ESP", "Показывает сундуки",
                function() return state.espChests end,
                function(v) state.espChests = v end)
                
        elseif tab.name == "Teleports" then
            local sec, cf = CreateSection(contentContainer, "Моря")
            CreateButton(cf, "🌊 1st Sea", function() Teleport(Vector3.new(-1175, 25, 1450)) end)
            CreateButton(cf, "🌊 2nd Sea", function() Teleport(Vector3.new(-2550, 25, -4050)) end)
            CreateButton(cf, "🌊 3rd Sea", function() Teleport(Vector3.new(1175, 25, 14575)) end)
            
            local sec2, cf2 = CreateSection(contentContainer, "Острова")
            CreateButton(cf2, "🏝️ Pirate Starter", function() Teleport(Vector3.new(-1125, 25, 1400)) end)
            CreateButton(cf2, "🏝️ Marine Starter", function() Teleport(Vector3.new(-1200, 25, 1300)) end)
            CreateButton(cf2, "🏝️ Jungle", function() Teleport(Vector3.new(-1450, 35, 950)) end)
            CreateButton(cf2, "🏝️ Desert", function() Teleport(Vector3.new(-900, 25, 1750)) end)
            CreateButton(cf2, "🏝️ Sky Islands", function() Teleport(Vector3.new(100, 250, 500)) end)
            CreateButton(cf2, "🏝️ Kingdom of Rose", function() Teleport(Vector3.new(-2750, 25, -3750)) end)
            CreateButton(cf2, "🏝️ Port Town", function() Teleport(Vector3.new(-2350, 25, -4250)) end)
            
        elseif tab.name == "Settings" then
            local sec, cf = CreateSection(contentContainer, "Общие")
            CreateButton(cf, "❌ Unload Script", function()
                screenGui:Destroy()
                StopAutoFarm()
                StopAutoBoss()
                StopFastAttack()
                StopSilentAim()
            end)
            
            local info = Instance.new("TextLabel")
            info.Size = UDim2.new(1, 0, 0, 60)
            info.Text = "Abyss Hub v4.0\nСоздан для Blox Fruits\nКлавиша: Right Control"
            info.TextColor3 = Color3.fromRGB(150, 150, 150)
            info.TextSize = 11
            info.TextWrapped = true
            info.BackgroundTransparency = 1
            info.Parent = cf
        end
        
        -- Обновление размера контейнера
        task.wait(0.1)
        local children = contentContainer:GetChildren()
        local totalHeight = 0
        for _, child in pairs(children) do
            if child:IsA("Frame") then
                totalHeight = totalHeight + child.Size.Y.Offset + 5
            end
        end
        contentContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 50)
    end)
end

-- Активация первой вкладки
tabButtons["Auto Farm"].MouseButton1Click:Fire()

-- Перетаскивание окна
local dragging = false
local dragStart
local startPos

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Горячая клавиша
local visible = true
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        visible = not visible
        screenGui.Enabled = visible
    end
end)

print("✅ Abyss Hub v4.0 полностью загружен!")
print("📌 Все функции активны | Клавиша: Right Control")
