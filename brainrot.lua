local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotSpawnerGUI"
gui.Parent = game:GetService("CoreGui")
gui.Enabled = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0.5, -175, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.ClipsDescendants = true

local UIList = Instance.new("UIListLayout", frame)
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- Pozicija gde spawnujemo brainrot
local spawnPosition = Vector3.new(0, 5, 0) -- prilagodi po potrebi

-- Funkcija za pravljenje dugmeta
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Text = text
	btn.Parent = frame
	btn.MouseButton1Click:Connect(callback)
end

-- Pronađi sve brainrotove u ReplicatedStorage (naziv sadrži "Brainrot")
local brainrotItems = {}

for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
	if (obj:IsA("Tool") or obj:IsA("RemoteEvent")) and string.find(obj.Name:lower(), "brainrot") then
		table.insert(brainrotItems, obj)
	end
end

-- Ako nema ni jednog, upozori
if #brainrotItems == 0 then
	createButton("Nema Brainrot itema u ReplicatedStorage!", function() end)
else
	for _, item in ipairs(brainrotItems) do
		if item:IsA("Tool") then
			createButton("Spawn Tool: " .. item.Name, function()
				-- pokušaj da dobijemo RemoteEvent sa istim imenom
				local remote = ReplicatedStorage:FindFirstChild(item.Name)
				if remote and remote:IsA("RemoteEvent") then
					remote:FireServer(spawnPosition)
					print("Spawnujem tool preko RemoteEvent:", item.Name)
				else
					warn("Nema RemoteEvent za tool: " .. item.Name)
				end
			end)
		elseif item:IsA("RemoteEvent") then
			createButton("Fire RemoteEvent: " .. item.Name, function()
				item:FireServer("Brainrot", spawnPosition)
				print("Poslat zahtev za spawn:", item.Name)
			end)
		end
	end
end

-- Toggle GUI sa tasterom G
UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
		gui.Enabled = not gui.Enabled
	end
end)
