-- [ c:\Users\JDH\Desktop\original\justdoit\aim\Bootloader.lua ]
-- Bootloader for the Custom Aim Trainer Project

getgenv().AimEnvironment = {}

local function LoadModule(fileName)
    -- Загрузчик модулей напрямик с GitHub (через Raw URL)
    local url = "https://raw.githubusercontent.com/JDH-githbu/ver-script/main/" .. fileName
    
    local success, content = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and content then
        return loadstring(content)()
    end
    warn("Failed to load module from GitHub: " .. url)
end

-- Загружаем модули с репозитория проекта (JDH-githbu/ver-script)
AimEnvironment.VirtualSpace = LoadModule("VirtualSpace.lua")
AimEnvironment.Trainer = LoadModule("Trainer.lua")
AimEnvironment.UI = LoadModule("UI.lua")

-- Инициализируем среду
if AimEnvironment.VirtualSpace then AimEnvironment.VirtualSpace.Init() end
if AimEnvironment.UI then AimEnvironment.UI.Init() end

print("AimTrainer Bootloader initialized! Press Right Shift to open the arena.")
