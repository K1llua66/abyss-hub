-- Поиск ближайшего моба/игрока/NPC
local Utils = {
    GetClosestMob = function()
        local localPlayer = game.Players.LocalPlayer
        local character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
        local hrp = character.HumanoidRootPart
        local closest, closestDist = nil, math.huge
        
        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                local dist = (hrp.Position - v.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = v
                end
            end
        end
        return closest, closestDist
    end,
    
    GetClosestQuestNPC = function()
        -- Поиск NPC с символом квеста над головой
    end,
    
    IsInRange = function(pos1, pos2, range)
        return (pos1 - pos2).Magnitude <= range
    end
}

return Utils
