-- Abyss Hub (с загрузкой конфига)
local config = loadfile("config.lua")() or {}

print("=== Abyss Hub ===")
print("Текущие настройки:")
for k, v in pairs(config) do
    print("  " .. k .. ":", v)
end
print("")
print("Чтобы изменить настройки, отредактируйте файл config.lua")
print("и перезапустите скрипт.")

-- Здесь будет основная логика, использующая config
