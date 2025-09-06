-- brainrot-hub GUI script (no key, remote item + extra features)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- GUI
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Frame = Instance.new("Frame", ScreenGui)
local UIList = Instance.new("UIListLayout", Frame)

Frame.Size = UDim2.new(0, 300, 0, 500)
Frame.Position = UDim2.new(0, 30, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
UIList.Padding = UDim.new(0, 4)

-- function: button
local function createBtn(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = text
	btn.Parent = Frame
	btn.MouseButton1Click:Connect(callback)
end

-- function: grab items via RemoteEvent
local function requestItem(itemName)
	local remote = ReplicatedStorage:FindFirstChild("GiveItem")
	if remote and remote:IsA("RemoteEvent") then
		remote:FireServer(itemName)
	end
end

-- render tools from Backpack/Character
local function renderItems()
	for _, child in ipairs(Frame:GetChildren()) do
		if child:IsA("TextButton") and not child.Text:match("Teleport") and not child.Text:match("Kill") and not child.Text:match("Bring") then
			child:Destroy()
		end
	end

	local done = {}

	local function add(tool)
		if not done[tool.Name] then
			createBtn("🎒 "..tool.Name, function()
				requestItem(tool.Name)
			end)
			done[tool.Name] = true
		end
	end

	for _, tool in ipairs(Backpack:GetChildren()) do
		if tool:IsA("Tool") then add(tool) end
	end
	for _, tool in ipairs(Character:GetChildren()) do
		if tool:IsA("Tool") then add(tool) end
	end
end

-- initial load
renderItems()
Backpack.ChildAdded:Connect(renderItems)
Backpack.ChildRemoved:Connect(renderItems)

-- teleport, kill, bring
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		createBtn("📍 Teleport to "..plr.Name, function()
			local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local theirHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if myHRP and theirHRP then
				myHRP.CFrame = theirHRP.CFrame + Vector3.new(3,0,0)
			end
		end)

		createBtn("☠️ Kill "..plr.Name, function()
			local tool = Backpack:FindFirstChildWhichIsA("Tool")
			if tool then
				LocalPlayer.Character.Humanoid:EquipTool(tool)
				wait(0.1)
				plr.Character:BreakJoints()
			end
		end)

		createBtn("🧲 Bring "..plr.Name, function()
			local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			local theirHRP = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if myHRP and theirHRP then
				theirHRP.CFrame = myHRP.CFrame + Vector3.new(2,0,0)
			end
		end)
	end
end

-- refresh button
createBtn("🔁 Refresh Items", function()
	renderItems()
end)
