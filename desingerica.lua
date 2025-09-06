local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Ovo je folder/model u Workspace koji je tvoja baza
local mojaBaza = Workspace:FindFirstChild("MojaBaza") -- promeni ako se zove drugačije
if not mojaBaza then
    mojaBaza = Instance.new("Folder", Workspace)
    mojaBaza.Name = "MojaBaza"
end

local brainrotNames = {
    "Noobini Pizzanini", "Lirili Larila", "Tim Cheese", "Flurifura", "Talpa Di Fero", "Svinina Bombardino", "Pipi Kiwi", "Racooni Jandelini", "Pipi Corni",
    "Trippi Troppi", "Tung Tung Tung Sahur", "Gangster Footera", "Bandito Bobritto", "Boneca Ambalabu", "Cacto Hipopotamo", "Ta Ta Ta Ta Sahur", "Tric Trac Baraboom", "Pipi Avocado",
    "Cappuccino Assassino", "Brr Brr Patapim", "Trulimero Trulicina", "Bambini Crostini", "Bananita Dolphinita", "Perochello Lemonchello", "Brri Brri Bicus Dicus Bombicus", "Avocadini Guffo", "Salamino Penguino",
    "Pipi Corni", "Pi Pi Watermelon",
    "Ganganzelli Trulala", "Tob Tobi Tobi",
    "Tukanno Bananno",
    "Nuclearo Dinossauro", "Los Tralaleritos"
}

local gui = Instance.new("ScreenGui")
gui.Name = "BrainrotSpawnerGUI"
gui.Parent = game:GetService("CoreGui")
gui.Enabled = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0.5, -175, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout", frame)
UIList.Padding = UDim.new(0, 6)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

local function isBrainrot(obj)
    for _, name in ipairs(brainrotNames) do
        if obj.Name:lower():find(name:lower()) then
            return true
        end
    end
    return false
end

local function createButton(item)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = item.Name
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        if item then
            local clone = item:Clone()
            clone.Parent = mojaBaza
            if clone.PrimaryPart then
                -- Spawni klon na neko mesto u tvojoj bazi (možeš menjati poziciju)
                clone:SetPrimaryPartCFrame(CFrame.new(0, 5, 0))
            end
        else
            warn("Item ne postoji ili ne može da se klonira.")
        end
    end)
end

local function scanForBrainrots()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if isBrainrot(obj) then
            createButton(obj)
        end
    end

    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if isBrainrot(obj) then
            createButton(obj)
        end
    end
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.G then
        gui.Enabled = not gui.Enabled
        if gui.Enabled then
            scanForBrainrots()
        else
            -- Očisti dugmad kad zatvoriš GUI
            for _, child in pairs(frame:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
        end
    end
end)
