-- [ c:\Users\JDH\Desktop\original\justdoit\aim\Bootloader.lua ]
-- Bootloader for the Custom Aim Trainer Project

getgenv().AimEnvironment = {}

local function LoadModule(path)
    -- Универсальный загрузчик локальных модулей (подходит для большинства Roblox экзекуторов)
    local success, func = pcall(function() return loadfile(path) end)
    if success and func then return func() end
    
    -- Резервный метод для экзекуторов 
    if readfile and loadstring then
        local content = readfile(path)
        if content then return loadstring(content)() end
    end
    warn("Failed to load module: " .. path)
end

local basePath = "c:\\Users\\JDH\\Desktop\\original\\justdoit\\aim\\"

-- Загружаем модули
AimEnvironment.VirtualSpace = LoadModule(basePath .. "VirtualSpace.lua")
AimEnvironment.Trainer = LoadModule(basePath .. "Trainer.lua")
AimEnvironment.UI = LoadModule(basePath .. "UI.lua")

-- Инициализируем среду
if AimEnvironment.VirtualSpace then AimEnvironment.VirtualSpace.Init() end
if AimEnvironment.UI then AimEnvironment.UI.Init() end

print("AimTrainer Bootloader initialized! Press Right Shift to open the arena.")
