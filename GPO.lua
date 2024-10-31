local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclipEnabled = false
local flyEnabled = false
local flySpeed = 50

-- Создание GUI-элементов
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
local toggleButton = Instance.new("TextButton", frame)
local flyButton = Instance.new("TextButton", frame)

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

-- Логика noclip
game:GetService("RunService").Heartbeat:Connect(function()
    if noclipEnabled then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            -- Перемещение вперед
            rootPart.CFrame = rootPart.CFrame + rootPart.CFrame.LookVector * 0.5 -- Увеличьте значение для быстрого перемещения
        end
    end
end)

-- Функция включения/выключения Fly
local function toggleFly()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyButton.Text = "Fly On"
        flyButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2) -- Зеленый цвет для включенного состояния
    else
        flyButton.Text = "Fly Off"
        flyButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2) -- Красный цвет для выключенного состояния
    end
end

-- Логика полета
game:GetService("RunService").Heartbeat:Connect(function()
    if flyEnabled then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local camera = game.Workspace.CurrentCamera
            local direction = Vector3.new()

            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end

            direction = direction.Unit * flySpeed -- Устанавливаем скорость полета
            rootPart.Velocity = Vector3.new(direction.X, rootPart.Velocity.Y, direction.Z) -- Сохраняем вертикальную скорость
        end
    end
end)

-- Подключение функций к кнопкам
toggleButton.MouseButton1Click:Connect(toggleNoclip)
flyButton.MouseButton1Click:Connect(toggleFly)

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
