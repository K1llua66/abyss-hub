--[[
    Abyss Hub
    Консольная версия (без GUI)
    Управление через консоль
]]

-- Проверка игры
local gameId = game.PlaceId
local validIds = {2753915549, 4442272183, 7449423635}
local isValid = false
for _, id in ipairs(validIds) do
    if gameId == id then isValid = true break end
end
if not isValid then
    game:GetService("Players").LocalPlayer:Kick("❌ Abyss Hub работает только в Blox Fruits!")
    return
end

-- Состояние функций
local state = {
    auto_farm_level = false,
    auto_farm_nearby = false,
    auto_farm_boss = false,
    auto_mastery = false,
    auto_fruit_spawn = false,
    auto_fruit_dealer = false,
    auto_chest = false,
    auto_sea_beast = false,
    auto_elite_hunter = false,
    auto_observation = false,
    auto_factory = false,
    auto_mirage = false,
    auto_kitsune_collect = false,
    auto_kitsune_trade = false,
    kitsune_trade_amount = 10,
    fast_attack = true,
    anti_stun = false,
    infinite_energy = false,
    speed = 1,
    jump = 1,
    dash_length = 0,
    infinite_air_jumps = false,
    silent_aim = false,
    silent_mode = "FOV",
    silent_fov = 90,
    silent_distance = 200,
    fruit_esp = false,
    player_esp = false,
    npc_esp = false,
    chest_esp = false,
    island_esp = false,
    flower_esp = false,
    fruit_filter = "Все",
    auto_raid = false,
    raid_type = "Buddha",
    raid_auto_buy = false,
    raid_auto_fruit = false,
    raid_max_price = 500000,
    kill_aura_raid = false,
}

-- Показ меню
local function showMenu()
    print("\n═══════════════════════════════════════")
    print("          ABYSS HUB - Blox Fruits")
    print("═══════════════════════════════════════")
    print("")
    print("📁 ОСНОВНЫЕ КОМАНДЫ:")
    print("  help          - Показать это меню")
    print("  status        - Показать текущие настройки")
    print("  unload        - Выгрузить скрипт")
    print("")
    print("⚔️ ФАРМ:")
    print("  farm_level [on/off]     - Auto Farm (Уровень)")
    print("  farm_nearby [on/off]    - Auto Farm (Ближайшие)")
    print("  farm_boss [on/off]      - Auto Farm Boss")
    print("  mastery [on/off]        - Auto Mastery")
    print("  fruit_spawn [on/off]    - Auto Fruit (Spawn)")
    print("  fruit_dealer [on/off]   - Auto Fruit (Dealer)")
    print("  chest [on/off]          - Auto Chest")
    print("  sea_beast [on/off]      - Auto Sea Beast")
    print("  elite [on/off]          - Auto Elite Hunter")
    print("  observation [on/off]    - Auto Observation")
    print("  factory [on/off]        - Auto Factory")
    print("  mirage [on/off]         - Auto Mirage Island")
    print("  kitsune_collect [on/off]- Auto Kitsune (сбор)")
    print("  kitsune_trade [on/off]  - Auto Kitsune (сдача)")
    print("  kitsune_amount [1-20]   - Кол-во для сдачи")
    print("")
    print("🌀 ТЕЛЕПОРТЫ:")
    print("  tp_1st        - 1st Sea")
    print("  tp_2nd        - 2nd Sea")
    print("  tp_3rd        - 3rd Sea")
    print("  tp_islands    - К островам")
    print("  tp_npc        - К NPC")
    print("  hop           - Поиск сервера")
    print("")
    print("⚡ PVP:")
    print("  fast [on/off]          - Fast Attack")
    print("  stun [on/off]          - Anti-Stun")
    print("  energy [on/off]        - Infinite Energy")
    print("  speed [1-10]           - Скорость")
    print("  jump [1-10]            - Прыжок")
    print("  dash [0-200]           - Длина рывка")
    print("  airjump [on/off]       - Infinite Air Jumps")
    print("  silent [on/off]        - Silent Aim")
    print("  silent_mode [mode]     - Режим (FOV/Ближайший/Дальнейший/Слабейший/Сильнейший)")
    print("  silent_fov [0-360]     - FOV")
    print("  silent_dist [0-500]    - Макс. дистанция")
    print("")
    print("👁️ ESP:")
    print("  fruit_esp [on/off]     - Fruit ESP")
    print("  player_esp [on/off]    - Player ESP")
    print("  npc_esp [on/off]       - NPC ESP")
    print("  chest_esp [on/off]     - Chest ESP")
    print("  island_esp [on/off]    - Island ESP")
    print("  flower_esp [on/off]    - Flower ESP")
    print("  fruit_filter [filter]  - Фильтр (Все/Rare+/Legendary+/Mythical)")
    print("")
    print("🔥 RAID:")
    print("  raid [on/off]          - Auto Raid")
    print("  raid_type [type]       - Тип рейда")
    print("  raid_buy [on/off]      - Авто-покупка")
    print("  raid_fruit [on/off]    - Авто-доставание фрукта")
    print("  raid_price [0-1M]      - Макс. цена фрукта")
    print("  killaura [on/off]      - Kill Aura (5 остров)")
    print("")
    print("📋 Доступные типы рейдов:")
    print("  Flame, Ice, Quake, Light, Dark, Sand, Magma, Phoenix, Rumble, Buddha, Spider, Dough")
    print("═══════════════════════════════════════")
end

-- Показ статуса
local function showStatus()
    print("\n--- ТЕКУЩИЕ НАСТРОЙКИ ---")
    print("Auto Farm Level:", state.auto_farm_level)
    print("Auto Farm Nearby:", state.auto_farm_nearby)
    print("Auto Farm Boss:", state.auto_farm_boss)
    print("Auto Mastery:", state.auto_mastery)
    print("Auto Fruit Spawn:", state.auto_fruit_spawn)
    print("Auto Fruit Dealer:", state.auto_fruit_dealer)
    print("Auto Chest:", state.auto_chest)
    print("Fast Attack:", state.fast_attack)
    print("Dash Length:", state.dash_length)
    print("Silent Aim:", state.silent_aim, "| Mode:", state.silent_mode, "| FOV:", state.silent_fov)
    print("Kill Aura Raid:", state.kill_aura_raid)
    print("------------------------")
end

-- Обработка команд
local function executeCommand(cmd)
    local args = {}
    for word in cmd:gmatch("%S+") do
        table.insert(args, word:lower())
    end
    local command = args[1] or ""
    local param = args[2]

    -- Основные команды
    if command == "help" then
        showMenu()
    
    elseif command == "status" then
        showStatus()
    
    elseif command == "unload" then
        print("Выгрузка Abyss Hub...")
        return true
    
    -- Фарм
    elseif command == "farm_level" then
        if param == "on" then state.auto_farm_level = true
        elseif param == "off" then state.auto_farm_level = false
        else print("Используйте: farm_level on/off") end
        print("[Farm] Level:", state.auto_farm_level)
    
    elseif command == "farm_nearby" then
        if param == "on" then state.auto_farm_nearby = true
        elseif param == "off" then state.auto_farm_nearby = false
        else print("Используйте: farm_nearby on/off") end
        print("[Farm] Nearby:", state.auto_farm_nearby)
    
    elseif command == "farm_boss" then
        if param == "on" then state.auto_farm_boss = true
        elseif param == "off" then state.auto_farm_boss = false
        else print("Используйте: farm_boss on/off") end
        print("[Farm] Boss:", state.auto_farm_boss)
    
    elseif command == "mastery" then
        if param == "on" then state.auto_mastery = true
        elseif param == "off" then state.auto_mastery = false
        else print("Используйте: mastery on/off") end
        print("[Mastery]:", state.auto_mastery)
    
    elseif command == "fruit_spawn" then
        if param == "on" then state.auto_fruit_spawn = true
        elseif param == "off" then state.auto_fruit_spawn = false
        else print("Используйте: fruit_spawn on/off") end
        print("[Fruit] Spawn:", state.auto_fruit_spawn)
    
    elseif command == "fruit_dealer" then
        if param == "on" then state.auto_fruit_dealer = true
        elseif param == "off" then state.auto_fruit_dealer = false
        else print("Используйте: fruit_dealer on/off") end
        print("[Fruit] Dealer:", state.auto_fruit_dealer)
    
    elseif command == "chest" then
        if param == "on" then state.auto_chest = true
        elseif param == "off" then state.auto_chest = false
        else print("Используйте: chest on/off") end
        print("[Chest]:", state.auto_chest)
    
    elseif command == "sea_beast" then
        if param == "on" then state.auto_sea_beast = true
        elseif param == "off" then state.auto_sea_beast = false
        else print("Используйте: sea_beast on/off") end
        print("[Sea Beast]:", state.auto_sea_beast)
    
    elseif command == "elite" then
        if param == "on" then state.auto_elite_hunter = true
        elseif param == "off" then state.auto_elite_hunter = false
        else print("Используйте: elite on/off") end
        print("[Elite Hunter]:", state.auto_elite_hunter)
    
    elseif command == "observation" then
        if param == "on" then state.auto_observation = true
        elseif param == "off" then state.auto_observation = false
        else print("Используйте: observation on/off") end
        print("[Observation]:", state.auto_observation)
    
    elseif command == "factory" then
        if param == "on" then state.auto_factory = true
        elseif param == "off" then state.auto_factory = false
        else print("Используйте: factory on/off") end
        print("[Factory]:", state.auto_factory)
    
    elseif command == "mirage" then
        if param == "on" then state.auto_mirage = true
        elseif param == "off" then state.auto_mirage = false
        else print("Используйте: mirage on/off") end
        print("[Mirage]:", state.auto_mirage)
    
    elseif command == "kitsune_collect" then
        if param == "on" then state.auto_kitsune_collect = true
        elseif param == "off" then state.auto_kitsune_collect = false
        else print("Используйте: kitsune_collect on/off") end
        print("[Kitsune] Collect:", state.auto_kitsune_collect)
    
    elseif command == "kitsune_trade" then
        if param == "on" then state.auto_kitsune_trade = true
        elseif param == "off" then state.auto_kitsune_trade = false
        else print("Используйте: kitsune_trade on/off") end
        print("[Kitsune] Trade:", state.auto_kitsune_trade)
    
    elseif command == "kitsune_amount" then
        local val = tonumber(param)
        if val and val >= 1 and val <= 20 then
            state.kitsune_trade_amount = val
            print("[Kitsune] Trade amount:", val)
        else
            print("Используйте: kitsune_amount [1-20]")
        end
    
    -- Телепорты
    elseif command == "tp_1st" then
        print("[Teleport] 1st Sea")
    
    elseif command == "tp_2nd" then
        print("[Teleport] 2nd Sea")
    
    elseif command == "tp_3rd" then
        print("[Teleport] 3rd Sea")
    
    elseif command == "tp_islands" then
        print("[Teleport] Islands")
    
    elseif command == "tp_npc" then
        print("[Teleport] NPC")
    
    elseif command == "hop" then
        print("[Teleport] Hop to server")
    
    -- PvP
    elseif command == "fast" then
        if param == "on" then state.fast_attack = true
        elseif param == "off" then state.fast_attack = false
        else print("Используйте: fast on/off") end
        print("[Fast Attack]:", state.fast_attack)
    
    elseif command == "stun" then
        if param == "on" then state.anti_stun = true
        elseif param == "off" then state.anti_stun = false
        else print("Используйте: stun on/off") end
        print("[Anti-Stun]:", state.anti_stun)
    
    elseif command == "energy" then
        if param == "on" then state.infinite_energy = true
        elseif param == "off" then state.infinite_energy = false
        else print("Используйте: energy on/off") end
        print("[Infinite Energy]:", state.infinite_energy)
    
    elseif command == "speed" then
        local val = tonumber(param)
        if val and val >= 1 and val <= 10 then
            state.speed = val
            print("[Speed] x", val)
        else
            print("Используйте: speed [1-10]")
        end
    
    elseif command == "jump" then
        local val = tonumber(param)
        if val and val >= 1 and val <= 10 then
            state.jump = val
            print("[Jump] x", val)
        else
            print("Используйте: jump [1-10]")
        end
    
    elseif command == "dash" then
        local val = tonumber(param)
        if val and val >= 0 and val <= 200 then
            state.dash_length = val
            print("[Dash Length]:", val)
        else
            print("Используйте: dash [0-200]")
        end
    
    elseif command == "airjump" then
        if param == "on" then state.infinite_air_jumps = true
        elseif param == "off" then state.infinite_air_jumps = false
        else print("Используйте: airjump on/off") end
        print("[Infinite Air Jumps]:", state.infinite_air_jumps)
    
    elseif command == "silent" then
        if param == "on" then state.silent_aim = true
        elseif param == "off" then state.silent_aim = false
        else print("Используйте: silent on/off") end
        print("[Silent Aim]:", state.silent_aim)
    
    elseif command == "silent_mode" then
        local modes = {"fov", "ближайший", "дальнейший", "слабейший", "сильнейший"}
        for _, m in ipairs(modes) do
            if param == m then
                state.silent_mode = param
                print("[Silent Aim] Mode:", param)
                return
            end
        end
        print("Режимы: FOV, Ближайший, Дальнейший, Слабейший, Сильнейший")
    
    elseif command == "silent_fov" then
        local val = tonumber(param)
        if val and val >= 0 and val <= 360 then
            state.silent_fov = val
            print("[Silent Aim] FOV:", val)
        else
            print("Используйте: silent_fov [0-360]")
        end
    
    elseif command == "silent_dist" then
        local val = tonumber(param)
        if val and val >= 0 and val <= 500 then
            state.silent_distance = val
            print("[Silent Aim] Max Distance:", val)
        else
            print("Используйте: silent_dist [0-500]")
        end
    
    -- ESP
    elseif command == "fruit_esp" then
        if param == "on" then state.fruit_esp = true
        elseif param == "off" then state.fruit_esp = false
        else print("Используйте: fruit_esp on/off") end
        print("[ESP] Fruit:", state.fruit_esp)
    
    elseif command == "player_esp" then
        if param == "on" then state.player_esp = true
        elseif param == "off" then state.player_esp = false
        else print("Используйте: player_esp on/off") end
        print("[ESP] Player:", state.player_esp)
    
    elseif command == "npc_esp" then
        if param == "on" then state.npc_esp = true
        elseif param == "off" then state.npc_esp = false
        else print("Используйте: npc_esp on/off") end
        print("[ESP] NPC:", state.npc_esp)
    
    elseif command == "chest_esp" then
        if param == "on" then state.chest_esp = true
        elseif param == "off" then state.chest_esp = false
        else print("Используйте: chest_esp on/off") end
        print("[ESP] Chest:", state.chest_esp)
    
    elseif command == "island_esp" then
        if param == "on" then state.island_esp = true
        elseif param == "off" then state.island_esp = false
        else print("Используйте: island_esp on/off") end
        print("[ESP] Island:", state.island_esp)
    
    elseif command == "flower_esp" then
        if param == "on" then state.flower_esp = true
        elseif param == "off" then state.flower_esp = false
        else print("Используйте: flower_esp on/off") end
        print("[ESP] Flower:", state.flower_esp)
    
    elseif command == "fruit_filter" then
        local filters = {"все", "rare+", "legendary+", "mythical"}
        for _, f in ipairs(filters) do
            if param == f then
                state.fruit_filter = param
                print("[ESP] Fruit Filter:", param)
                return
            end
        end
        print("Фильтры: Все, Rare+, Legendary+, Mythical")
    
    -- Raid
    elseif command == "raid" then
        if param == "on" then state.auto_raid = true
        elseif param == "off" then state.auto_raid = false
        else print("Используйте: raid on/off") end
        print("[Raid] Auto Raid:", state.auto_raid)
    
    elseif command == "raid_type" then
        local types = {"flame", "ice", "quake", "light", "dark", "sand", "magma", "phoenix", "rumble", "buddha", "spider", "dough"}
        for _, t in ipairs(types) do
            if param == t then
                state.raid_type = param:sub(1,1):upper() .. param:sub(2)
                print("[Raid] Type:", state.raid_type)
                return
            end
        end
        print("Типы: Flame, Ice, Quake, Light, Dark, Sand, Magma, Phoenix, Rumble, Buddha, Spider, Dough")
    
    elseif command == "raid_buy" then
        if param == "on" then state.raid_auto_buy = true
        elseif param == "off" then state.raid_auto_buy = false
        else print("Используйте: raid_buy on/off") end
        print("[Raid] Auto Buy:", state.raid_auto_buy)
    
    elseif command == "raid_fruit" then
        if param == "on" then state.raid_auto_fruit = true
        elseif param == "off" then state.raid_auto_fruit = false
        else print("Используйте: raid_fruit on/off") end
        print("[Raid] Auto Equip Fruit:", state.raid_auto_fruit)
    
    elseif command == "raid_price" then
        local val = tonumber(param)
        if val and val >= 0 and val <= 1000000 then
            state.raid_max_price = val
            print("[Raid] Max Price:", val)
        else
            print("Используйте: raid_price [0-1000000]")
        end
    
    elseif command == "killaura" then
        if param == "on" then state.kill_aura_raid = true
        elseif param == "off" then state.kill_aura_raid = false
        else print("Используйте: killaura on/off") end
        print("[Raid] Kill Aura:", state.kill_aura_raid)
    
    else
        print("Неизвестная команда. Введите 'help' для списка команд.")
    end
    
    return false
end

-- Запуск
print("═══════════════════════════════════════")
print("          ABYSS HUB - Blox Fruits")
print("       Консольная версия (без GUI)")
print("═══════════════════════════════════════")
print("Введите 'help' для списка команд.")
print("═══════════════════════════════════════")

showMenu()

-- Цикл ввода команд
local running = true
while running do
    local input = readconsole and readconsole() or wait(0.5)
    if input and input ~= "" then
        if executeCommand(input) then
            running = false
        end
    end
    wait(0.1)
end

print("Abyss Hub выгружен")
