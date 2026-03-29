--[[
    Blox Fruits Hub
    Стиль: Чёрный космос
    Версия: 1.0
]]

--------------------------------------------------------------------
-- ⚙️ НАСТРОЙКИ (ЗДЕСЬ МОЖНО МЕНЯТЬ ССЫЛКИ НА ИЗОБРАЖЕНИЯ)
--------------------------------------------------------------------

local settings = {
    -- Ссылка на фоновое изображение (оставьте пустым для градиента)
    backgroundImage = "",  -- вставьте сюда свою ссылку, например "https://example.com/space.jpg"
    -- Ссылка на иконку/логотип
    iconImage = "",  -- вставьте сюда свою ссылку
}

--------------------------------------------------------------------
-- 🔧 СЕРВИСЫ И ПЕРЕМЕННЫЕ
--------------------------------------------------------------------

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Определяем родительский GUI (для разных экзекуторов)
local GuiParent = gethui and gethui() or CoreGui

-- Определяем мобильное устройство
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Очистка старых интерфейсов
for _, gui in ipairs(GuiParent:GetChildren()) do
    if gui.Name == "BloxHub" then
        gui:Destroy()
    end
end

--------------------------------------------------------------------
-- 🎨 ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
--------------------------------------------------------------------

local function tween(object, goal, time, callback)
    time = time or 0.25
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(object, tweenInfo, goal)
    tw:Play()
    if callback then
        tw.Completed:Connect(callback)
    end
    return tw
end

local function createCorner(instance, radius)
    radius = radius or 8
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function createStroke(instance, color, thickness)
    color = color or Color3.fromRGB(50, 50, 70)
    thickness = thickness or 1
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = 0.7
    stroke.Parent = instance
    return stroke
end

-- Функция для создания звёзд на фоне
local function createStars(parent, count)
    for i = 1, count do
        local star = Instance.new("Frame")
        star.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
        star.Position = UDim2.new(math.random(), 0, math.random(), 0)
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BackgroundTransparency = math.random(30, 80) / 100
        star.BorderSizePixel = 0
        star.Parent = parent
        
        -- Анимация мерцания
        task.spawn(function()
            while star.Parent do
                wait(math.random(2, 8))
                tween(star, {BackgroundTransparency = math.random(50, 95) / 100}, math.random(1, 3))
            end
        end)
    end
end

--------------------------------------------------------------------
-- 🖼️ СОЗДАНИЕ ГЛАВНОГО GUI
--------------------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxHub"
ScreenGui.Parent = GuiParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false

-- Затемнение фона
local BackgroundOverlay = Instance.new("Frame")
BackgroundOverlay.Size = UDim2.new(1, 0, 1, 0)
BackgroundOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BackgroundOverlay.BackgroundTransparency = 0.4
BackgroundOverlay.BorderSizePixel = 0
BackgroundOverlay.Parent = ScreenGui

-- Слой со звёздами
local StarsLayer = Instance.new("Frame")
StarsLayer.Size = UDim2.new(1, 0, 1, 0)
StarsLayer.BackgroundTransparency = 1
StarsLayer.Parent = ScreenGui
createStars(StarsLayer, 150)

--------------------------------------------------------------------
-- 🪟 ГЛАВНОЕ ОКНО
--------------------------------------------------------------------

local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 550, 0, 500)
MainWindow.Position = UDim2.new(0.5, -275, 0.5, -250)
MainWindow.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainWindow.BackgroundTransparency = 0.15
MainWindow.BorderSizePixel = 0
MainWindow.Parent = ScreenGui

-- Скругление углов окна
createCorner(MainWindow, 12)
-- Обводка окна
local windowStroke = createStroke(MainWindow, Color3.fromRGB(80, 80, 120), 1)
windowStroke.Transparency = 0.5

-- Размытие фона (Blur)
local blur = Instance.new("BlurEffect")
blur.Size = 12
blur.Parent = game:GetService("Lighting")
-- Плавное появление размытия
tween(blur, {Size = 12}, 0.5)

--------------------------------------------------------------------
-- 🎯 ВЕРХНЯЯ ПАНЕЛЬ
--------------------------------------------------------------------

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainWindow

-- Логотип (иконка)
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 36, 0, 36)
Logo.Position = UDim2.new(0, 10, 0, 7)
Logo.BackgroundTransparency = 1
if settings.iconImage and settings.iconImage ~= "" then
    Logo.Image = settings.iconImage
else
    Logo.Image = "rbxassetid://6031097225"  -- временная иконка
end
Logo.ScaleType = Enum.ScaleType.Fit
Logo.Parent = TopBar
createCorner(Logo, 8)

-- Название
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 150, 0, 30)
Title.Position = UDim2.new(0, 55, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Blox Fruits Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Кнопки управления
local function createTopButton(parent, position, iconId, callback)
    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = position
    btn.BackgroundTransparency = 1
    btn.Image = iconId
    btn.ImageColor3 = Color3.fromRGB(200, 200, 220)
    btn.Parent = parent
    
    btn.MouseEnter:Connect(function()
        tween(btn, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {ImageColor3 = Color3.fromRGB(200, 200, 220)}, 0.1)
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Минимизация
createTopButton(TopBar, UDim2.new(1, -100, 0, 10), "rbxassetid://6031094681", function()
    tween(MainWindow, {Size = UDim2.new(0, 550, 0, 50), Position = UDim2.new(0.5, -275, 0.5, -25)}, 0.3)
    tween(ContentContainer, {BackgroundTransparency = 1}, 0.2)
    tween(TabsContainer, {BackgroundTransparency = 1}, 0.2)
    minimized = true
end)

-- Развернуть
createTopButton(TopBar, UDim2.new(1, -65, 0, 10), "rbxassetid://6031094691", function()
    tween(MainWindow, {Size = UDim2.new(0, 550, 0, 500), Position = UDim2.new(0.5, -275, 0.5, -250)}, 0.3)
    tween(ContentContainer, {BackgroundTransparency = 0}, 0.2)
    tween(TabsContainer, {BackgroundTransparency = 0}, 0.2)
    minimized = false
end)

-- Закрыть
createTopButton(TopBar, UDim2.new(1, -30, 0, 10), "rbxassetid://6031075929", function()
    ScreenGui:Destroy()
    blur:Destroy()
end)

--------------------------------------------------------------------
-- 📑 КОНТЕЙНЕР ВКЛАДОК
--------------------------------------------------------------------

local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -20, 0, 40)
TabsContainer.Position = UDim2.new(0, 10, 0, 55)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainWindow

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsContainer

-- Табы с иконками
local tabs = {
    {name = "Главная", icon = "🏠"},
    {name = "Фарм", icon = "⚔️"},
    {name = "Телепорты", icon = "🌀"},
    {name = "PvP", icon = "⚡"},
    {name = "ESP", icon = "👁️"},
    {name = "Raid", icon = "🔥"},
    {name = "Настройки", icon = "⚙️"},
}

local TabButtons = {}
local ContentContainer
local CurrentTab = nil

-- Создание кнопок вкладок
for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BackgroundTransparency = 0.5
    btn.Text = tab.icon .. " " .. tab.name
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = TabsContainer
    createCorner(btn, 8)
    createStroke(btn, Color3.fromRGB(60, 60, 90), 1)
    
    TabButtons[tab.name] = btn
    
    btn.MouseEnter:Connect(function()
        if CurrentTab ~= tab.name then
            tween(btn, {BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
        end
    end)
    btn.MouseLeave:Connect(function()
        if CurrentTab ~= tab.name then
            tween(btn, {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.1)
        end
    end)
end

--------------------------------------------------------------------
-- 📄 КОНТЕЙНЕР СОДЕРЖИМОГО (скроллируемый)
--------------------------------------------------------------------

ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -20, 1, -105)
ContentContainer.Position = UDim2.new(0, 10, 0, 100)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollBarThickness = 6
ContentContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)
ContentContainer.Parent = MainWindow

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 12)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentContainer

--------------------------------------------------------------------
-- 🔧 ФУНКЦИЯ СОЗДАНИЯ СЕКЦИИ
--------------------------------------------------------------------

local function CreateSection(parent, title, icon)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 0)
    section.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    section.BackgroundTransparency = 0.4
    section.BorderSizePixel = 0
    section.Parent = parent
    createCorner(section, 10)
    createStroke(section, Color3.fromRGB(60, 60, 90), 1)
    
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, -16, 0, 36)
    titleFrame.Position = UDim2.new(0, 8, 0, 8)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 30, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = icon .. " " .. title
    titleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame
    
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Size = UDim2.new(0, 24, 0, 24)
    toggleBtn.Position = UDim2.new(1, -30, 0, 6)
    toggleBtn.BackgroundTransparency = 1
    toggleBtn.Image = "rbxassetid://6031094676"
    toggleBtn.Parent = titleFrame
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -16, 0, 0)
    contentFrame.Position = UDim2.new(0, 8, 0, 52)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = section
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentFrame
    
    local expanded = true
    
    local function updateSize()
        if expanded then
            contentFrame.Visible = true
            section.Size = UDim2.new(1, 0, 0, contentFrame.AbsoluteSize.Y + 60)
            toggleBtn.Image = "rbxassetid://6031094676"
        else
            contentFrame.Visible = false
            section.Size = UDim2.new(1, 0, 0, 52)
            toggleBtn.Image = "rbxassetid://6031094681"
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        updateSize()
    end)
    
    -- Задержка для обновления размера
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if expanded then
            section.Size = UDim2.new(1, 0, 0, contentFrame.AbsoluteSize.Y + 60)
        end
    end)
    
    local function addElement(element, height)
        element.Parent = contentFrame
        element.Size = UDim2.new(1, 0, 0, height or 40)
        updateSize()
        return element
    end
    
    return section, addElement
end

--------------------------------------------------------------------
-- 🔘 ФУНКЦИЯ СОЗДАНИЯ КНОПКИ
--------------------------------------------------------------------

local function CreateButton(parent, text, callback, description)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.AutoButtonColor = false
    btn.Parent = parent
    createCorner(btn, 8)
    
    if description then
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -80, 0, 16)
        desc.Position = UDim2.new(0, 10, 0, 24)
        desc.BackgroundTransparency = 1
        desc.Text = description
        desc.TextColor3 = Color3.fromRGB(150, 150, 180)
        desc.TextSize = 11
        desc.Font = Enum.Font.Gotham
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Parent = btn
    end
    
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(50, 50, 70)}, 0.1)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundTransparency = 0.3, BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.1)
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

--------------------------------------------------------------------
-- 🔄 ФУНКЦИЯ СОЗДАНИЯ ТОГГЛА
--------------------------------------------------------------------

local function CreateToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    createCorner(frame, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("ImageButton")
    toggle.Size = UDim2.new(0, 36, 0, 20)
    toggle.Position = UDim2.new(1, -44, 0.5, -10)
    toggle.BackgroundTransparency = 1
    toggle.Parent = frame
    
    local state = default or false
    
    local function updateToggle()
        if state then
            toggle.Image = "rbxassetid://6031094676"  -- включено
            label.TextColor3 = Color3.fromRGB(100, 200, 255)
        else
            toggle.Image = "rbxassetid://6031094681"  -- выключено
            label.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if callback then callback(state) end
    end)
    
    updateToggle()
    return frame, function() return state end, function(newState) state = newState; updateToggle() end
end

--------------------------------------------------------------------
-- 📊 ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА
--------------------------------------------------------------------

local function CreateSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    createCorner(frame, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -62, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    valueLabel.TextSize = 13
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, -24, 0, 4)
    slider.Position = UDim2.new(0, 12, 0, 38)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    slider.BorderSizePixel = 0
    slider.Parent = frame
    createCorner(slider, 4)
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    createCorner(fill, 4)
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 16, 0, 16)
    handle.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    handle.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    handle.BorderSizePixel = 0
    handle.Parent = slider
    createCorner(handle, 8)
    
    local dragging = false
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    local function updateSlider(mouseX)
        local relative = (mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        local newValue = math.clamp(relative, 0, 1)
        local numValue = min + (max - min) * newValue
        numValue = math.floor(numValue * 100) / 100
        
        fill.Size = UDim2.new(newValue, 0, 1, 0)
        handle.Position = UDim2.new(newValue, -8, 0.5, -8)
        valueLabel.Text = tostring(numValue)
        
        if callback then callback(numValue) end
    end
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    return frame
end

--------------------------------------------------------------------
-- 📋 ФУНКЦИЯ СОЗДАНИЯ ДРОПДАУНА
--------------------------------------------------------------------

local function CreateDropdown(parent, text, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    createCorner(frame, 8)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -12, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Size = UDim2.new(1, -24, 0, 30)
    dropdownBtn.Position = UDim2.new(0, 12, 0, 30)
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    dropdownBtn.Text = default or options[1]
    dropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 255)
    dropdownBtn.TextSize = 13
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Parent = frame
    createCorner(dropdownBtn, 6)
    
    local selected = default or options[1]
    
    dropdownBtn.MouseButton1Click:Connect(function()
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Size = UDim2.new(1, 0, 0, math.min(#options * 32, 200))
        dropdownFrame.Position = UDim2.new(0, 0, 0, 50)
        dropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        dropdownFrame.BackgroundTransparency = 0.05
        dropdownFrame.ZIndex = 10
        dropdownFrame.Parent = frame
        createCorner(dropdownFrame, 8)
        createStroke(dropdownFrame, Color3.fromRGB(80, 80, 120), 1)
        
        local dropdownLayout = Instance.new("UIListLayout")
        dropdownLayout.Padding = UDim.new(0, 2)
        dropdownLayout.Parent = dropdownFrame
        
        for _, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.BackgroundTransparency = 1
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
            optBtn.TextSize = 12
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = dropdownFrame
            
            optBtn.MouseEnter:Connect(function()
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
                optBtn.BackgroundTransparency = 0.5
            end)
            optBtn.MouseLeave:Connect(function()
                optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                optBtn.BackgroundTransparency = 1
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                selected = opt
                dropdownBtn.Text = opt
                if callback then callback(opt) end
                dropdownFrame:Destroy()
            end)
        end
        
        local function closeDropdown()
            if dropdownFrame then dropdownFrame:Destroy() end
        end
        
        dropdownFrame.MouseLeave:Connect(function()
            task.wait(0.3)
            if dropdownFrame and not dropdownFrame.Hover then
                closeDropdown()
            end
        end)
    end)
    
    return frame, function() return selected end
end

--------------------------------------------------------------------
-- 🏠 ГЛАВНАЯ ВКЛАДКА
--------------------------------------------------------------------

local HomeSection, addHome = CreateSection(ContentContainer, "Информация", "🏠")
local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(1, 0, 0, 60)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Добро пожаловать в Blox Fruits Hub!\n\nВыберите нужную вкладку для активации функций."
welcomeLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
welcomeLabel.TextSize = 14
welcomeLabel.Font = Enum.Font.Gotham
welcomeLabel.TextWrapped = true
welcomeLabel.Parent = HomeSection

--------------------------------------------------------------------
-- ⚔️ ФАРМ ВКЛАДКА (ЗАГОТОВКА)
--------------------------------------------------------------------

local FarmSection, addFarm = CreateSection(ContentContainer, "Auto Farm", "⚔️")
CreateToggle(FarmSection, "Auto Farm (Уровень)", false, function(v) print("Auto Farm Level:", v) end)
CreateToggle(FarmSection, "Auto Farm (Ближайшие)", false, function(v) print("Auto Farm Nearby:", v) end)

local weaponDropdown, getWeapon = CreateDropdown(FarmSection, "Оружие", {"Фрукт", "Меч", "Ближний бой"}, "Меч", function(v) print("Weapon:", v) end)

CreateToggle(FarmSection, "Auto Farm Boss", false, function(v) print("Auto Farm Boss:", v) end)
CreateToggle(FarmSection, "Auto Mastery", false, function(v) print("Auto Mastery:", v) end)

local FarmFruitSection, addFruit = CreateSection(ContentContainer, "Auto Fruit", "🍎")
CreateToggle(FarmFruitSection, "Auto Fruit (Spawn)", false, function(v) print("Auto Fruit Spawn:", v) end)
CreateToggle(FarmFruitSection, "Auto Fruit (Dealer)", false, function(v) print("Auto Fruit Dealer:", v) end)
CreateToggle(FarmFruitSection, "Auto Store Fruit", false, function(v) print("Auto Store Fruit:", v) end)

local ChestSection, addChest = CreateSection(ContentContainer, "Auto Chest", "📦")
CreateToggle(ChestSection, "Auto Chest", false, function(v) print("Auto Chest:", v) end)
local chestModeDropdown = CreateDropdown(ChestSection, "Режим", {"Teleport Farm", "Tween Farm"}, "Teleport Farm", function(v) print("Chest Mode:", v) end)

CreateToggle(FarmSection, "Auto Sea Beast", false, function(v) print("Auto Sea Beast:", v) end)
CreateToggle(FarmSection, "Auto Elite Hunter", false, function(v) print("Auto Elite Hunter:", v) end)
CreateToggle(FarmSection, "Auto Observation (Ken Haki)", false, function(v) print("Auto Observation:", v) end)
CreateToggle(FarmSection, "Auto Factory", false, function(v) print("Auto Factory:", v) end)
CreateToggle(FarmSection, "Auto Mirage Island", false, function(v) print("Auto Mirage Island:", v) end)

local KitsuneSection, addKitsune = CreateSection(ContentContainer, "Auto Kitsune Island", "🦊")
CreateToggle(KitsuneSection, "Авто-сбор Azure Embers", false, function(v) print("Auto Azure Embers:", v) end)
CreateToggle(KitsuneSection, "Сдавать Azure Embers", false, function(v) print("Trade Azure Embers:", v) end)
CreateSlider(KitsuneSection, "Количество для сдачи", 0, 20, 10, function(v) print("Embers Trade Amount:", v) end)

--------------------------------------------------------------------
-- 🌀 ТЕЛЕПОРТЫ ВКЛАДКА
--------------------------------------------------------------------

local TeleportSection, addTeleport = CreateSection(ContentContainer, "Телепорты", "🌀")
CreateButton(TeleportSection, "Teleport to 1st Sea", function() print("Teleport to 1st Sea") end)
CreateButton(TeleportSection, "Teleport to 2nd Sea", function() print("Teleport to 2nd Sea") end)
CreateButton(TeleportSection, "Teleport to 3rd Sea", function() print("Teleport to 3rd Sea") end)
CreateButton(TeleportSection, "Teleport to Islands", function() print("Teleport to Islands (safe)") end)
CreateButton(TeleportSection, "Teleport to NPC", function() print("Teleport to NPC") end)
CreateButton(TeleportSection, "Hop to Server", function() print("Hop to Server") end)

--------------------------------------------------------------------
-- ⚡ PVP ВКЛАДКА
--------------------------------------------------------------------

local PvPSection, addPvP = CreateSection(ContentContainer, "PvP Функции", "⚡")
CreateToggle(PvPSection, "Fast Attack", true, function(v) print("Fast Attack:", v) end)
CreateToggle(PvPSection, "Anti-Stun", false, function(v) print("Anti-Stun:", v) end)
CreateToggle(PvPSection, "Infinite Energy", false, function(v) print("Infinite Energy:", v) end)
CreateSlider(PvPSection, "Speed (x1 - x10)", 1, 10, 1, function(v) print("Speed:", v) end)
CreateSlider(PvPSection, "Jump (x1 - x10)", 1, 10, 1, function(v) print("Jump:", v) end)
CreateSlider(PvPSection, "Dash Length (0-200)", 0, 200, 0, function(v) print("Dash Length:", v) end)
CreateToggle(PvPSection, "Infinite Air Jumps", false, function(v) print("Infinite Air Jumps:", v) end)

local SilentAimSection, addSilent = CreateSection(ContentContainer, "Silent Aim", "🎯")
CreateToggle(SilentAimSection, "Silent Aim", false, function(v) print("Silent Aim:", v) end)
local aimModeDropdown = CreateDropdown(SilentAimSection, "Режим", {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, "FOV", function(v) print("Aim Mode:", v) end)
CreateSlider(SilentAimSection, "FOV (0-360)", 0, 360, 90, function(v) print("FOV:", v) end)
CreateSlider(SilentAimSection, "Макс. дистанция", 0, 500, 200, function(v) print("Max Distance:", v) end)

CreateToggle(PvPSection, "Enable PvP Mode", false, function(v) print("Enable PvP Mode:", v) end)

--------------------------------------------------------------------
-- 👁️ ESP ВКЛАДКА
--------------------------------------------------------------------

local EspSection, addEsp = CreateSection(ContentContainer, "ESP Функции", "👁️")
CreateToggle(EspSection, "Fruit ESP", false, function(v) print("Fruit ESP:", v) end)
CreateToggle(EspSection, "Player ESP", false, function(v) print("Player ESP:", v) end)
CreateToggle(EspSection, "NPC ESP", false, function(v) print("NPC ESP:", v) end)
CreateToggle(EspSection, "Chest ESP", false, function(v) print("Chest ESP:", v) end)
CreateToggle(EspSection, "Island ESP", false, function(v) print("Island ESP:", v) end)
CreateToggle(EspSection, "Flower ESP", false, function(v) print("Flower ESP:", v) end)

local fruitRarityDropdown = CreateDropdown(EspSection, "Fruit Rarity Filter", {"Все", "Rare+", "Legendary+", "Mythical"}, "Все", function(v) print("Fruit Filter:", v) end)

--------------------------------------------------------------------
-- 🔥 RAID ВКЛАДКА
--------------------------------------------------------------------

local RaidSection, addRaid = CreateSection(ContentContainer, "Auto Raid", "🔥")
CreateToggle(RaidSection, "Auto Raid", false, function(v) print("Auto Raid:", v) end)
CreateToggle(RaidSection, "Авто-старт", false, function(v) print("Auto Start Raid:", v) end)

local raidTypeDropdown = CreateDropdown(RaidSection, "Выбор рейда", {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, "Buddha", function(v) print("Raid Type:", v) end)

CreateToggle(RaidSection, "Авто-покупка рейда", false, function(v) print("Auto Buy Raid:", v) end)
CreateToggle(RaidSection, "Авто-доставание фрукта", false, function(v) print("Auto Equip Fruit:", v) end)
CreateSlider(RaidSection, "Макс. цена фрукта (Beli)", 0, 1000000, 500000, function(v) print("Max Fruit Price:", v) end)

CreateToggle(RaidSection, "Kill Aura (5 остров рейда)", false, function(v) print("Kill Aura Raid:", v) end)

--------------------------------------------------------------------
-- ⚙️ НАСТРОЙКИ ВКЛАДКА
--------------------------------------------------------------------

local SettingsSection, addSettings = CreateSection(ContentContainer, "Конфигурации", "⚙️")
CreateButton(SettingsSection, "Создать конфиг", function() print("Create Config") end)
CreateButton(SettingsSection, "Сохранить конфиг", function() print("Save Config") end)
CreateButton(SettingsSection, "Загрузить конфиг", function() print("Load Config") end)
CreateButton(SettingsSection, "Авто-загрузка конфига", function() print("Auto Load Config") end)
CreateButton(SettingsSection, "Auto Update", function() print("Check Updates") end)
CreateButton(SettingsSection, "Unload Script", function() ScreenGui:Destroy(); blur:Destroy() end)

CreateToggle(SettingsSection, "Авто-запуск при переходе сервера", true, function(v) print("Auto Rejoin:", v) end)
CreateToggle(SettingsSection, "Mobile Support", IsMobile, function(v) print("Mobile Support:", v) end)
CreateSlider(SettingsSection, "UI Opacity", 0, 100, 85, function(v) 
    MainWindow.BackgroundTransparency = 1 - (v / 100)
end)

CreateButton(SettingsSection, "Настройка цветов", function() print("Color Settings (soon)") end)

--------------------------------------------------------------------
-- 📱 МОБИЛЬНАЯ КНОПКА
--------------------------------------------------------------------

if IsMobile then
    local MobileButton = Instance.new("ImageButton")
    MobileButton.Size = UDim2.new(0, 60, 0, 60)
    MobileButton.Position = UDim2.new(1, -80, 1, -90)
    MobileButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    MobileButton.BackgroundTransparency = 0.2
    MobileButton.Image = settings.iconImage ~= "" and settings.iconImage or "rbxassetid://6031097225"
    MobileButton.ScaleType = Enum.ScaleType.Fit
    MobileButton.Parent = ScreenGui
    createCorner(MobileButton, 30)
    createStroke(MobileButton, Color3.fromRGB(100, 150, 255), 1)
    
    local windowVisible = true
    
    MobileButton.MouseButton1Click:Connect(function()
        windowVisible = not windowVisible
        MainWindow.Visible = windowVisible
        tween(MobileButton, {ImageColor3 = windowVisible and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)}, 0.2)
    end)
    
    -- Анимация пульсации
    task.spawn(function()
        while MobileButton.Parent do
            tween(MobileButton, {BackgroundTransparency = 0.4}, 1)
            wait(0.5)
            tween(MobileButton, {BackgroundTransparency = 0.2}, 1)
            wait(0.5)
        end
    end)
end

--------------------------------------------------------------------
-- 🔄 ПЕРЕКЛЮЧЕНИЕ ВКЛАДОК
--------------------------------------------------------------------

local function SwitchTab(tabName)
    for _, child in ipairs(ContentContainer:GetChildren()) do
        if child:IsA("Frame") and child ~= ContentLayout then
            child.Visible = false
        end
    end
    
    for _, tab in ipairs(tabs) do
        if tab.name == tabName then
            for _, section in ipairs(ContentContainer:GetChildren()) do
                if section:IsA("Frame") and section.Name ~= "UIListLayout" then
                    section.Visible = true
                end
            end
            tween(TabButtons[tabName], {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
        else
            if TabButtons[tab.name] then
                tween(TabButtons[tab.name], {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 220)}, 0.1)
            end
        end
    end
    
    CurrentTab = tabName
end

-- Назначение обработчиков вкладок
for _, tab in ipairs(tabs) do
    TabButtons[tab.name].MouseButton1Click:Connect(function()
        SwitchTab(tab.name)
    end)
end

-- Показываем первую вкладку
SwitchTab("Главная")

-- Обновление размера канваса
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
end)
task.wait(0.1)
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)

-- Анимация появления
MainWindow.BackgroundTransparency = 1
tween(MainWindow, {BackgroundTransparency = 0.15}, 0.5)

print("Blox Fruits Hub загружен!")