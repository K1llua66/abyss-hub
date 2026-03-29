-- Abyss Hub v4.0 - Исправленная версия

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

-- Состояния
local state = {
    autoFarm = false,
    farmMode = "Nearest",
    autoBoss = false,
    selectedBoss = "Diamond",
    silentAim = false,
    aimMode = "Closest",
    maxDistance = 300,
    fastAttack = false,
    pvpMode = false,
    speedEnabled = false,
    speedValue = 16,
    jumpEnabled = false,
    jumpValue = 50,
}

-- Переменные для атаки
local canAttack = true
local lastAttackTime = 0
local attackDelay = 0.12

-- ============================================
-- ОТПРАВКА M1 АТАКИ (ИСПРАВЛЕНО)
-- ============================================
local function SendM1()
    if not canAttack then return end
    
    local player = LocalPlayer
    local character = player.Character
    if not character then return end
    
    -- Пробуем разные способы отправки атаки
    local success = false
    
    -- Способ 1: Через Remote
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = replicatedStorage:FindFirstChild("Remotes")
    
    if remotes then
        local attackRemote = remotes:FindFirstChild("Attack")
        if attackRemote then
            pcall(function()
                attackRemote:FireServer()
                success = true
            end)
        end
        
        if not success then
            local combatRemote = remotes:FindFirstChild("Combat")
            if combatRemote then
                pcall(function()
                    combatRemote:FireServer("M1")
                    success = true
                end)
            end
        end
    end
    
    -- Способ 2: Через мышь
    if not success then
        pcall(function()
            local mouse = player:GetMouse()
            if mouse then
                local b1d = mouse.Button1Down
                local b1u = mouse.Button1Up
                if b1d and b1u then
                    b1d:Fire()
                    task.wait(0.05)
                    b1u:Fire()
                    success = true
                end
            end
        end)
    end
    
    if success then
        canAttack = false
        task.delay(attackDelay, function()
            canAttack = true
        end)
    end
end

-- ============================================
-- ПОИСК ЦЕЛЕЙ
-- ============================================
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
    
    return closest
end

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
    
    return closest
end

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
        end
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

-- ============================================
-- ПОВОРОТ К ЦЕЛИ
-- ============================================
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

-- ============================================
-- ТЕЛЕПОРТ
-- ============================================
local function Teleport(pos)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

-- ============================================
-- ОБНОВЛЕНИЕ ДВИЖЕНИЯ
-- ============================================
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
-- ОСНОВНЫЕ ЦИКЛЫ
-- ============================================

-- Fast Attack цикл (ИСПРАВЛЕН)
local fastLoop = nil
local function StartFastAttack()
    if fastLoop then return end
    fastLoop = RunService.Heartbeat:Connect(function()
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
    if fastLoop then
        fastLoop:Disconnect()
        fastLoop = nil
    end
end

-- Auto Farm цикл
local farmLoop = nil
local function StartAutoFarm()
    if farmLoop then return end
    farmLoop = RunService.Heartbeat:Connect(function()
        if not state.autoFarm then return end
        local target = GetClosestMob()
        if target then
            LookAt(target)
            SendM1()
        end
    end)
end

local function StopAutoFarm()
    if farmLoop then
        farmLoop:Disconnect()
        farmLoop = nil
    end
end

-- Auto Boss цикл
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

-- Silent Aim цикл
local silentLoop = nil
local function StartSilentAim()
    if silentLoop then return end
    silentLoop = RunService.Heartbeat:Connect(function()
        if not state.silentAim then return end
        local targets = GetTargetsByMode()
        if #targets > 0 then
            local target = targets[1].obj
            LookAt(target)
        end
    end)
end

local function StopSilentAim()
    if silentLoop then
        silentLoop:Disconnect()
        silentLoop = nil
    end
end

-- ============================================
-- СОЗДАНИЕ UI
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbyssHub"
screenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
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

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    StopAutoFarm()
    StopAutoBoss()
    StopFastAttack()
    StopSilentAim()
end)

-- Контейнер вкладок
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
tabContainer.BorderSizePixel = 0
tabContainer.Parent = mainFrame

-- Контейнер содержимого
local contentContainer = Instance.new("ScrollingFrame")
contentContainer.Size = UDim2.new(1, -10, 1, -90)
contentContainer.Position = UDim2.new(0, 5, 0, 85)
contentContainer.BackgroundTransparency = 1
contentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
contentContainer.ScrollBarThickness = 4
contentContainer.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentContainer
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 5)

-- Функция создания секции
local function CreateSection(title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundTransparency = 1
    section.Parent = contentContainer
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 25)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = section
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 0, 0)
    contentFrame.Position = UDim2.new(0, 0, 0, 25)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = section
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = contentFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)
    
    return contentFrame, section
end

-- Функция создания Toggle
local function CreateToggle(parent, name, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, -10, 1, 0)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(1, -65, 0.5, -12.5)
    btn.Text = getter() and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.BackgroundColor3 = getter() and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 90)
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    btn.MouseButton1Click:Connect(function()
        setter(not getter())
        btn.Text = getter() and "ON" or "OFF"
        btn.BackgroundColor3 = getter() and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 80, 90)
    end)
    
    return frame
end

-- Функция создания Dropdown (исправлена)
local function CreateDropdown(parent, name, options, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 25)
    btn.Position = UDim2.new(0.05, 0, 0, 22)
    btn.Text = getter()
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    btn.BorderSizePixel = 0
    btn.Parent = frame
    
    local dropdownOpen = false
    local dropdownList = nil
    
    btn.MouseButton1Click:Connect(function()
        if dropdownOpen and dropdownList then
            dropdownList:Destroy()
            dropdownOpen = false
            return
        end
        
        dropdownList = Instance.new("Frame")
        dropdownList.Size = UDim2.new(0.9, 0, 0, #options * 30)
        dropdownList.Position = UDim2.new(0.05, 0, 0, 47)
        dropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        dropdownList.BorderSizePixel = 0
        dropdownList.ZIndex = 10
        dropdownList.Parent = frame
        
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            optBtn.TextSize = 12
            optBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
            optBtn.BorderSizePixel = 0
            optBtn.ZIndex = 11
            optBtn.Parent = dropdownList
            
            optBtn.MouseButton1Click:Connect(function()
                setter(opt)
                btn.Text = opt
                dropdownList:Destroy()
                dropdownOpen = false
            end)
        end
        
        dropdownOpen = true
    end)
    
    return frame
end

-- Функция создания Slider (ИСПРАВЛЕНА)
local function CreateSlider(parent, name, min, max, getter, setter)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.Text = name .. ": " .. tostring(getter())
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -55, 0, 5)
    valueLabel.Text = tostring(getter())
    valueLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1
    valueLabel.Parent = frame
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(0.9, 0, 0, 4)
    sliderBg.Position = UDim2.new(0.05, 0, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = frame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((getter() - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = sliderBg
    
    local dragging = false
    
    local function updateSlider(input)
        local mousePos = input.Position
        local sliderPos = sliderBg.AbsolutePosition.X
        local sliderWidth = sliderBg.AbsoluteSize.X
        
        local pos = math.clamp((mousePos.X - sliderPos) / sliderWidth, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        setter(value)
        label.Text = name .. ": " .. tostring(value)
        valueLabel.Text = tostring(value)
        fill.Size = UDim2.new(pos, 0, 1, 0)
    end
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return frame
end

-- Функция создания кнопки
local function CreateButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    btn.BorderSizePixel = 0
    btn.Parent = parent
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Создание вкладок
local tabsList = {"Auto Farm", "Auto Boss", "Silent Aim", "PvP", "Teleports"}
local tabButtons = {}

for i, tabName in ipairs(tabsList) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.2, -2, 1, 0)
    btn.Position = UDim2.new((i-1) * 0.2, 2, 0, 0)
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 11
    btn.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
    btn.BorderSizePixel = 0
    btn.Parent = tabContainer
    tabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, tb in pairs(tabButtons) do
            tb.BackgroundColor3 = Color3.fromRGB(32, 32, 45)
            tb.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
        btn.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end
        
        if tabName == "Auto Farm" then
            local cf, sec = CreateSection("Настройки фермы")
            CreateToggle(cf, "Auto Farm", function() return state.autoFarm end, function(v) 
                state.autoFarm = v
                if v then StartAutoFarm() else StopAutoFarm() end
            end)
            CreateDropdown(cf, "Режим фермы", {"Nearest", "Level"}, function() return state.farmMode end, function(v) state.farmMode = v end)
            
        elseif tabName == "Auto Boss" then
            local cf, sec = CreateSection("Фарм боссов")
            CreateToggle(cf, "Auto Boss", function() return state.autoBoss end, function(v) 
                state.autoBoss = v
                if v then StartAutoBoss() else StopAutoBoss() end
            end)
            CreateDropdown(cf, "Выбор босса", {"Diamond", "ThunderGod", "ViceAdmiral", "CakeQueen", "RipIndra"}, 
                function() return state.selectedBoss end, function(v) state.selectedBoss = v end)
                
        elseif tabName == "Silent Aim" then
            local cf, sec = CreateSection("Настройки Silent Aim")
            CreateToggle(cf, "Silent Aim", function() return state.silentAim end, function(v) 
                state.silentAim = v
                if v then StartSilentAim() else StopSilentAim() end
            end)
            CreateDropdown(cf, "Режим выбора цели", {"Closest", "Farthest", "Weakest", "Strongest"}, 
                function() return state.aimMode end, function(v) state.aimMode = v end)
            CreateSlider(cf, "Максимальная дистанция", 50, 500, function() return state.maxDistance end, function(v) state.maxDistance = v end)
                
        elseif tabName == "PvP" then
            local cf, sec = CreateSection("PvP функции")
            CreateToggle(cf, "Fast Attack", function() return state.fastAttack end, function(v) 
                state.fastAttack = v
                if v then StartFastAttack() else StopFastAttack() end
            end)
            CreateToggle(cf, "PvP Mode", function() return state.pvpMode end, function(v) state.pvpMode = v end)
            
            local cf2, sec2 = CreateSection("Настройки движения")
            CreateToggle(cf2, "Speed Boost", function() return state.speedEnabled end, function(v) state.speedEnabled = v; UpdateMovement() end)
            CreateSlider(cf2, "Скорость", 16, 100, function() return state.speedValue end, function(v) state.speedValue = v; UpdateMovement() end)
            CreateToggle(cf2, "Jump Boost", function() return state.jumpEnabled end, function(v) state.jumpEnabled = v; UpdateMovement() end)
            CreateSlider(cf2, "Сила прыжка", 50, 200, function() return state.jumpValue end, function(v) state.jumpValue = v; UpdateMovement() end)
                
        elseif tabName == "Teleports" then
            local cf, sec = CreateSection("Моря")
            CreateButton(cf, "🌊 1st Sea", function() Teleport(Vector3.new(-1175, 25, 1450)) end)
            CreateButton(cf, "🌊 2nd Sea", function() Teleport(Vector3.new(-2550, 25, -4050)) end)
            CreateButton(cf, "🌊 3rd Sea", function() Teleport(Vector3.new(1175, 25, 14575)) end)
            
            local cf2, sec2 = CreateSection("Острова")
            CreateButton(cf2, "🏝️ Pirate Starter", function() Teleport(Vector3.new(-1125, 25, 1400)) end)
            CreateButton(cf2, "🏝️ Marine Starter", function() Teleport(Vector3.new(-1200, 25, 1300)) end)
            CreateButton(cf2, "🏝️ Jungle", function() Teleport(Vector3.new(-1450, 35, 950)) end)
            CreateButton(cf2, "🏝️ Desert", function() Teleport(Vector3.new(-900, 25, 1750)) end)
            CreateButton(cf2, "🏝️ Kingdom of Rose", function() Teleport(Vector3.new(-2750, 25, -3750)) end)
            CreateButton(cf2, "🏝️ Port Town", function() Teleport(Vector3.new(-2350, 25, -4250)) end)
        end
        
        task.wait(0.05)
        local totalHeight = 0
        for _, child in pairs(contentContainer:GetChildren()) do
            if child:IsA("Frame") then
                totalHeight = totalHeight + child.Size.Y.Offset + 10
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

print("✅ Abyss Hub v4.0 загружен!")
print("📌 Клавиша: Right Control")
