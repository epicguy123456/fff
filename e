--[[ 
Eco Hub - Versión reducida a 2 pestañas (Main y Teleports),
manteniendo el estilo original, imagen, gradiente, Discord y cursor message.
]]

---------------------------
-- Servicios y variables
---------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

---------------------------
-- Crear ScreenGui principal (EcoHub)
---------------------------
local ScreenGui_Main = Instance.new("ScreenGui")
ScreenGui_Main.Name = "EcoHubUI"
ScreenGui_Main.ResetOnSpawn = false
ScreenGui_Main.Parent = PlayerGui

---------------------------
-- Marco principal con estilo EcoHub
---------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 540)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui_Main

local MainFrameCorner = Instance.new("UICorner")
MainFrameCorner.CornerRadius = UDim.new(0, 12)
MainFrameCorner.Parent = MainFrame

local MainFrameGradient = Instance.new("UIGradient")
MainFrameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(50,50,50))
})
MainFrameGradient.Rotation = 90
MainFrameGradient.Parent = MainFrame

---------------------------
-- Logo EcoHub
---------------------------
local Logo = Instance.new("ImageLabel")
Logo.Name = "Logo"
Logo.Size = UDim2.new(0, 80, 0, 80)
Logo.Position = UDim2.new(0, 15, 0, 10)
Logo.BackgroundTransparency = 1
-- Puedes reemplazar este assetID por el tuyo si gustas
Logo.Image = "rbxassetid://100155304367901"
Logo.Parent = MainFrame

---------------------------
-- Título
---------------------------
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -110, 0, 40)
TitleLabel.Position = UDim2.new(0, 100, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Eco Hub"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

---------------------------
-- Barra de pestañas
---------------------------
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(1, -20, 0, 40)
TabFrame.Position = UDim2.new(0, 10, 0, 100)
TabFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
TabFrame.BorderSizePixel = 0
TabFrame.Parent = MainFrame

local TabFrameCorner = Instance.new("UICorner")
TabFrameCorner.CornerRadius = UDim.new(0,8)
TabFrameCorner.Parent = TabFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = TabFrame

---------------------------
-- Función para crear botones de pestaña
---------------------------
local function createTabButton(name, text)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.5, -5, 1, 0) -- Dos pestañas (0.5 c/u)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = text
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = TabFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = btn
    return btn
end

---------------------------
-- Creamos solo 2 pestañas: Main y Teleports
---------------------------
local MainTabButton = createTabButton("MainTabButton", "Main")
local TeleportsTabButton = createTabButton("TeleportsTabButton", "Teleports")

---------------------------
-- Contenedores de cada pestaña
---------------------------
local function createContentFrame()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 1, -220)
    frame.Position = UDim2.new(0,10,0,160)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = frame

    return frame
end

local MainContent = createContentFrame()
MainContent.Name = "MainContent"
MainContent.Parent = MainFrame

local TeleportsContent = createContentFrame()
TeleportsContent.Name = "TeleportsContent"
TeleportsContent.Visible = false
TeleportsContent.Parent = MainFrame

-- Layouts internos
local MainLayoutContent = Instance.new("UIListLayout")
MainLayoutContent.Parent = MainContent
MainLayoutContent.SortOrder = Enum.SortOrder.LayoutOrder
MainLayoutContent.Padding = UDim.new(0,5)

local TeleportsLayout = Instance.new("UIListLayout")
TeleportsLayout.Parent = TeleportsContent
TeleportsLayout.SortOrder = Enum.SortOrder.LayoutOrder
TeleportsLayout.Padding = UDim.new(0,5)

---------------------------
-- Función auxiliar para crear botones dentro de cada pestaña
---------------------------
local function createActionButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = btn
    return btn
end

---------------------------
-- PESTAÑA MAIN
-- Botón: Unlock VIP
---------------------------
local UnlockVipBtn = createActionButton(MainContent, "Unlock VIP")
UnlockVipBtn.MouseButton1Click:Connect(function()
    -- Destruye el objeto Field en VIP
    game.Workspace.Map.VIP.Field:Destroy()
end)

---------------------------
-- PESTAÑA MAIN - NUEVA FUNCIÓN: Comprar Ítem
---------------------------
-- TextBox para ingresar el nombre del objeto (ahora muestra "Item Name")
local BuyItemTextBox = Instance.new("TextBox")
BuyItemTextBox.Size = UDim2.new(1, -10, 0, 40)
BuyItemTextBox.BackgroundColor3 = Color3.fromRGB(80,80,80)
BuyItemTextBox.Text = "Item Name"
BuyItemTextBox.TextColor3 = Color3.new(1,1,1)
BuyItemTextBox.TextScaled = true
BuyItemTextBox.Font = Enum.Font.Gotham
BuyItemTextBox.Parent = MainContent

local BuyItemTextBoxCorner = Instance.new("UICorner")
BuyItemTextBoxCorner.CornerRadius = UDim.new(0,6)
BuyItemTextBoxCorner.Parent = BuyItemTextBox

-- Botón: Buy Item
local BuyItemButton = Instance.new("TextButton")
BuyItemButton.Size = UDim2.new(1, -10, 0, 40)
BuyItemButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
BuyItemButton.Text = "Buy Item"
BuyItemButton.TextColor3 = Color3.new(1,1,1)
BuyItemButton.TextScaled = true
BuyItemButton.Font = Enum.Font.Gotham
BuyItemButton.Parent = MainContent

local BuyItemButtonCorner = Instance.new("UICorner")
BuyItemButtonCorner.CornerRadius = UDim.new(0,6)
BuyItemButtonCorner.Parent = BuyItemButton

BuyItemButton.MouseButton1Click:Connect(function()
    local itemName = BuyItemTextBox.Text
    game:GetService("ReplicatedStorage").RemoteEvents.BuyItemCash:FireServer(itemName)
end)

---------------------------
-- PESTAÑA TELEPORTS
-- Botón: Teleport to VIP
---------------------------
local TeleportVipBtn = createActionButton(TeleportsContent, "Teleport to VIP")
TeleportVipBtn.MouseButton1Click:Connect(function()
    local teleportPosition = Vector3.new(279.17, 18.05, -286.74)
    
    -- Cuando el personaje reaparezca, lo teletransportamos
    LocalPlayer.CharacterAdded:Connect(function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        humanoidRootPart.CFrame = CFrame.new(teleportPosition)
    end)

    -- Si el personaje ya está en el juego, lo teletransportamos de inmediato
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
    end
end)

---------------------------
-- Lógica de cambio de pestañas
---------------------------
local function showMain()
    MainContent.Visible = true
    TeleportsContent.Visible = false
    MainTabButton.BackgroundColor3 = Color3.fromRGB(60,120,60)
    TeleportsTabButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
end

local function showTeleports()
    MainContent.Visible = false
    TeleportsContent.Visible = true
    TeleportsTabButton.BackgroundColor3 = Color3.fromRGB(60,120,60)
    MainTabButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
end

MainTabButton.MouseButton1Click:Connect(showMain)
TeleportsTabButton.MouseButton1Click:Connect(showTeleports)

-- Iniciar mostrando Main
showMain()

---------------------------
-- Mensaje que sigue al cursor (cuando está fuera de la UI)
---------------------------
local CursorMessage = Instance.new("TextLabel")
CursorMessage.Name = "CursorMessage"
CursorMessage.Size = UDim2.new(0,150,0,30)
CursorMessage.BackgroundColor3 = Color3.new(0,0,0)
CursorMessage.BackgroundTransparency = 0.6
CursorMessage.Text = "Enjoy this script!"
CursorMessage.TextColor3 = Color3.new(1,1,1)
CursorMessage.TextScaled = true
CursorMessage.Font = Enum.Font.GothamBold
CursorMessage.Parent = ScreenGui_Main
CursorMessage.Visible = false

RunService.RenderStepped:Connect(function()
    local mousePos = UserInputService:GetMouseLocation()
    CursorMessage.Position = UDim2.new(0, mousePos.X + 20, 0, mousePos.Y)
    
    local framePos = MainFrame.AbsolutePosition
    local frameSize = MainFrame.AbsoluteSize
    if mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
       mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y then
        CursorMessage.Visible = false
    else
        CursorMessage.Visible = true
    end
end)

---------------------------
-- Botón de Discord (efecto arcoíris, copia enlace)
---------------------------
local DiscordButton = Instance.new("TextButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.Size = UDim2.new(0,400,0,40)
DiscordButton.Position = UDim2.new(0.5, -200, 1, -50)
DiscordButton.BackgroundColor3 = Color3.new(0,0,0)
DiscordButton.BackgroundTransparency = 0.4
DiscordButton.Text = "https://discord.gg/fjJjGCdP"
DiscordButton.TextScaled = true
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.Parent = MainFrame

local DiscordButtonCorner = Instance.new("UICorner")
DiscordButtonCorner.CornerRadius = UDim.new(0,6)
DiscordButtonCorner.Parent = DiscordButton

spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.001) % 1
        DiscordButton.TextColor3 = Color3.fromHSV(hue, 1, 1)
        task.wait(0.01)
    end
end)

DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/fjJjGCdP")
        DiscordButton.Text = "Copied!"
        task.wait(1)
        DiscordButton.Text = "https://discord.gg/fjJjGCdP"
    end
end)
