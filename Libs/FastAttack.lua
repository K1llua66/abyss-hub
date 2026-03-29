--[[
    FastAttack.lua - Универсальная версия
    Работает на всех экзекуторах (Xeno, Delta, Vega X, Arceus X и др.)
    Бьет только первым ударом M1 без отбрасывания
]]

local FastAttack = {
    Active = false,
    PvPMode = false,
    CurrentTarget = nil,
    Loop = nil,
    CanAttack = true,
    LastAttack = 0,
    AttackSpeed = 0.12, -- Скорость атаки (секунд)
}

-- Функция отправки M1 атаки (работает на всех экзекуторах)
local function SendM1()
    -- Проверяем возможность атаки
    if not FastAttack.CanAttack then return end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end
    
    -- Способ 1: Через Remote (самый надежный)
    local success = false
    
    -- Пробуем разные варианты Remote'ов
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if remotes then
        -- Стандартный Remote для атаки
        local attackRemote = remotes:FindFirstChild("Attack")
        if attackRemote then
            pcall(function()
                attackRemote:FireServer()
                success = true
            end)
        end
        
        -- Альтернативные Remote'ы
        if not success then
            local combatRemote = remotes:FindFirstChild("Combat")
            if combatRemote then
                pcall(function()
                    combatRemote:FireServer("M1")
                    success = true
                end)
            end
        end
        
        if not success then
            local meleeRemote = remotes:FindFirstChild("MeleeAttack")
            if meleeRemote then
                pcall(function()
                    meleeRemote:FireServer()
                    success = true
                end)
            end
        end
    end
    
    -- Способ 2: Через ContextActionService (для некоторых экзекуторов)
    if not success then
        local contextAction = game:GetService("ContextActionService")
        if contextAction then
            pcall(function()
                -- Имитация нажатия кнопки атаки
                contextAction:PressButton("Attack")
                task.wait(0.05)
                contextAction:ReleaseButton("Attack")
                success = true
            end)
        end
    end
    
    -- Способ 3: Через симуляцию мыши (если поддерживается)
    if not success then
        pcall(function()
            local mouse = player:GetMouse()
            if mouse then
                -- Эмулируем клик мыши
                mouse.Button1Down:Fire()
                task.wait(0.05)
                mouse.Button1Up:Fire()
                success = true
            end
        end)
    end
    
    -- Если все способы не сработали, используем прямой вызов (экспериментально)
    if not success then
        pcall(function()
            local attackMethod = character:FindFirstChild("AttackMethod")
            if attackMethod and attackMethod:IsA("RemoteEvent") then
                attackMethod:FireServer()
            end
        end)
    end
    
    -- Устанавливаем кулдаун
    if success then
        FastAttack.CanAttack = false
        task.delay(FastAttack.AttackSpeed, function()
            FastAttack.CanAttack = true
        end)
    end
end

-- Поиск ближайшей цели
local function FindTarget()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return nil end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local closestTarget = nil
    local closestDist = 50 -- Максимальная дистанция поиска
    
    -- Поиск мобов
    if not FastAttack.PvPMode then
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in pairs(enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                    local humanoid = enemy.Humanoid
                    if humanoid.Health > 0 then
                        local dist = (hrp.Position - enemy.HumanoidRootPart.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestTarget = enemy
                        end
                    end
                end
            end
        end
        
        -- Альтернативный поиск мобов (если нет папки Enemies)
        if not closestTarget then
            for _, obj in pairs(workspace:GetChildren()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not obj:FindFirstChild("PlayerGui") then
                    if obj:FindFirstChild("HumanoidRootPart") then
                        local humanoid = obj.Humanoid
                        if humanoid.Health > 0 then
                            local dist = (hrp.Position - obj.HumanoidRootPart.Position).Magnitude
                            if dist < closestDist then
                                closestDist = dist
                                closestTarget = obj
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Поиск игроков (PvP режим)
    if FastAttack.PvPMode then
        for _, otherPlayer in pairs(game.Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherChar = otherPlayer.Character
                if otherChar:FindFirstChild("HumanoidRootPart") and otherChar:FindFirstChild("Humanoid") then
                    local humanoid = otherChar.Humanoid
                    if humanoid.Health > 0 then
                        local dist = (hrp.Position - otherChar.HumanoidRootPart.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestTarget = otherChar
                        end
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Поворот к цели
local function LookAt(target)
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if target and target:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.HumanoidRootPart.Position
        local lookVector = (targetPos - hrp.Position).Unit
        local newCFrame = CFrame.lookAt(hrp.Position, targetPos)
        
        -- Плавный поворот
        hrp.CFrame = hrp.CFrame:Lerp(newCFrame, 0.5)
    end
end

-- Главный цикл
function FastAttack:Start()
    if self.Loop then 
        self:Stop()
    end
    
    self.Active = true
    self.CanAttack = true
    
    self.Loop = game:GetService("RunService").Heartbeat:Connect(function()
        if not self.Active then return end
        
        local target = self.CurrentTarget or FindTarget()
        
        if target then
            LookAt(target)
            
            -- Атакуем только если цель в радиусе
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("HumanoidRootPart") then
                local dist = (char.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
                if dist <= 15 then -- Радиус атаки
                    SendM1()
                end
            end
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
    self.CanAttack = true
end

-- Установка цели
function FastAttack:SetTarget(target)
    self.CurrentTarget = target
end

-- Изменение скорости атаки
function FastAttack:SetSpeed(speed)
    self.AttackSpeed = math.max(0.05, math.min(0.5, speed))
end

return FastAttack
