-- ESP Module
local ESP = {
    Enabled = false,
    Objects = {
        Fruits = false,
        Players = false,
        NPC = false,
        Chests = false,
        Islands = false
    },
    Labels = {}
}

local devilFruits = {
    "Bomb","Spike","Chop","Spring","Kilo","Spin",
    "Flame","Ice","Sand","Dark","Revive","Diamond","Light",
    "Rubber","Barrier","Ghost","Magma","Quake","Buddha","Love",
    "Spider","Phoenix","Portal","Rumble","Dragon","Leopard",
    "Mammoth","T-Rex","Spirit","Venom","Control","Gravity","Shadow","Dough"
}

local function isFruit(obj)
    if not obj:IsA("Tool") then return false end
    for _, f in ipairs(devilFruits) do
        if obj.Name:find(f) then return true end
    end
    return false
end

function ESP:AddLabel(obj, text, color, offset)
    if not obj then return end
    for o,l in pairs(self.Labels) do
        if l and l.Adornee == obj then
            local tl = l:FindFirstChild("Text")
            if tl then tl.Text = text end
            return
        end
    end
    local bill = Instance.new("BillboardGui")
    bill.Adornee = obj
    bill.Size = UDim2.new(0,140,0,24)
    bill.StudsOffset = Vector3.new(0, offset or 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = obj
    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or Color3.new(1,1,1)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = bill
    self.Labels[obj] = bill
end

function ESP:Clear()
    for _,l in pairs(self.Labels) do pcall(function() l:Destroy() end) end
    self.Labels = {}
end

function ESP:Update()
    if not self.Enabled then return end
    if self.Objects.Fruits then
        for _,o in ipairs(workspace:GetDescendants()) do
            if isFruit(o) then
                self:AddLabel(o, "🍎 "..o.Name, Color3.new(0,1,0), 2.5)
            end
        end
    end
    if self.Objects.Players then
        for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                local c = p.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    self:AddLabel(c, "👤 "..p.Name, p.TeamColor and p.TeamColor.Color or Color3.new(1,0.5,0.5), 3)
                end
            end
        end
    end
    if self.Objects.NPC and workspace:FindFirstChild("Enemies") then
        for _,n in ipairs(workspace.Enemies:GetChildren()) do
            if n:FindFirstChild("Humanoid") and n.Humanoid.Health > 0 then
                self:AddLabel(n, "👾 "..n.Name, Color3.new(1,0.7,0), 3)
            end
        end
    end
    if self.Objects.Chests then
        for _,c in ipairs(workspace:GetDescendants()) do
            if c:IsA("Model") and (c.Name:lower():find("chest") or c.Name:lower():find("crate")) then
                self:AddLabel(c, "📦 Chest", Color3.new(1,0.84,0), 2)
            end
        end
    end
    for o,l in pairs(self.Labels) do
        if not o or not o.Parent then pcall(function() l:Destroy() end); self.Labels[o]=nil end
    end
end

function ESP:Start()
    self.Enabled = true
    task.spawn(function() while self.Enabled do self:Update(); task.wait(0.3) end end)
end

function ESP:Stop()
    self.Enabled = false
    self:Clear()
end

return ESP
