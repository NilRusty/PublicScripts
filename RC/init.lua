repeat task.wait() until game:IsLoaded()

local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character.HumanoidRootPart

local itemNames = {}
local itemsThatCanSpawn = {}

local function getHouse()
	local house = nil

	for _, plot in workspace.Property.Plots:GetChildren() do
		local owner = plot:FindFirstChild("Owner", true)
		if owner then
			if owner.Value == localPlayer.Name then
				house = owner.Parent
			end
		end
	end

	return house
end

local function getItems()
	for _, item in ReplicatedStorage.Furniture:GetChildren() do
		if item.ColorOptions then
			for _, color in item.ColorOptions:GetChildren() do
				local name = item.Name .. " | " .. color.Name
				table.insert(itemNames, name)
				itemsThatCanSpawn[name] = {
					Name = item.Name,
					Color = color.Name,
					Serial = item.Id.Value
				}
			end
		end
	end
end
getItems()

local function isPlayerNearHouse()
	local house = getHouse()
	if not house then
		return
	end

	local nearHouse = false

	local basePos = house.Base.Position
	local humPos = humanoidRootPart.Position

	local distance = (humPos - basePos).Magnitude
	local radius = 35

	if distance <= radius then
		nearHouse = true
	else
		nearHouse = false
	end

	return nearHouse
end

local function spawnItem(itemToSpawn)
	local house = getHouse()
	if not house then
		return
	end

	if isPlayerNearHouse() then
		local data = itemsThatCanSpawn[itemToSpawn]

		local itemData = {
			["Color"] = data.Color,
			["House"] = house,
			["Serial"] = data.Serial,
			["Name"] = data.Name
		}

		local cframeFromHouse = humanoidRootPart.CFrame:toObjectSpace(house.Base.CFrame) + Vector3.new(humanoidRootPart.CFrame.lookVector)
		local x1, y1, z1, m11, m12, m13, m21, m22, m23, m31, m32, m33 = cframeFromHouse:components()

		local yes = {x1, y1, z1, m11, m12, m13, m21, m22, m23, m31, m32, m33}

		ReplicatedStorage.Relays.House.PlaceFurniture:InvokeServer(itemData, CFrame.new(table.unpack(yes)))
	else
			Orion:MakeNotification({
				Name = "Warning",
				Content = "Must be in house to spawn items",
				Image = "rbxassetid://4483345998",
				Time = 2.5
			})
	end
end

local MainWindow = Orion:MakeWindow({
	Name = "Item Spawner by Rusty#9462",
	HidePremium = true,
	SaveConfig = true,
	ConfigFolder = "OrionConfig",
	IntroEnabled = false,
})

local SpawnerTab = MainWindow:MakeTab({
	Name = "Spawner",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local dropDown = SpawnerTab:AddDropdown({
	Name = "Items to spawn",
	Options = itemNames,
	Callback = function(itemToSpawn)
		spawnItem(itemToSpawn)
	end
})

Orion:Init()