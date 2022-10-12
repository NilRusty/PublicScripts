repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")

local playerWalkspeed = Instance.new("IntValue")
playerWalkspeed.Value = 16

--// Main
local function ensureTycoonLoaded()
	while true and task.wait() do
		if Players.LocalPlayer:FindFirstChild("PlayerData", true) then
			break
		end
	end
end
ensureTycoonLoaded()

local function clearConnections(connections)
	for _, v in connections do
		v:Disconnect()
	end
end

local function observePlayerSpeed()
	local currentConnections = {}
	local addedConnections = {}

	local character = Players.LocalPlayer.Character
	local humanoid = character.Humanoid

	humanoid.WalkSpeed = playerWalkspeed.Value
	currentConnections["speedValueChanged"] = playerWalkspeed.Changed:Connect(function(newValue)
		humanoid.WalkSpeed = newValue
	end)

	currentConnections["humanoidSpeedChanged"] = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		humanoid.WalkSpeed = playerWalkspeed.Value
	end)

	addedConnections["characterAdded"] = Players.LocalPlayer.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")

		humanoid.WalkSpeed = playerWalkspeed.Value
		addedConnections["speedValueChanged"] = playerWalkspeed.Changed:Connect(function(newValue)
			humanoid.WalkSpeed = newValue
		end)

		addedConnections["humanoidSpeedChanged"] = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			humanoid.WalkSpeed = playerWalkspeed.Value
		end)
	end)

	return currentConnections, addedConnections
end

--// UI
local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow = Orion:MakeWindow({
	Name = "Mini Miners Menu by Rusty#9462",
	HidePremium = true,
	SaveConfig = true,
	ConfigFolder = "OrionConfig",
	IntroEnabled = false,
})

local AutoTab = MainWindow:MakeTab({
	Name = "Auto",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local NpcTab = MainWindow:MakeTab({
	Name = "NPC",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local CharacterTab = MainWindow:MakeTab({
	Name = "Character",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

CharacterTab:AddTextbox({
	Name = "Player Speed",
	Default = "16",
	Callback = function(value)
		playerWalkspeed.Value = value
	end
})

local connections1, connections2 = nil
CharacterTab:AddToggle({
    Name = "Toggle Speed",
    Default = true,
    Callback = function(value)
    	if value then
    		connections1, connections2 = observePlayerSpeed()
    	else
    		clearConnections(connections1)
    		clearConnections(connections2)
    		playerWalkspeed.Value = 16
    	end
    end
})

Orion:Init()