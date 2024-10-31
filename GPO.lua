local imgui = require 'imgui'
local vkeys = require 'vkeys'

-- Переменные
local showMenu = imgui.ImBool(false)
local flyActive = false
local flyBindKey = vkeys.VK_F -- Клавиша для активации флая, можно изменить
local menuPosition = imgui.ImVec2(100, 100) -- Начальная позиция меню

-- Темная тема
function imgui.DarkTheme()
    imgui.SwitchContext()
    -- Настройки стиля (как в вашем коде)
    -- ==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10
    imgui.GetStyle().WindowBorderSize = 1
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    -- Здесь можно добавить все остальные цвета
end

-- Главная функция для отображения меню
function imgui.OnDrawFrame()
    imgui.DarkTheme() -- Применить темную тему

    -- Настройки меню с возможностью передвижения
    imgui.SetNextWindowPos(menuPosition, imgui.Cond.FirstUseEver)
    imgui.SetNextWindowSize(imgui.ImVec2(250, 150), imgui.Cond.FirstUseEver)

    -- Создание меню
    imgui.Begin('Меню с флаем', nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.MenuBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
    imgui.Text('Нажмите на кнопку для активации флая')
    
    -- Кнопка для активации/деактивации флая
    if imgui.Button(flyActive and 'Выключить флай' or 'Включить флай') then
        flyActive = not flyActive
    end

    imgui.Text('Текущий бинд: ' .. flyBindKey)

    if imgui.BeginDragDropSource() then
        local _, pos = imgui.GetMousePos()
        menuPosition = pos
        imgui.EndDragDropSource()
    end

    imgui.End()
end

-- Функция для проверки нажатия кнопки флая
function main()
    while true do
        wait(0)
        -- Проверка нажатия клавиши для активации флая
        if isKeyDown(flyBindKey) and not imgui.IsAnyItemActive() then
            flyActive = not flyActive
        end

        -- Логика флая
        if flyActive then
            -- Ваш код для передвижения персонажа
        end

        -- Отображение меню
        imgui.Process = showMenu.v
    end
end

-- Функция для управления состоянием меню с клавиши
function onKeyPress(key)
    if key == vkeys.VK_INSERT then -- Клавиша для открытия меню
        showMenu.v = not showMenu.v
    end
end

-- Регистрация события
imgui.HookEvents('onKeyPress', onKeyPress)
