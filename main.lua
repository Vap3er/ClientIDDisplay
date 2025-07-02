-- Created for support tickets
-- Created with AI

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "HWIDDisplay"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.ZIndex = -1
shadow.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Position = UDim2.new(0, 0, 0, 15)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamSemibold
title.Text = "Your HWID is:"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Parent = mainFrame

local hwidBox = Instance.new("Frame")
hwidBox.Name = "HWIDBox"
hwidBox.Position = UDim2.new(0.1, 0, 0.3, 0)
hwidBox.Size = UDim2.new(0.8, 0, 0, 40)
hwidBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
hwidBox.BorderSizePixel = 0
hwidBox.Parent = mainFrame

local hwidCorner = Instance.new("UICorner")
hwidCorner.CornerRadius = UDim.new(0, 8)
hwidCorner.Parent = hwidBox

local hwidText = Instance.new("TextLabel")
hwidText.Name = "HWIDText"
hwidText.Size = UDim2.new(0.9, 0, 0.8, 0)
hwidText.Position = UDim2.new(0.05, 0, 0.1, 0)
hwidText.BackgroundTransparency = 1
hwidText.Font = Enum.Font.Gotham
hwidText.Text = "Loading..."
hwidText.TextColor3 = Color3.fromRGB(200, 200, 200)
hwidText.TextSize = 14
hwidText.TextXAlignment = Enum.TextXAlignment.Left
hwidText.TextTruncate = Enum.TextTruncate.AtEnd
hwidText.Parent = hwidBox

local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Position = UDim2.new(0.25, 0, 0.65, 0)
copyButton.Size = UDim2.new(0.5, 0, 0, 40)
copyButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
copyButton.BorderSizePixel = 0
copyButton.Font = Enum.Font.GothamSemibold
copyButton.Text = "COPY HWID"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 16
copyButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = copyButton

copyButton.MouseEnter:Connect(function()
    TweenService:Create(copyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(90, 140, 220)
    }):Play()
end)

copyButton.MouseLeave:Connect(function()
    TweenService:Create(copyButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    }):Play()
end)

copyButton.MouseButton1Down:Connect(function()
    TweenService:Create(copyButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(50, 100, 180)
    }):Play()
end)

copyButton.MouseButton1Up:Connect(function()
    TweenService:Create(copyButton, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(90, 140, 220)
    }):Play()
end)

local function getHWID()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end

copyButton.Activated:Connect(function()
    local hwid = hwidText.Text
    if hwid and hwid ~= "Loading..." then
        setclipboard(hwid)
        
        local notif = Instance.new("TextLabel")
        notif.Text = "Copied to clipboard!"
        notif.Size = UDim2.new(0.6, 0, 0, 30)
        notif.Position = UDim2.new(0.2, 0, 0.85, 0)
        notif.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.Font = Enum.Font.Gotham
        notif.TextSize = 14
        notif.Parent = mainFrame
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notif
        
        delay(2, function()
            notif:Destroy()
        end)
    end
end)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function updateSize()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    if viewportSize.Y < 600 then 
        mainFrame.Size = UDim2.new(0, viewportSize.X * 0.8, 0, 180)
        hwidBox.Size = UDim2.new(0.8, 0, 0, 35)
        copyButton.Size = UDim2.new(0.5, 0, 0, 35)
        title.TextSize = 18
        hwidText.TextSize = 13
        copyButton.TextSize = 14
    else -- Desktop
        mainFrame.Size = UDim2.new(0, 300, 0, 200)
        hwidBox.Size = UDim2.new(0.8, 0, 0, 40)
        copyButton.Size = UDim2.new(0.5, 0, 0, 40)
        title.TextSize = 20
        hwidText.TextSize = 14
        copyButton.TextSize = 16
    end
end

updateSize()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateSize)

local hwid = getHWID()
hwidText.Text = hwid
