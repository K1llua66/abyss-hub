--[[
    Abyss Hub v1.3
    Оптимизированная версия
]]

-- Проверка игры
if not table.find({2753915549, 4442272183, 7449423635}, game.PlaceId) then
    return game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub работает только в Blox Fruits!")
end

-- Загрузка Luna UI
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/K1llua66/abyss-hub/refs/heads/main/Luna%20UI.lua"))()
if not Luna then return game:GetService("Players").LocalPlayer:Kick("❌ Не удалось загрузить Luna UI") end

-- Создание окна
local Window = Luna:CreateWindow({Name = "Abyss Hub", Subtitle = "Blox Fruits", LogoID = "6031097225", LoadingEnabled = true, LoadingTitle = "Abyss Hub", LoadingSubtitle = "Loading...", KeySystem = false})

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
    fast_attack = true, pvp_mode = false, speed_enabled = false, speed = 1,
    jump_enabled = false, jump = 1,
    fruit_esp = false, player_esp = false, npc_esp = false, chest_esp = false, island_esp = false, flower_esp = false,
    fruit_filter = "Все", window_bind = "RightShift"
}

-- ============================================
-- ОТКЛЮЧЕНИЕ РАЗМЫТИЯ
-- ============================================
for _, e in ipairs(game:GetService("Lighting"):GetChildren()) do
    if e:IsA("DepthOfFieldEffect") or e:IsA("BlurEffect") then e:Destroy() end
end
_G.BlurModule = function() end

-- ============================================
-- СКОРОСТЬ И ПРЫЖОК
-- ============================================
local function updateSpeed()
    if hum then hum.WalkSpeed = state.speed_enabled and 16 * state.speed or 16 end
end
local function updateJump()
    if hum then hum.JumpPower = state.jump_enabled and 50 * state.jump or 50 end
end
RS.Heartbeat:Connect(function() updateChar(); updateSpeed(); updateJump() end)

-- ============================================
-- FAST ATTACK
-- ============================================
local attackRunning, lastAttack = false, 0
local function getNearest()
    if not root then return end
    local nearest, nearestDist = nil, 25
    local pos = root.Position
    
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            local isPlayer = Players:GetPlayerFromCharacter(v)
            if (not isPlayer) or (isPlayer and state.pvp_mode) then
                local r = v:FindFirstChild("HumanoidRootPart")
                if r then
                    local d = (pos - r.Position).Magnitude
                    if d < nearestDist then nearest, nearestDist = v, d end
                end
            end
        end
    end
    return nearest
end

local function attack()
    if not state.fast_attack then return end
    local target = getNearest()
    if not target then return end
    
    local now = tick()
    if now - lastAttack < 0.25 then return end
    
    local tr = target:FindFirstChild("HumanoidRootPart")
    if tr then
        root.CFrame = CFrame.new(root.Position, tr.Position)
        pcall(function()
            if VU then VU:ClickButton1() end
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
        lastAttack = now
    end
end

local function toggleFastAttack(v)
    state.fast_attack = v
    if v and not attackRunning then
        attackRunning = true
        task.spawn(function() while attackRunning do attack(); task.wait(0.25) end end)
    elseif not v then attackRunning = false end
end
toggleFastAttack(true)

-- ============================================
-- ESP (компактная версия)
-- ============================================
local esp = {active = false, labels = {}}
local function getRarity(name)
    local r = {common = {"Bomb","Spike","Chop","Spring","Kilo","Spin"}, rare = {"Flame","Ice","Sand","Dark","Revive","Diamond","Light","Rubber","Barrier","Ghost","Magma","Quake"}, legendary = {"Buddha","Love","Spider","Phoenix","Portal","Rumble"}, mythical = {"Dragon","Leopard","Mammoth","T-Rex","Spirit","Venom","Control","Gravity","Shadow","Dough"}}
    for _,n in ipairs(r.common) do if name:find(n) then return "Common" end end
    for _,n in ipairs(r.rare) do if name:find(n) then return "Rare" end end
    for _,n in ipairs(r.legendary) do if name:find(n) then return "Legendary" end end
    for _,n in ipairs(r.mythical) do if name:find(n) then return "Mythical" end end
    return "Unknown"
end
local function shouldShow(rarity)
    local f = state.fruit_filter
    if f == "Все" then return true end
    if f == "Rare+" then return rarity == "Rare" or rarity == "Legendary" or rarity == "Mythical" end
    if f == "Legendary+" then return rarity == "Legendary" or rarity == "Mythical" end
    if f == "Mythical" then return rarity == "Mythical" end
    return true
end
local function addLabel(obj, txt, col, off)
    if not obj then return end
    for o,l in pairs(esp.labels) do if l and l.Adornee == obj then if l:FindFirstChild("Text") then l.Text.Text = txt end return end end
    local b = Instance.new("BillboardGui")
    b.Adornee = obj
    b.Size = UDim2.new(0,150,0,25)
    b.StudsOffset = Vector3.new(0, off or 3, 0)
    b.AlwaysOnTop = true
    b.Parent = obj
    local t = Instance.new("TextLabel", b)
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text = txt
    t.TextColor3 = col or Color3.new(1,1,1)
    t.TextStrokeTransparency = 0.3
    t.TextScaled = true
    t.Font = Enum.Font.GothamBold
    esp.labels[obj] = b
end
local function clearESP()
    for _,l in pairs(esp.labels) do pcall(function() l:Destroy() end) end
    esp.labels = {}
end
local function updateESP()
    if not esp.active then return end
    if state.fruit_esp then
        for _,f in ipairs(workspace:GetDescendants()) do
            if f:IsA("Tool") and f:FindFirstChild("Handle") then
                local r = getRarity(f.Name)
                if shouldShow(r) then addLabel(f, f.Name.." ["..r.."]", r=="Mythical" and Color3.new(1,0.33,1) or r=="Legendary" and Color3.new(1,0.84,0) or r=="Rare" and Color3.new(0,0.59,1) or Color3.new(0.78,0.78,0.78), 2.5) else pcall(function() if esp.labels[f] then esp.labels[f]:Destroy() end end) end
            end
        end
    end
    if state.player_esp then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") and c.Humanoid and c.Humanoid.Health > 0 then
                    addLabel(c, p.Name.." [Lv."..(p.Data and p.Data.Level and p.Data.Level.Value or "?").."]", p.TeamColor and p.TeamColor.Color or Color3.new(1,0.39,0.39), 3)
                end
            end
        end
    end
    if state.npc_esp and workspace:FindFirstChild("Enemies") then
        for _,n in ipairs(workspace.Enemies:GetChildren()) do
            if n:IsA("Model") and n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 then
                addLabel(n, n.Name.." [Lv."..(n:FindFirstChild("Level") and n.Level.Value or "?").."]", Color3.new(1,0.65,0), 3)
            end
        end
    end
    if state.chest_esp then
        for _,c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                addLabel(c, "📦 "..c.Name, Color3.new(1,0.84,0), 2)
            end
        end
    end
    for o,l in pairs(esp.labels) do if not o or not o.Parent then pcall(function() l:Destroy() end); esp.labels[o]=nil end end
end
local function toggleESP(v)
    esp.active = v
    if v then
        task.spawn(function() while esp.active do updateESP(); task.wait(0.3) end end)
    else clearESP() end
end

-- ============================================
-- ТЕЛЕПОРТЫ
-- ============================================
local seaCoords = {["1st Sea"] = Vector3.new(-1250,80,330), ["2nd Sea"] = Vector3.new(-1250,80,330), ["3rd Sea"] = Vector3.new(-1250,80,330)}
local function teleport(c) if root then root.CFrame = CFrame.new(c) end end

-- ============================================
-- ИНТЕРФЕЙС (компактный)
-- ============================================
Window:CreateHomeTab({DiscordInvite = "abysshub", SupportedExecutors = {"Xeno", "Delta", "Vega X", "Arceus X"}})

-- PvP вкладка
local pvpTab = Window:CreateTab({Name = "PvP", Icon = "sports_mma", ImageSource = "Material"})
local pvpSec = pvpTab:CreateSection("PvP Functions")
pvpSec:CreateToggle({Name = "Fast Attack", Description = "Автоматическая атака", CurrentValue = true, Callback = toggleFastAttack})
pvpSec:CreateToggle({Name = "PvP Mode", Description = "Атаковать игроков", CurrentValue = false, Callback = function(v) state.pvp_mode = v end})
pvpSec:CreateToggle({Name = "Speed Boost", CurrentValue = false, Callback = function(v) state.speed_enabled = v; updateSpeed() end})
pvpSec:CreateSlider({Name = "Speed Multiplier", Range = {1,10}, Increment = 1, CurrentValue = 1, Callback = function(v) state.speed = v; if state.speed_enabled then updateSpeed() end end})
pvpSec:CreateToggle({Name = "Jump Boost", CurrentValue = false, Callback = function(v) state.jump_enabled = v; updateJump() end})
pvpSec:CreateSlider({Name = "Jump Multiplier", Range = {1,10}, Increment = 1, CurrentValue = 1, Callback = function(v) state.jump = v; if state.jump_enabled then updateJump() end end})

-- ESP вкладка
local espTab = Window:CreateTab({Name = "ESP", Icon = "visibility", ImageSource = "Material"})
local espSec = espTab:CreateSection("ESP Functions")
espSec:CreateToggle({Name = "Fruit ESP", CurrentValue = false, Callback = function(v) state.fruit_esp = v; toggleESP(state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp) end})
espSec:CreateToggle({Name = "Player ESP", CurrentValue = false, Callback = function(v) state.player_esp = v; toggleESP(state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp) end})
espSec:CreateToggle({Name = "NPC ESP", CurrentValue = false, Callback = function(v) state.npc_esp = v; toggleESP(state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp) end})
espSec:CreateToggle({Name = "Chest ESP", CurrentValue = false, Callback = function(v) state.chest_esp = v; toggleESP(state.fruit_esp or state.player_esp or state.npc_esp or state.chest_esp) end})
espSec:CreateDropdown({Name = "Fruit Rarity Filter", Options = {"Все", "Rare+", "Legendary+", "Mythical"}, CurrentOption = "Все", Callback = function(v) state.fruit_filter = v end})

-- Телепорты
local teleTab = Window:CreateTab({Name = "Телепорты", Icon = "navigation", ImageSource = "Material"})
local teleSec = teleTab:CreateSection("Телепорт между морями")
teleSec:CreateButton({Name = "Teleport to 1st Sea", Callback = function() teleport(seaCoords["1st Sea"]) end})
teleSec:CreateButton({Name = "Teleport to 2nd Sea", Callback = function() teleport(seaCoords["2nd Sea"]) end})
teleSec:CreateButton({Name = "Teleport to 3rd Sea", Callback = function() teleport(seaCoords["3rd Sea"]) end})

-- Настройки
local setTab = Window:CreateTab({Name = "Настройки", Icon = "settings", ImageSource = "Material"})
local setSec = setTab:CreateSection("Общие")
local keyOptions = {"RightShift","LeftShift","RightControl","LeftControl","K","L","U","I","O","P","Q","E","R","T","Y","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12"}
local keyDropdown = setSec:CreateDropdown({Name = "Клавиша открытия", Options = keyOptions, CurrentOption = state.window_bind, Callback = function(opt) state.window_bind = type(opt)=="table" and opt[1] or opt; updateKeybind() end})
setSec:CreateButton({Name = "Unload Script", Callback = function() attackRunning = false; esp.active = false; clearESP(); Window:Destroy() end})

-- ============================================
-- ГОРЯЧАЯ КЛАВИША
-- ============================================
local mainFrame, visible = nil, true
local function findFrame()
    local p = gethui and gethui() or game:GetService("CoreGui")
    for _,g in ipairs(p:GetChildren()) do
        if g.Name == "Luna UI" and g:FindFirstChild("SmartWindow") then
            mainFrame = g.SmartWindow
            return true
        end
    end
    return false
end
findFrame() or task.wait(1) and findFrame()
pcall(function() if Window._bindConnection then Window._bindConnection:Disconnect() end; Window.Bind = Enum.KeyCode.Unknown end)
local function updateKeybind()
    if _G.__keyConnection then _G.__keyConnection:Disconnect() end
    local bind = state.window_bind
    _G.__keyConnection = UIS.InputBegan:Connect(function(i, g)
        if g then return end
        if tostring(i.KeyCode):gsub("Enum.KeyCode.", "") == bind then
            if mainFrame then
                visible = not visible
                mainFrame.Visible = visible
                if mainFrame.Parent:FindFirstChild("ShadowHolder") then mainFrame.Parent.ShadowHolder.Visible = visible end
            end
        end
    end)
end
updateKeybind()
task.wait(0.5)
if mainFrame then mainFrame.Visible = true end

-- ============================================
-- ФИНАЛЬНЫЕ УВЕДОМЛЕНИЯ
-- ============================================
Luna:Notification({Title = "Abyss Hub", Content = "Скрипт загружен! Клавиша: " .. state.window_bind, Icon = "sparkle", ImageSource = "Material", Duration = 3})
print("Abyss Hub загружен!")
