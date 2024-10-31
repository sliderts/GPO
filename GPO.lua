local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local noclipEnabled = false

-- Настройка imgui
function imgui.DarkTheme()
    imgui.SwitchContext()
    imgui.GetStyle().WindowBg = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().WindowRounding = 5
end

imgui.DarkTheme()

-- Логика интерфейса
local function renderGUI()
    imgui.Begin("Noclip Menu", true)
    if imgui.Button(noclipEnabled and "Noclip On" or "Noclip Off") then
        toggleNoclip()
    end
    imgui.End()
end

-- Функция включения/выключения Noclip
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    -- Дополнительная логика для изменения цвета кнопки (если необходимо)
end

-- Логика noclip
game:GetService("RunService").Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Основной цикл отрисовки GUI
game:GetService("RunService").RenderStepped:Connect(function()
    imgui.NewFrame()
    renderGUI()
    imgui.Render()
end)
