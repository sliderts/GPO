local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50
local flySpeedIncrement = 5

-- Создание GUI-элементов
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
local toggleButton = Instance.new("TextButton", frame)
local flyButton = Instance.new("TextButton", frame)
local speedSlider = Instance.new("Slider", frame)

-- Настройка меню и кнопок
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0.5, -100, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Active = true -- Чтобы включить перетаскивание

toggleButton.Size = UDim2.new(0, 100, 0, 50)
toggleButton.Position = UDim2.new(0.5, -105, 0, 0)
toggleButton.Text = "Noclip Off"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2) -- Красный цвет для выключенного состояния
toggleButton.BorderSizePixel = 0
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextWrapped = true
toggleButton.BackgroundTransparency = 0.1
toggleButton.AutoButtonColor = false

flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(0.5, 5, 0, 0)
flyButton.Text = "Fly Off"
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2) -- Красный цвет для выключенного состояния
flyButton.BorderSizePixel = 0
flyButton.TextScaled = true
flyButton.Font = Enum.Font.SourceSans
flyButton.TextWrapped = true
flyButton.BackgroundTransparency = 0.1
flyButton.AutoButtonColor = false

-- Создание ползунка для скорости полета
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 180, 0, 50)
speedLabel.Position = UDim2.new(0.5, -90, 0, 60)
speedLabel.Text = "Fly Speed: " .. flySpeed
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

local slider = Instance.new("Slider", frame)
slider.Size = UDim2.new(0, 180, 0, 20)
slider.Position = UDim2.new(0.5, -90, 0, 110)
slider.MinValue = 0
slider.MaxValue = 200
slider.Value = flySpeed

-- Закругление кнопок
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 25)
toggleCorner.Parent = toggleButton

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 25)
flyCorner.Parent = flyButton

-- Функция включения/выключения Noclip
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        toggleButton.Text = "Noclip On"
        toggleButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2) -- Зеленый цвет для включенного состояния
    else
        toggleButton.Text = "Noclip Off"
        toggleButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2) -- Красный цвет для выключенного состояния
    end
end

-- Функция включения/выключения Fly
local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyButton.Text = "Fly On"
        flyButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2) -- Зеленый цвет для включенного состояния
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000) -- Плавное движение
        bodyVelocity.Parent = character.HumanoidRootPart
        
        -- Обновление скорости при изменении ползунка
        slider.ValueChanged:Connect(function(value)
            flySpeed = value
            speedLabel.Text = "Fly Speed: " .. math.floor(flySpeed)
            bodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
        end)
    else
        flyButton.Text = "Fly Off"
        flyButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2) -- Красный цвет для выключенного состояния
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("BodyVelocity") then
                v:Destroy()
            end
        end
    end
end

-- Подключение функций к кнопкам
toggleButton.MouseButton1Click:Connect(toggleNoclip)
flyButton.MouseButton1Click:Connect(toggleFly)

-- Логика noclip, чтобы она работала постоянно при включении
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Логика перетаскивания меню
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Скрытие/показ меню по нажатию клавиши "M"
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)
