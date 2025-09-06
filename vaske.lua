local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- GUI setup
local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotGUI"
gui.Parent = game:GetService("CoreGui")
gui.Enabled = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -20, 0, 50)
btn.Position = UDim2.new(0, 10, 0, 25)
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btn.TextColor3 = Color3.new(1,1,1)
btn.Text = "🧠 Spawn Brainrot (undetected)"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16

-- Spawn logic
btn.MouseButton1Click:Connect(function()
	local remoteNames = {"GiveItem", "SpawnBrainrot", "BrainrotRemote"}
	for _, name in ipairs(remoteNames) do
		local remote = ReplicatedStorage:FindFirstChild(name)
		if remote and remote:IsA("RemoteEvent") then
			remote:FireServer("Brainrot")
			warn("✅ Sent request to: " .. name)
			break
		end
	end
end)

-- Toggle GUI with G key
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.G then
		gui.Enabled = not gui.Enabled
	end
end)
