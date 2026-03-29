local AutoFarm = {
    Active = false,
    Mode = "Level", -- "Level" or "Nearest"
    Weapon = "Melee", -- "Melee", "Sword", "Fruit"
    CurrentQuest = nil,
    CurrentTarget = nil,
    Loop = nil
}

function AutoFarm:Start()
    if self.Loop then return end
    self.Active = true
    self.Loop = game:GetService("RunService").RenderStepped:Connect(function()
        if not self.Active then return end
        
        if self.Mode == "Level" then
            self:LevelMode()
        elseif self.Mode == "Nearest" then
            self:NearestMode()
        end
    end)
end

function AutoFarm:LevelMode()
    -- Логика: проверяем квест → берем квест → убиваем мобов → сдаем квест
end

function AutoFarm:NearestMode()
    -- Просто атакуем ближайшего моба
end

return AutoFarm
