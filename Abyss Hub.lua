-- Простейший GUI тест
local screen = Instance.new("ScreenGui")
screen.Name = "TestGUI"
screen.Parent = gethui and gethui() or game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.Parent = screen

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 100, 0, 40)
button.Position = UDim2.new(0.5, -50, 0.5, -20)
button.Text = "Click"
button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
button.Parent = frame

button.MouseButton1Click:Connect(function()
    print("Button clicked!")
end)

print("Simple GUI created")
