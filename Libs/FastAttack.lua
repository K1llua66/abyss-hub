--[[
    FastAttack.lua - Исправленная версия
    Бьет только первым ударом M1, но очень быстро
]]

local FastAttack = {
    Active = false,
    PvPMode = false,
    CurrentTarget = nil,
    Loop = nil,
    AttackCooldown = false,
    LastAttackTime = 0,
    AttackDelay = 0.15, -- Задержка между атаками (в секундах)
}

-- Функция для отправки первого удара M1
local function SendM1()
    -- Проверяем, что мы не в кулдауне
    if FastAttack.AttackCooldown then return end
    
    -- Отправляем только ПЕРВЫЙ удар M1
    -- В Blox Fruits M1 атаки идут через UserInputService или Remote
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    -- Способ 1: Через Remote (работает в большинстве случаев)
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local remotes = replicatedStorage:FindFirstChild("Remotes")
    
    if remotes then
        local attackRemote = remotes:FindFirstChild("Attack")
        if attackRemote then
            -- Отправляем только один раз, без продолжения
            attackRemote:FireServer()
            FastAttack.AttackCooldown = true
            
            -- Сброс кулдауна через задержку
            task.delay(FastAttack.AttackDelay, function()
                FastAttack.AttackCooldown = false
            end)
            return
        end
    end
    
    -- Способ 2: Имитация нажатия клавиши (для экзекуторов)
    local virtualInput = game:GetService("VirtualInputManager")
    if virtualInput then
        -- Нажимаем клавишу мыши (M1)
        virtualInput:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        virtualInput:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        
        FastAttack.AttackCooldown = true
        task.delay(FastAttack.AttackDelay, function()
            FastAttack.AttackCooldown = false
        end)
    end
end

-- Функция для поиска цели
local function FindTarget()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closestTarget = nil
    local closestDist = math.huge
    
    -- Поиск мобов
    if not FastAttack.PvPMode then
        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                local humanoid = enemy.Humanoid
                if humanoid.Health > 0 and humanoid.Health < math.huge then
                    local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
                    if dist < closestDist and dist <= 30 then -- Дистанция атаки 30
                        closestDist = dist
                        closestTarget = enemy
                    end
                end
            end
        end
    end
    
    -- Поиск игроков (если включен PvP режим)
    if FastAttack.PvPMode then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherChar = otherPlayer.Character
                if otherChar:FindFirstChild("HumanoidRootPart") and otherChar:FindFirstChild("Humanoid") then
                    local humanoid = otherChar.Humanoid
                    if humanoid.Health > 0 then
                        local dist = (hrp.Position - otherChar.HumanoidRootPart.Position).Magnitude
                        if dist < closestDist and dist <= 30 then
                            closestDist = dist
                            closestTarget = otherChar
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget, closestDist
end

-- Главный цикл атаки
function FastAttack:Start()
    if self.Loop then return end
    self.Active = true
    
    self.Loop = game:GetService("RunService").RenderStepped:Connect(function()
        if not self.Active then return end
        
        -- Находим цель
        local target, dist = FindTarget()
        
        if target then
            -- Смотрим на цель (поворачиваем камеру)
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and target:FindFirstChild("HumanoidRootPart") then
                local cframe = CFrame.new(hrp.Position, target.HumanoidRootPart.Position)
                hrp.CFrame = cframe
            end
            
            -- Атакуем только первым ударом
            SendM1()
        end
    end)
end

function FastAttack:Stop()
    self.Active = false
    if self.Loop then
        self.Loop:Disconnect()
        self.Loop = nil
    end
    self.CurrentTarget = nil
    self.AttackCooldown = false
end

-- Функция для установки конкретной цели
function FastAttack:SetTarget(target)
    if not self.Active then return end
    self.CurrentTarget = target
end

-- Функция для ручной атаки по цели
function FastAttack:AttackTarget(target)
    if not target then return end
    
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp and target:FindFirstChild("HumanoidRootPart") then
        -- Поворачиваемся к цели
        hrp.CFrame = CFrame.new(hrp.Position, target.HumanoidRootPart.Position)
        
        -- Бьем первым ударом
        SendM1()
    end
end

return FastAttack
