local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotSpawnerGUI"
gui.Parent = game:GetService("CoreGui")
gui.Enabled = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 500)
frame.Position = UDim2.new(0.5, -150, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", frame)
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Lokacija za spawn (možeš promeniti)
local spawnPos = Vector3.new(0, 5, 0)

-- Pronađi sve brainrotove u ReplicatedStorage i Workspace
local brainrotList = {}

local function searchForBrainrots(parent)
	for _, child in pairs(parent:GetChildren()) do
		if child:IsA("Model") or child:IsA("Folder") then
			if child.Name:lower():find("brainrot") then
				table.insert(brainrotList, child.Name)
			end
			-- rekurzivno traži dalje
			searchForBrainrots(child)
		end
	end
end

searchForBrainrots(ReplicatedStorage)
searchForBrainrots(Workspace)

-- Ako nema brainrotova, javi
if #brainrotList == 0 then
	local noLabel = Instance.new("TextLabel", frame)
	noLabel.Size = UDim2.new(1, -20, 0, 40)
	noLabel.Text = "Nema pronađenih brainrotova!"
	noLabel.TextColor3 = Color3.new(1, 0, 0)
	noLabel.BackgroundTransparency = 1
	noLabel.Font = Enum.Font.GothamBold
	noLabel.TextSize = 18
	noLabel.TextStrokeTransparency = 0.7
else
	-- Pravimo dugmad za svaki brainrot
	for _, brainrotName in ipairs(brainrotList) do
		local btn = Instance.new("TextButton", frame)
		btn.Size = UDim2.new(1, -20, 0, 40)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 16
		btn.Text = brainrotName
		btn.MouseButton1Click:Connect(function()
			local remote = ReplicatedStorage:FindFirstChild("SpawnBrainrot") -- promeni ako treba
			if remote and remote:IsA("RemoteEvent") then
				remote:FireServer(brainrotName, spawnPos)
				print("Spawnujem brainrot: " .. brainrotName)
			else
				warn("RemoteEvent za spawn nije pronađen!")
			end
		end)
	end
end

UIS.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.G then
		gui.Enabled = not gui.Enabled
	end
end)
