-- Player Module (Speed & Jump)
local Player = { Speed = 1, Jump = 1, SpeedEnabled = false, JumpEnabled = false }

local LP = game:GetService("Players").LocalPlayer

function Player:Update()
    local char = LP.Character
    local hum = char and char:FindFirstChild("Humanoid")
    if not hum then return end
    hum.WalkSpeed = self.SpeedEnabled and 16 * self.Speed or 16
    hum.JumpPower = self.JumpEnabled and 50 * self.Jump or 50
end

function Player:SetSpeed(v)
    self.Speed = v
    if self.SpeedEnabled then self:Update() end
end

function Player:SetJump(v)
    self.Jump = v
    if self.JumpEnabled then self:Update() end
end

game:GetService("RunService").Heartbeat:Connect(function() Player:Update() end)

return Player
