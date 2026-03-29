-- Abyss Hub (консольная версия)
print("=== Abyss Hub ===")
print("Commands:")
print("  farm_level on/off - Auto Farm Level")
print("  farm_nearby on/off - Auto Farm Nearby")
print("  teleport_1 - Teleport to 1st Sea")
print("  teleport_2 - Teleport to 2nd Sea")
print("  teleport_3 - Teleport to 3rd Sea")
print("  fast_attack on/off - Fast Attack")
print("  dash [0-200] - Dash Length")
print("  unload - Unload script")
print("  help - Show commands")

local state = {
    farm_level = false,
    farm_nearby = false,
    fast_attack = true,
    dash_length = 0
}

local function executeCommand(cmd)
    local args = {}
    for word in cmd:gmatch("%S+") do
        table.insert(args, word)
    end
    local command = args[1] and args[1]:lower() or ""
    local param = args[2]

    if command == "farm_level" then
        if param == "on" then state.farm_level = true
        elseif param == "off" then state.farm_level = false
        else print("Usage: farm_level on/off") end
        print("[Farm] Level:", state.farm_level)
    
    elseif command == "farm_nearby" then
        if param == "on" then state.farm_nearby = true
        elseif param == "off" then state.farm_nearby = false
        else print("Usage: farm_nearby on/off") end
        print("[Farm] Nearby:", state.farm_nearby)
    
    elseif command == "teleport_1" then
        print("[Teleport] 1st Sea")
    
    elseif command == "teleport_2" then
        print("[Teleport] 2nd Sea")
    
    elseif command == "teleport_3" then
        print("[Teleport] 3rd Sea")
    
    elseif command == "fast_attack" then
        if param == "on" then state.fast_attack = true
        elseif param == "off" then state.fast_attack = false
        else print("Usage: fast_attack on/off") end
        print("[PvP] Fast Attack:", state.fast_attack)
    
    elseif command == "dash" then
        local val = tonumber(param)
        if val and val >= 0 and val <= 200 then
            state.dash_length = val
            print("[PvP] Dash Length:", val)
        else
            print("Usage: dash [0-200]")
        end
    
    elseif command == "unload" then
        print("Unloading...")
        return true
    
    elseif command == "help" then
        print("Commands: farm_level, farm_nearby, teleport_1, teleport_2, teleport_3, fast_attack, dash, unload, help")
    
    else
        print("Unknown command. Type 'help' for commands.")
    end
    return false
end

-- Слушаем ввод в консоли
local userInput = ""
while true do
    userInput = readconsole and readconsole() or "help"
    if executeCommand(userInput) then break end
    wait(0.1)
end

print("Script unloaded")
