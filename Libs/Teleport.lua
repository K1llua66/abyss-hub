-- Teleport Module
local Teleport = {}

local coords = {
    Sea1 = Vector3.new(-1250,80,330),
    Sea2 = Vector3.new(-1250,80,330),
    Sea3 = Vector3.new(-1250,80,330),
    PirateStarter = Vector3.new(-1150,80,380),
    MarineStarter = Vector3.new(-1150,80,380),
    Jungle = Vector3.new(-1150,80,380),
    Desert = Vector3.new(-1150,80,380),
    SkyIslands = Vector3.new(-1150,80,380),
    KingdomRose = Vector3.new(-1150,80,380),
    PortTown = Vector3.new(-1150,80,380)
}

function Teleport:To(pos)
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(pos) end
end

return {Coords = coords, Teleport = Teleport.To}
