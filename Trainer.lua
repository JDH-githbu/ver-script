-- [ c:\Users\JDH\Desktop\original\justdoit\aim\Trainer.lua ]
local Trainer = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

Trainer.CurrentMode = "None"
Trainer.Targets = {}
Trainer.Connections = {}
Trainer.Score = 0

-- Позиция нашей арены (должна совпадать с VirtualSpace)
local ArenaOffset = Vector3.new(0, 50000, 0)
local TargetFolder = workspace:FindFirstChild("AimTargets") or Instance.new("Folder")
TargetFolder.Name = "AimTargets"
TargetFolder.Parent = workspace

local function ClearTargets()
    for _, t in ipairs(Trainer.Targets) do
        if t and t.Parent then t:Destroy() end
    end
    Trainer.Targets = {}
end

-- ===================================
-- РЕЖИМ 1: GRIDSHOT (Флики по сферам)
-- ===================================
function Trainer.SpawnGridshotTarget()
    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 2, 2)
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Cyan")
    part.Anchored = true
    part.CanCollide = false
    
    -- Спавним случайным образом перед игроком (на стене арены)
    local rx = math.random(-25, 25)
    local ry = math.random(5, 25)
    local rz = -60 -- Дистанция спавна
    
    part.Position = ArenaOffset + Vector3.new(rx, ry, rz)
    part.Parent = TargetFolder
    
    table.insert(Trainer.Targets, part)
end

function Trainer.StartGridshot()
    Trainer.Stop()
    Trainer.CurrentMode = "Gridshot"
    Trainer.Score = 0
    
    for i = 1, 3 do
        Trainer.SpawnGridshotTarget()
    end
    
    local conn = Mouse.Button1Down:Connect(function()
        local target = Mouse.Target
        if target and target.Parent == TargetFolder then
            target:Destroy()
            Trainer.Score = Trainer.Score + 1
            if AimEnvironment and AimEnvironment.UI then
                AimEnvironment.UI.UpdateScore("Score: " .. Trainer.Score)
            end
            Trainer.SpawnGridshotTarget()
        end
    end)
    table.insert(Trainer.Connections, conn)
end

-- ===================================
-- РЕЖИМ 2: TRACKING (Слежение мышей)
-- ===================================
function Trainer.StartTracking()
    Trainer.Stop()
    Trainer.CurrentMode = "Tracking"
    Trainer.Score = 0
    
    local target = Instance.new("Part")
    target.Size = Vector3.new(2, 5, 2) -- Имитация тела игрока
    target.Position = ArenaOffset + Vector3.new(0, 5, -50)
    target.Anchored = true
    target.Material = Enum.Material.SmoothPlastic
    target.BrickColor = BrickColor.new("Bright red")
    target.Parent = TargetFolder
    table.insert(Trainer.Targets, target)
    
    local timeElapsed = 0
    local conn = RunService.RenderStepped:Connect(function(dt)
        timeElapsed = timeElapsed + dt
        -- Заставляем цель двигаться вправо-влево (синусоида) + иногда менять траекторию
        local offset = math.sin(timeElapsed * 1.5) * 25
        target.Position = ArenaOffset + Vector3.new(offset, 5, -50)
        
        -- Увеличиваем счетчик, если мышка находится ровно на цели
        if Mouse.Target == target then
            Trainer.Score = Trainer.Score + (dt * 100) -- За каждую секунду удержания даем 100 очков
            target.BrickColor = BrickColor.new("Bright green")
            if AimEnvironment and AimEnvironment.UI then
                AimEnvironment.UI.UpdateScore("Score: " .. math.floor(Trainer.Score))
            end
        else
            target.BrickColor = BrickColor.new("Bright red")
        end
    end)
    table.insert(Trainer.Connections, conn)
end

function Trainer.Stop()
    Trainer.CurrentMode = "None"
    ClearTargets()
    for _, c in ipairs(Trainer.Connections) do
        c:Disconnect()
    end
    Trainer.Connections = {}
    if AimEnvironment and AimEnvironment.UI then
        AimEnvironment.UI.UpdateScore("Score: 0")
    end
end

return Trainer
