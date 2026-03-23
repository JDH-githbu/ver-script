-- [ c:\Users\JDH\Desktop\original\justdoit\aim\UI.lua ]
local UI = {}
local CoreGui = game:GetService("CoreGui")

UI.ScreenGui = nil
UI.ScoreLabel = nil

function UI.Init()
    local sg = Instance.new("ScreenGui")
    sg.Name = "AimTrainerUI"
    sg.Enabled = false
    -- Попытка поместить в CoreGui (защита от сканирования из игры)
    local success = pcall(function() sg.Parent = CoreGui end)
    if not success then sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
    
    UI.ScreenGui = sg
    
    -- Главная панель кнопок (интерактивная)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 220, 0, 300)
    Frame.Position = UDim2.new(0, 50, 0.5, -150)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Frame.BorderSizePixel = 0
    Frame.Parent = sg
    
    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 8)
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "🎮 Aim Trainer"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Title.Parent = Frame
    Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
    
    -- Метка очков
    UI.ScoreLabel = Instance.new("TextLabel")
    UI.ScoreLabel.Size = UDim2.new(0.9, 0, 0, 30)
    UI.ScoreLabel.Position = UDim2.new(0.05, 0, 0, 45)
    UI.ScoreLabel.Text = "Score: 0"
    UI.ScoreLabel.Font = Enum.Font.Gotham
    UI.ScoreLabel.TextSize = 16
    UI.ScoreLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
    UI.ScoreLabel.BackgroundTransparency = 1
    UI.ScoreLabel.Parent = Frame
    
    -- Вспомогательная функция создания кнопок
    local function CreateButton(text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 40)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.Text = text
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 14
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BorderSizePixel = 0
        btn.Parent = Frame
        
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) end)
        btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end)
        btn.MouseButton1Click:Connect(callback)
    end
    
    CreateButton("🎯 Gridshot (Флики)", 85, function()
        if AimEnvironment and AimEnvironment.Trainer then
            AimEnvironment.Trainer.StartGridshot()
        end
    end)
    
    CreateButton("🏃‍♂️ Target Tracking (Трекинг)", 135, function()
        if AimEnvironment and AimEnvironment.Trainer then
            AimEnvironment.Trainer.StartTracking()
        end
    end)
    
    CreateButton("⏹️ Stop Training", 185, function()
        if AimEnvironment and AimEnvironment.Trainer then
            AimEnvironment.Trainer.Stop()
        end
    end)
    
    local HelpText = Instance.new("TextLabel")
    HelpText.Size = UDim2.new(0.9, 0, 0, 40)
    HelpText.Position = UDim2.new(0.05, 0, 0, 240)
    HelpText.Text = "RShift to exit virtual space\nYour real body is frozen."
    HelpText.Font = Enum.Font.Gotham
    HelpText.TextSize = 12
    HelpText.TextColor3 = Color3.fromRGB(150, 150, 150)
    HelpText.BackgroundTransparency = 1
    HelpText.Parent = Frame
end

function UI.UpdateScore(text)
    if UI.ScoreLabel then
        UI.ScoreLabel.Text = text
    end
end

function UI.Show()
    if UI.ScreenGui then UI.ScreenGui.Enabled = true end
end

function UI.Hide()
    if UI.ScreenGui then UI.ScreenGui.Enabled = false end
end

return UI
