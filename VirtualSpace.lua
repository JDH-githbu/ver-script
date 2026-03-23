-- [ c:\Users\JDH\Desktop\original\justdoit\aim\VirtualSpace.lua ]
local VirtualSpace = {}
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

VirtualSpace.IsActive = false
-- Строим арену очень высоко, чтобы не пересекаться с объектами плейса
VirtualSpace.ArenaLocation = Vector3.new(0, 50000, 0)
VirtualSpace.ArenaParts = {}
VirtualSpace.RealCharacter = nil
VirtualSpace.FakeCharacter = nil

function VirtualSpace.BuildArena()
    local floor = Instance.new("Part")
    floor.Name = "ArenaFloor"
    floor.Size = Vector3.new(150, 1, 150)
    floor.Position = VirtualSpace.ArenaLocation
    floor.Anchored = true
    floor.Material = Enum.Material.SmoothPlastic
    floor.BrickColor = BrickColor.new("Dark stone grey")
    floor.Parent = workspace
    table.insert(VirtualSpace.ArenaParts, floor)
    
    -- Добавляем стены
    local function makeWall(pos, size)
        local w = Instance.new("Part")
        w.Size = size
        w.Position = pos
        w.Anchored = true
        w.Transparency = 0.5
        w.BrickColor = BrickColor.new("Really black")
        w.Parent = workspace
        table.insert(VirtualSpace.ArenaParts, w)
    end
    
    makeWall(VirtualSpace.ArenaLocation + Vector3.new(0, 25, -75), Vector3.new(150, 50, 1))
    makeWall(VirtualSpace.ArenaLocation + Vector3.new(0, 25, 75), Vector3.new(150, 50, 1))
    makeWall(VirtualSpace.ArenaLocation + Vector3.new(-75, 25, 0), Vector3.new(1, 50, 150))
    makeWall(VirtualSpace.ArenaLocation + Vector3.new(75, 25, 0), Vector3.new(1, 50, 150))
end

function VirtualSpace.DestroyArena()
    for _, part in ipairs(VirtualSpace.ArenaParts) do
        part:Destroy()
    end
    VirtualSpace.ArenaParts = {}
end

function VirtualSpace.Toggle()
    VirtualSpace.IsActive = not VirtualSpace.IsActive
    print("Virtual Space Active:", VirtualSpace.IsActive)
    
    if VirtualSpace.IsActive then
        -- АКТИВАЦИЯ АРЕНЫ
        VirtualSpace.RealCharacter = LocalPlayer.Character
        if VirtualSpace.RealCharacter and VirtualSpace.RealCharacter:FindFirstChild("HumanoidRootPart") then
            -- Замораживаем настоящего игрока в основном мире
            VirtualSpace.RealCharacter.HumanoidRootPart.Anchored = true
            
            -- Создаем "копию" игрока локально для тренировки
            VirtualSpace.RealCharacter.Archivable = true
            VirtualSpace.FakeCharacter = VirtualSpace.RealCharacter:Clone()
            VirtualSpace.FakeCharacter.Parent = workspace
            VirtualSpace.FakeCharacter:SetPrimaryPartCFrame(CFrame.new(VirtualSpace.ArenaLocation + Vector3.new(0, 5, 0)))
            
            -- Подменяем персонажа локально, чтобы стандартный скрипт камеры управлял им
            LocalPlayer.Character = VirtualSpace.FakeCharacter
            Camera.CameraSubject = VirtualSpace.FakeCharacter:WaitForChild("Humanoid")
            
            VirtualSpace.BuildArena()
            
            if AimEnvironment and AimEnvironment.UI then
                AimEnvironment.UI.Show()
            end
        end
    else
        -- ВЫХОД ИЗ АРЕНЫ
        if VirtualSpace.FakeCharacter then
            VirtualSpace.FakeCharacter:Destroy()
        end
        if VirtualSpace.RealCharacter then
            -- Возвращаем управление оригинальному персонажу
            LocalPlayer.Character = VirtualSpace.RealCharacter
            if VirtualSpace.RealCharacter:FindFirstChild("HumanoidRootPart") then
                -- Размораживаем
                VirtualSpace.RealCharacter.HumanoidRootPart.Anchored = false
            end
            Camera.CameraSubject = VirtualSpace.RealCharacter:WaitForChild("Humanoid")
        end
        VirtualSpace.DestroyArena()
        
        -- Останавливаем текущие модули тренировки
        if AimEnvironment and AimEnvironment.Trainer then
            AimEnvironment.Trainer.Stop()
        end
        if AimEnvironment and AimEnvironment.UI then
            AimEnvironment.UI.Hide()
        end
    end
end

function VirtualSpace.Init()
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            VirtualSpace.Toggle()
        end
    end)
end

return VirtualSpace
