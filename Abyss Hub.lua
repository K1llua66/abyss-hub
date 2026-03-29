--[[
    Abyss Hub
    Версия: 1.1 (с ESP и улучшенным Fast Attack)
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
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = syn and syn.virtual_user or (getrenv and getrenv().virtual_user) or nil

-- Состояние функций
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
    npc_esp = false,
    chest_esp = false,
    island_esp = false,
    flower_esp = false,
    fruit_filter = "Все",
    auto_raid = false,
    raid_auto_start = false,
    raid_type = "Buddha",
    raid_auto_buy = false,
    raid_auto_fruit = false,
    raid_max_price = 500000,
    kill_aura_raid = false,
    selected_island = "Pirate Starter",
    selected_npc = "Monkey",
    selected_teleport_island = "Pirate Starter",
    pvp_mode = false,
    window_bind = "RightShift"
}

-- Оптимизация: кэшируем часто используемые объекты
local playerChar = nil
local playerRoot = nil
local playerHumanoid = nil

local function updatePlayerRefs()
    playerChar = LocalPlayer.Character
    if playerChar then
        playerRoot = playerChar:FindFirstChild("HumanoidRootPart")
        playerHumanoid = playerChar:FindFirstChild("Humanoid")
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    updatePlayerRefs()
end)
updatePlayerRefs()

-- Скорость
local function updateSpeed()
    if playerHumanoid then
        if state.speed_enabled then
            playerHumanoid.WalkSpeed = 16 * state.speed
        else
            playerHumanoid.WalkSpeed = 16
        end
    end
end

-- Прыжок
local function updateJump()
    if playerHumanoid then
        if state.jump_enabled then
            playerHumanoid.JumpPower = 50 * state.jump
        else
            playerHumanoid.JumpPower = 50
        end
    end
end

-- ============================================
-- ESP МОДУЛЬ (текстовые метки)
-- ============================================

local ESP = {
    Enabled = false,
    Objects = {
        Fruits = false,
        Players = false,
        NPC = false,
        Chests = false,
        Islands = false,
        Flowers = false
    },
    FruitRarityFilter = "Все",
    Labels = {}
}

-- Функция для определения редкости фрукта
local function getFruitRarity(fruitName)
    local common = {"Bomb", "Spike", "Chop", "Spring", "Kilo", "Spin"}
    local rare = {"Flame", "Ice", "Sand", "Dark", "Revive", "Diamond", "Light", "Rubber", "Barrier", "Ghost", "Magma", "Quake"}
    local legendary = {"Buddha", "Love", "Spider", "Phoenix", "Portal", "Rumble"}
    local mythical = {"Dragon", "Leopard", "Mammoth", "T-Rex", "Spirit", "Venom", "Control", "Gravity", "Shadow", "Dough"}
    
    for _, name in ipairs(common) do
        if fruitName:find(name) then return "Common" end
    end
    for _, name in ipairs(rare) do
        if fruitName:find(name) then return "Rare" end
    end
    for _, name in ipairs(legendary) do
        if fruitName:find(name) then return "Legendary" end
    end
    for _, name in ipairs(mythical) do
        if fruitName:find(name) then return "Mythical" end
    end
    return "Unknown"
end

-- Получение цвета по редкости
local function getColorByRarity(rarity)
    if rarity == "Mythical" then return Color3.fromRGB(255, 85, 255) end
    if rarity == "Legendary" then return Color3.fromRGB(255, 215, 0) end
    if rarity == "Rare" then return Color3.fromRGB(0, 150, 255) end
    return Color3.fromRGB(200, 200, 200)
end

-- Проверка фильтра редкости
local function shouldShowFruit(rarity)
    if state.fruit_filter == "Все" then return true end
    if state.fruit_filter == "Rare+" then return rarity == "Rare" or rarity == "Legendary" or rarity == "Mythical" end
    if state.fruit_filter == "Legendary+" then return rarity == "Legendary" or rarity == "Mythical" end
    if state.fruit_filter == "Mythical" then return rarity == "Mythical" end
    return true
end

-- Создание текстовой метки
local function createLabel(adornee, text, color, offsetY)
    if not adornee or not adornee.Parent then return nil end
    
    -- Проверяем существующую метку
    for obj, label in pairs(ESP.Labels) do
        if label and label.Adornee == adornee then
            local textLabel = label:FindFirstChild("TextLabel")
            if textLabel then textLabel.Text = text end
            return label
        end
    end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = adornee
    billboard.Size = UDim2.new(0, 150, 0, 25)
    billboard.StudsOffset = Vector3.new(0, offsetY or 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = adornee
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    ESP.Labels[adornee] = billboard
    return billboard
end

-- Удаление метки
local function removeLabel(obj)
    if ESP.Labels[obj] then
        ESP.Labels[obj]:Destroy()
        ESP.Labels[obj] = nil
    end
end

-- Очистка всех меток
local function clearESP()
    for obj, label in pairs(ESP.Labels) do
        if label then pcall(function() label:Destroy() end) end
    end
    ESP.Labels = {}
end

-- Обновление ESP
local function updateESP()
    if not ESP.Enabled then return end
    
    -- 1. ESP для фруктов
    if ESP.Objects.Fruits then
        for _, fruit in ipairs(workspace:GetDescendants()) do
            if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                local fruitName = fruit.Name
                local rarity = getFruitRarity(fruitName)
                if shouldShowFruit(rarity) then
                    local text = fruitName .. " [" .. rarity .. "]"
                    local color = getColorByRarity(rarity)
                    createLabel(fruit, text, color, 2.5)
                else
                    removeLabel(fruit)
                end
            end
        end
    end
    
    -- 2. ESP для игроков
    if ESP.Objects.Players then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") and char.Humanoid and char.Humanoid.Health > 0 then
                    local level = plr.Data and plr.Data.Level and plr.Data.Level.Value or "?"
                    local text = plr.Name .. " [Lv." .. level .. "]"
                    local color = plr.TeamColor and plr.TeamColor.Color or Color3.fromRGB(255, 100, 100)
                    createLabel(char, text, color, 3)
                else
                    removeLabel(char)
                end
            end
        end
    end
    
    -- 3. ESP для NPC
    if ESP.Objects.NPC then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, npc in ipairs(enemies:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    local level = npc:FindFirstChild("Level") and npc.Level.Value or "?"
                    local text = npc.Name .. " [Lv." .. level .. "]"
                    createLabel(npc, text, Color3.fromRGB(255, 165, 0), 3)
                else
                    removeLabel(npc)
                end
            end
        end
    end
    
    -- 4. ESP для сундуков
    if ESP.Objects.Chests then
        for _, chest in ipairs(workspace:GetDescendants()) do
            if chest:IsA("Model") and (chest.Name:lower():find("chest") or chest.Name:lower():find("crate")) then
                createLabel(chest, "📦 " .. chest.Name, Color3.fromRGB(255, 215, 0), 2)
            elseif chest:IsA("Part") and chest.Name:lower():find("chest") then
                createLabel(chest, "📦 Chest", Color3.fromRGB(255, 215, 0), 2)
            end
        end
    end
    
    -- 5. ESP для островов
    if ESP.Objects.Islands then
        for _, island in ipairs(workspace:GetChildren()) do
            if island:IsA("Model") and (island.Name:lower():find("island") or island.Name:lower():find("sea")) then
                createLabel(island, "🏝️ " .. island.Name, Color3.fromRGB(100, 200, 255), 10)
            end
        end
    end
    
    -- 6. ESP для цветов
    if ESP.Objects.Flowers then
        for _, flower in ipairs(workspace:GetDescendants()) do
            if flower:IsA("Part") and flower.Name:lower():find("flower") then
                createLabel(flower, "🌸 Blue Flower", Color3.fromRGB(0, 150, 255), 1.5)
            end
        end
    end
    
    -- Очистка меток для уничтоженных объектов
    for obj, label in pairs(ESP.Labels) do
        if not obj or not obj.Parent then
            if label then pcall(function() label:Destroy() end) end
            ESP.Labels[obj] = nil
        end
    end
end

-- Запуск ESP
local espRunning = false
local espTask = nil

local function startESP()
    if espRunning then return end
    espRunning = true
    ESP.Enabled = true
    espTask = task.spawn(function()
        while espRunning do
            updateESP()
            task.wait(0.3)
        end
    end)
end

local function stopESP()
    espRunning = false
    ESP.Enabled = false
    if espTask then
        task.cancel(espTask)
        espTask = nil
    end
    clearESP()
end

-- ============================================
-- FAST ATTACK (улучшенный)
-- ============================================

local fastAttackRunning = false
local fastAttackTask = nil
local attackRemote = nil

-- Поиск Remote для атаки
local function findAttackRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
    for _, remote in ipairs(remotes:GetChildren()) do
        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("attack") or remote.Name:lower():find("combat")) then
            attackRemote = remote
            print("[Fast Attack] Remote found:", remote.Name)
            return
        end
    end
    warn("[Fast Attack] Attack Remote not found")
end

findAttackRemote()

-- Поиск ближайшей цели
local function getNearestTarget()
    if not playerRoot then return nil end
    
    local nearest = nil
    local nearestDist = 30
    
    -- Поиск NPC
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _, npc in ipairs(enemies:GetChildren()) do
            if npc:IsA("Model") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                local npcRoot = npc:FindFirstChild("HumanoidRootPart")
                if npcRoot then
                    local dist = (playerRoot.Position - npcRoot.Position).Magnitude
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
            if plr ~= LocalPlayer then
                local char = plr.Character
                if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                    local charRoot = char:FindFirstChild("HumanoidRootPart")
                    if charRoot then
                        local dist = (playerRoot.Position - charRoot.Position).Magnitude
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

-- Атака цели
local function attackTarget(target)
    if not target or not playerRoot then return end
    
    local targetRoot = target:FindFirstChild("HumanoidRootPart")
    if targetRoot then
        -- Поворачиваемся к цели
        playerRoot.CFrame = CFrame.new(playerRoot.Position, targetRoot.Position)
        
        -- Отправляем атаку
        pcall(function()
            if attackRemote then
                attackRemote:FireServer(target)
            elseif VirtualUser then
                VirtualUser:ClickButton1()
            end
        end)
    end
end

-- Цикл Fast Attack
local function fastAttackLoop()
    while fastAttackRunning do
        if state.fast_attack then
            local target = getNearestTarget()
            if target then
                attackTarget(target)
            end
        end
        task.wait(0.3)
    end
end

local function updateFastAttack()
    if state.fast_attack and not fastAttackRunning then
        fastAttackRunning = true
        fastAttackTask = task.spawn(fastAttackLoop)
        print("[Fast Attack] Включена")
    elseif not state.fast_attack and fastAttackRunning then
        fastAttackRunning = false
        if fastAttackTask then
            task.cancel(fastAttackTask)
            fastAttackTask = nil
        end
        print("[Fast Attack] Выключена")
    end
end

-- ============================================
-- УПРАВЛЕНИЕ ESP ЧЕРЕЗ СОСТОЯНИЕ
-- ============================================

local function updateESPState()
    ESP.Objects.Fruits = state.fruit_esp
    ESP.Objects.Players = state.player_esp
    ESP.Objects.NPC = state.npc_esp
    ESP.Objects.Chests = state.chest_esp
    ESP.Objects.Islands = state.island_esp
    ESP.Objects.Flowers = state.flower_esp
    
    local anyEnabled = state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp or state.island_esp or state.flower_esp
    
    if anyEnabled and not espRunning then
        startESP()
    elseif not anyEnabled and espRunning then
        stopESP()
    elseif anyEnabled and espRunning then
        -- Просто обновляем
        updateESP()
    end
end

-- ============================================
-- ОСТАЛЬНЫЕ ФУНКЦИИ (заглушки)
-- ============================================

local function updateAntiStun() end
local function updateInfiniteEnergy() end
local function updateDashLength() end
local function updateInfiniteAirJumps() end

-- Обновляем настройки персонажа через Heartbeat
RunService.Heartbeat:Connect(function()
    updatePlayerRefs()
    updateSpeed()
    updateJump()
end)

-- ============================================
-- КООРДИНАТЫ (для телепортов)
-- ============================================

local islands = {
    ["1st Sea"] = {
        ["Pirate Starter"] = Vector3.new(-1150, 80, 380),
        ["Marine Starter"] = Vector3.new(-1150, 80, 380),
    },
    ["2nd Sea"] = {
        ["Kingdom of Rose"] = Vector3.new(-1150, 80, 380),
    },
    ["3rd Sea"] = {
        ["Port Town"] = Vector3.new(-1150, 80, 380),
    }
}

local seaCoords = {
    ["1st Sea"] = Vector3.new(-1250, 80, 330),
    ["2nd Sea"] = Vector3.new(-1250, 80, 330),
    ["3rd Sea"] = Vector3.new(-1250, 80, 330),
}

local npcs = {
    ["Monkey"] = Vector3.new(-1150, 80, 380),
}

local function teleportTo(coords)
    if playerRoot then
        playerRoot.CFrame = CFrame.new(coords)
    end
end

-- ============================================
-- СОЗДАНИЕ ВКЛАДОК
-- ============================================

Window:CreateHomeTab({
    DiscordInvite = "abysshub",
    SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X"}
})

-- Вкладка Фарм
local FarmTab = Window:CreateTab({Name = "Фарм", Icon = "grass", ImageSource = "Material"})
local TeleportTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local PvPTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local ESPTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local RaidTab = Window:CreateTab({Name = "Raid", Icon = "whatshot", ImageSource = "Material"})
local SettingsTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})

-- ============================================
-- ВКЛАДКА ФАРМ
-- ============================================

local FarmSection = FarmTab:CreateSection("Auto Farm")
FarmSection:CreateToggle({Name = "Auto Farm (Уровень)", CurrentValue = false, Callback = function(v) state.auto_farm_level = v end})
FarmSection:CreateToggle({Name = "Auto Farm (Ближайшие)", CurrentValue = false, Callback = function(v) state.auto_farm_nearby = v end})
FarmSection:CreateDropdown({Name = "Оружие", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.farm_weapon = v end})

-- Auto Farm Boss
local BossSection = FarmTab:CreateSection("Auto Farm Boss")
BossSection:CreateToggle({Name = "Auto Farm Boss", CurrentValue = false, Callback = function(v) state.auto_farm_boss = v end})
BossSection:CreateDropdown({Name = "Выбор босса", Options = {"Diamond", "Thunder God", "Vice Admiral"}, CurrentOption = "Diamond", Callback = function(v) state.selected_boss = v end})
BossSection:CreateDropdown({Name = "Оружие (босс)", Options = {"Фрукт", "Меч", "Ближний бой"}, CurrentOption = "Меч", Callback = function(v) state.boss_weapon = v end})
BossSection:CreateToggle({Name = "Использовать Fast Attack", CurrentValue = true, Callback = function(v) state.boss_fast_attack = v end})
BossSection:CreateDropdown({Name = "Способ передвижения", Options = {"Телепорт", "Бег"}, CurrentOption = "Телепорт", Callback = function(v) state.boss_move = v end})

-- Auto Mastery
local MasterySection = FarmTab:CreateSection("Auto Mastery")
MasterySection:CreateToggle({Name = "Auto Mastery", CurrentValue = false, Callback = function(v) state.auto_mastery = v end})
MasterySection:CreateDropdown({Name = "Тип", Options = {"Фрукт", "Меч", "Ближний бой", "Оружие (Gun)"}, CurrentOption = "Меч", Callback = function(v) state.mastery_type = v end})
MasterySection:CreateToggle({Name = "Использовать Z", CurrentValue = true, Callback = function(v) state.skills.Z = v end})
MasterySection:CreateToggle({Name = "Использовать X", CurrentValue = true, Callback = function(v) state.skills.X = v end})
MasterySection:CreateToggle({Name = "Использовать C", CurrentValue = false, Callback = function(v) state.skills.C = v end})
MasterySection:CreateToggle({Name = "Использовать V", CurrentValue = false, Callback = function(v) state.skills.V = v end})
MasterySection:CreateToggle({Name = "Использовать F", CurrentValue = false, Callback = function(v) state.skills.F = v end})

-- Auto Fruit
local FruitSection = FarmTab:CreateSection("Auto Fruit")
FruitSection:CreateToggle({Name = "Auto Fruit (Spawn)", CurrentValue = false, Callback = function(v) state.auto_fruit_spawn = v end})
FruitSection:CreateToggle({Name = "Auto Fruit (Dealer)", CurrentValue = false, Callback = function(v) state.auto_fruit_dealer = v end})
FruitSection:CreateToggle({Name = "Auto Store Fruit", CurrentValue = false, Callback = function(v) state.auto_store_fruit = v end})

-- Auto Chest
local ChestSection = FarmTab:CreateSection("Auto Chest")
ChestSection:CreateToggle({Name = "Auto Chest", CurrentValue = false, Callback = function(v) state.auto_chest = v end})
ChestSection:CreateDropdown({Name = "Режим", Options = {"Teleport Farm", "Tween Farm"}, CurrentOption = "Teleport Farm", Callback = function(v) state.chest_mode = v end})

-- Другие функции
local OtherSection = FarmTab:CreateSection("Другие функции")
OtherSection:CreateToggle({Name = "Auto Sea Beast", CurrentValue = false, Callback = function(v) state.auto_sea_beast = v end})
OtherSection:CreateToggle({Name = "Auto Elite Hunter", CurrentValue = false, Callback = function(v) state.auto_elite = v end})
OtherSection:CreateToggle({Name = "Auto Observation (Ken Haki)", CurrentValue = false, Callback = function(v) state.auto_observation = v end})
OtherSection:CreateToggle({Name = "Auto Factory", CurrentValue = false, Callback = function(v) state.auto_factory = v end})
OtherSection:CreateToggle({Name = "Auto Mirage Island", CurrentValue = false, Callback = function(v) state.auto_mirage = v end})

-- Auto Kitsune Island
local KitsuneSection = FarmTab:CreateSection("Auto Kitsune Island")
KitsuneSection:CreateToggle({Name = "Авто-сбор Azure Embers", CurrentValue = false, Callback = function(v) state.auto_kitsune_collect = v end})
KitsuneSection:CreateToggle({Name = "Сдавать Azure Embers", CurrentValue = false, Callback = function(v) state.auto_kitsune_trade = v end})
KitsuneSection:CreateSlider({Name = "Количество для сдачи", Range = {0, 20}, Increment = 1, CurrentValue = 10, Callback = function(v) state.kitsune_amount = v end})

-- ============================================
-- ВКЛАДКА ТЕЛЕПОРТЫ
-- ============================================

local TeleportSection = TeleportTab:CreateSection("Телепорт между морями")
TeleportSection:CreateButton({Name = "Teleport to 1st Sea", Callback = function() teleportTo(seaCoords["1st Sea"]) Luna:Notification({Title = "Телепорт", Content = "1st Sea"}) end})
TeleportSection:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() teleportTo(seaCoords["2nd Sea"]) Luna:Notification({Title = "Телепорт", Content = "2nd Sea"}) end})
TeleportSection:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() teleportTo(seaCoords["3rd Sea"]) Luna:Notification({Title = "Телепорт", Content = "3rd Sea"}) end})

-- ============================================
-- ВКЛАДКА PVP
-- ============================================

local PvPSection = PvPTab:CreateSection("PvP Functions")

PvPSection:CreateToggle({
    Name = "Fast Attack (авто-атака)",
    Description = "Автоматически атакует врагов",
    CurrentValue = true,
    Callback = function(v)
        state.fast_attack = v
        updateFastAttack()
        Luna:Notification({Title = "Fast Attack", Content = v and "Включена" or "Выключена"})
    end
})

PvPSection:CreateToggle({Name = "Anti-Stun", CurrentValue = false, Callback = function(v) state.anti_stun = v; updateAntiStun() end})
PvPSection:CreateToggle({Name = "Infinite Energy", CurrentValue = false, Callback = function(v) state.infinite_energy = v; updateInfiniteEnergy() end})

-- Speed с отдельным тогглом
PvPSection:CreateToggle({Name = "Speed Boost", CurrentValue = false, Callback = function(v) state.speed_enabled = v; updateSpeed() end})
PvPSection:CreateSlider({Name = "Speed Multiplier", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) state.speed = v; if state.speed_enabled then updateSpeed() end end})

-- Jump с отдельным тогглом
PvPSection:CreateToggle({Name = "Jump Boost", CurrentValue = false, Callback = function(v) state.jump_enabled = v; updateJump() end})
PvPSection:CreateSlider({Name = "Jump Multiplier", Range = {1, 10}, Increment = 1, CurrentValue = 1, Callback = function(v) state.jump = v; if state.jump_enabled then updateJump() end end})

PvPSection:CreateSlider({Name = "Dash Length", Range = {0, 200}, Increment = 1, CurrentValue = 0, Callback = function(v) state.dash_length = v; updateDashLength() end})
PvPSection:CreateToggle({Name = "Infinite Air Jumps", CurrentValue = false, Callback = function(v) state.infinite_air_jumps = v; updateInfiniteAirJumps() end})
PvPSection:CreateToggle({Name = "PvP Mode (атака игроков)", CurrentValue = false, Callback = function(v) state.pvp_mode = v; Luna:Notification({Title = "PvP Mode", Content = v and "Включена" or "Выключена"}) end})

-- Silent Aim
local SilentSection = PvPTab:CreateSection("Silent Aim")
SilentSection:CreateToggle({Name = "Silent Aim", CurrentValue = false, Callback = function(v) state.silent_aim = v end})
SilentSection:CreateDropdown({Name = "Режим", Options = {"FOV", "Ближайший", "Дальнейший", "Слабейший", "Сильнейший"}, CurrentOption = "FOV", Callback = function(v) state.silent_mode = v end})
SilentSection:CreateSlider({Name = "FOV", Range = {0, 360}, Increment = 1, CurrentValue = 90, Callback = function(v) state.silent_fov = v end})
SilentSection:CreateSlider({Name = "Макс. дистанция", Range = {0, 500}, Increment = 10, CurrentValue = 200, Callback = function(v) state.silent_distance = v end})

-- ============================================
-- ВКЛАДКА ESP (рабочая)
-- ============================================

local EspSection = ESPTab:CreateSection("ESP Functions")

EspSection:CreateToggle({
    Name = "Fruit ESP",
    Description = "Показывает названия фруктов на карте",
    CurrentValue = false,
    Callback = function(v)
        state.fruit_esp = v
        updateESPState()
    end
})

EspSection:CreateToggle({
    Name = "Player ESP",
    Description = "Показывает имена и уровни игроков",
    CurrentValue = false,
    Callback = function(v)
        state.player_esp = v
        updateESPState()
    end
})

EspSection:CreateToggle({
    Name = "NPC ESP",
    Description = "Показывает названия NPC и мобов",
    CurrentValue = false,
    Callback = function(v)
        state.npc_esp = v
        updateESPState()
    end
})

EspSection:CreateToggle({
    Name = "Chest ESP",
    Description = "Показывает расположение сундуков",
    CurrentValue = false,
    Callback = function(v)
        state.chest_esp = v
        updateESPState()
    end
})

EspSection:CreateToggle({
    Name = "Island ESP",
    Description = "Показывает названия островов",
    CurrentValue = false,
    Callback = function(v)
        state.island_esp = v
        updateESPState()
    end
})

EspSection:CreateToggle({
    Name = "Flower ESP",
    Description = "Показывает расположение цветов (Blue Flower)",
    CurrentValue = false,
    Callback = function(v)
        state.flower_esp = v
        updateESPState()
    end
})

EspSection:CreateDropdown({
    Name = "Fruit Rarity Filter",
    Description = "Фильтр фруктов по редкости",
    Options = {"Все", "Rare+", "Legendary+", "Mythical"},
    CurrentOption = "Все",
    Callback = function(v)
        state.fruit_filter = v
        if state.fruit_esp then updateESP() end
    end
})

-- ============================================
-- ВКЛАДКА RAID (заглушки)
-- ============================================

local RaidSection = RaidTab:CreateSection("Auto Raid")
RaidSection:CreateToggle({Name = "Auto Raid", CurrentValue = false, Callback = function(v) state.auto_raid = v end})
RaidSection:CreateToggle({Name = "Авто-старт", CurrentValue = false, Callback = function(v) state.raid_auto_start = v end})
RaidSection:CreateDropdown({Name = "Выбор рейда", Options = {"Flame", "Ice", "Quake", "Light", "Dark", "Sand", "Magma", "Phoenix", "Rumble", "Buddha", "Spider", "Dough"}, CurrentOption = "Buddha", Callback = function(v) state.raid_type = v end})
RaidSection:CreateToggle({Name = "Авто-покупка рейда", CurrentValue = false, Callback = function(v) state.raid_auto_buy = v end})
RaidSection:CreateToggle({Name = "Авто-доставание фрукта", CurrentValue = false, Callback = function(v) state.raid_auto_fruit = v end})
RaidSection:CreateSlider({Name = "Макс. цена фрукта (Beli)", Range = {0, 1000000}, Increment = 10000, CurrentValue = 500000, Callback = function(v) state.raid_max_price = v end})
RaidSection:CreateToggle({Name = "Kill Aura (5 остров рейда)", CurrentValue = false, Callback = function(v) state.kill_aura_raid = v end})

-- ============================================
-- ВКЛАДКА НАСТРОЙКИ
-- ============================================

local ConfigSection = SettingsTab:CreateSection("Конфигурации")
ConfigSection:CreateButton({Name = "Создать конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
ConfigSection:CreateButton({Name = "Сохранить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
ConfigSection:CreateButton({Name = "Загрузить конфиг", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})
ConfigSection:CreateButton({Name = "Авто-загрузка конфига", Callback = function() Luna:Notification({Title = "Конфиг", Content = "В разработке"}) end})

local GeneralSection = SettingsTab:CreateSection("Общие")

-- Клавиша для открытия
local keyOptions = {"RightShift", "LeftShift", "RightControl", "LeftControl", "K", "L", "U", "I", "O", "P", "Q", "E", "R", "T", "Y", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"}
local keyDropdown = GeneralSection:CreateDropdown({
    Name = "Клавиша открытия",
    Options = keyOptions,
    CurrentOption = "RightShift",
    Callback = function(opt)
        state.window_bind = opt
        print("[Settings] Bind changed to:", opt)
        updateKeybind()
    end
})

GeneralSection:CreateButton({Name = "Auto Update", Callback = function() Luna:Notification({Title = "Обновление", Content = "Последняя версия"}) end})
GeneralSection:CreateButton({Name = "Unload Script", Callback = function() 
    stopESP()
    fastAttackRunning = false
    Window:Destroy() 
    print("Abyss Hub выгружен") 
end})
GeneralSection:CreateToggle({Name = "Авто-запуск при переходе сервера", CurrentValue = true, Callback = function(v) print("[Settings] Auto Rejoin:", v) end})
GeneralSection:CreateToggle({Name = "Mobile Support", CurrentValue = UserInputService.TouchEnabled, Callback = function(v) print("[Settings] Mobile:", v) end})
GeneralSection:CreateButton({Name = "Настройка цветов", Callback = function() Luna:Notification({Title = "Цвета", Content = "В разработке"}) end})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША
-- ============================================

local mainFrame = nil
local shadowHolder = nil

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

local function updateKeybind()
    if _G.__keyConnection then
        _G.__keyConnection:Disconnect()
        _G.__keyConnection = nil
    end
    
    local isVisible = true
    
    _G.__keyConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local key = string.split(tostring(input.KeyCode), ".")[3] or ""
        if key == state.window_bind then
            isVisible = not isVisible
            if mainFrame then
                mainFrame.Visible = isVisible
                if shadowHolder then
                    shadowHolder.Visible = isVisible
                end
                Luna:Notification({
                    Title = "Abyss Hub", 
                    Content = isVisible and "Интерфейс открыт" or "Интерфейс скрыт", 
                    Duration = 1
                })
            end
        end
    end)
end

-- Отключаем встроенный бинд Luna UI
pcall(function()
    if Window._bindConnection then
        Window._bindConnection:Disconnect()
    end
    Window.Bind = Enum.KeyCode.Unknown
end)

-- Запускаем обработчик
updateKeybind()

-- Убираем размытие
pcall(function()
    _G.BlurModule = function() end
end)

-- Запускаем Fast Attack по умолчанию
updateFastAttack()

-- Уведомление о загрузке
Luna:Notification({
    Title = "Abyss Hub",
    Content = "Скрипт загружен! Клавиша: " .. state.window_bind,
    Icon = "sparkle",
    ImageSource = "Material",
    Duration = 3
})

print("Abyss Hub загружен! Клавиша открытия:", state.window_bind)
