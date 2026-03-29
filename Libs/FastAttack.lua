-- Fast Attack Module
local FastAttack = { Enabled = false, Cooldown = 0.18, LastAttack = 0, PvPMode = false }

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local VU = syn and syn.virtual_user or (getrenv and getrenv().virtual_user)

function FastAttack:GetTarget()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local nearest, nearestDist = nil, 22
    local pos = root.Position
    local enemies = workspace:FindFirstChild("Enemies")
    if enemies then
        for _,n in ipairs(enemies:GetChildren()) do
            if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 then
                local nr = n:FindFirstChild("HumanoidRootPart")
                if nr then
                    local d = (pos - nr.Position).Magnitude
                    if d < nearestDist then nearest, nearestDist = n, d end
                end
            end
        end
    end
    if self.PvPMode then
        for _,p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local c = p.Character
                if c and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
                    local cr = c:FindFirstChild("HumanoidRootPart")
                    if cr then
                        local d = (pos - cr.Position).Magnitude
                        if d < nearestDist then nearest, nearestDist = c, d end
                    end
                end
            end
        end
    end
    return nearest
end

function FastAttack:Attack()
    if not self.Enabled then return end
    local target = self:GetTarget()
    if not target then return end
    local now = tick()
    if now - self.LastAttack < self.Cooldown then return end
    local tr = target:FindFirstChild("HumanoidRootPart")
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if tr and root then
        root.CFrame = CFrame.new(root.Position, tr.Position)
        pcall(function()
            local VIM = game:GetService("VirtualInputManager")
            VIM:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(0.02)
            VIM:SendMouseButtonEvent(0,0,0,false,game,0)
            if VU then VU:ClickButton1() end
        end)
        self.LastAttack = now
    end
end

function FastAttack:Start()
    if self.Running then return end
    self.Running = true
    self.Enabled = true
    task.spawn(function() while self.Running do self:Attack(); task.wait(self.Cooldown) end end)
end

function FastAttack:Stop()
    self.Running = false
    self.Enabled = false
end

return FastAttack
