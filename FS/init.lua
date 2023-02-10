--// Fishing Simulator
--// Fuck you for reporting me dickrider
--// By Rusty#9462

getgenv().autoFarmFish = false
getgenv().autoFarmFishSpeed = 1000

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character

local function isRodEquipped()
	for _, v in character:GetChildren() do
		if string.match(v.Name, "rod") then
			return true
		end
	end

	return false
end

local function tp(cframe)
	character:SetPrimaryPartCFrame(cframe)
end

local function sell()
	ReplicatedStorage.CloudFrameShared.DataStreams.processGameItemSold:InvokeServer("SellEverything")
end

local function fish()
	ReplicatedStorage.CloudFrameShared.DataStreams.FishBiting:InvokeServer()
	ReplicatedStorage.CloudFrameShared.DataStreams.FishCaught:FireServer()
end

local function autoFish()
	local connection = nil

	connection = RunService.RenderStepped:Connect(function()
		if not autoFarmFish then
			connection:Disconnect()
		end

		task.spawn(function()
			for i = 0, autoFarmFishSpeed, 1 do
				if not autoFarmFish then
					break
				end

				fish()
				sell()
			end
		end)
	end)
end

task.spawn(function()
	local connection = nil
	connection = RunService.RenderStepped:Connect(function()
		if not autofarm then
			connection:Disconnect()
		end

		task.spawn(function()
			for i = 0, autoFarmFishSpeed, 1 do
				if not autofarm then
					break
				end

				fish()
				sell()
			end
		end)
	end)
end)

--// UI
local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow = Orion:MakeWindow({
	Name = "Fish sucking sim by Rusty#9462",
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

local TpTab = MainWindow:MakeTab({
	Name = "Tp",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local ExtraTab = MainWindow:MakeTab({
	Name = "Extra",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

ExtraTab:AddLabel("- Preformance")
ExtraTab:AddButton({
	Name = "Disable effects",
	Callback = function()
		task.spawn(function()
			while task.wait(0.1) do
				for _, v in Workspace:GetDescendants() do
					if v:IsA("ParticleEmitter") then
						v:Destroy()
					end
				end
			end
		end)
	end
})
ExtraTab:AddButton({
	Name = "Low shaders mode",
	Callback = function()

	end
})

TpTab:AddLabel("- Islands")
for _, v in Workspace:FindFirstChild("Islands"):GetChildren() do
	TpTab:AddButton({
		Name = v.Name,
		Callback = function()
			tp(v:FindFirstChild("FastTravel", true).TeleportTo.CFrame)
		end
	})
end

AutoTab:AddLabel("- Fishing")
AutoTab:AddToggle({
	Name = "Auto fish (will lag)",
	Callback = function(value)
		if value then
			if not isRodEquipped() then
				Orion:MakeNotification({
					Name = "Warning",
					Content = "Must have rod equipped! Do not unequip while active.",
					Image = "rbxassetid://4483345998",
					Time = 2.5
				})
				return
			end
			task.wait(0.25)
			autoFish()
		end
		autoFarmFish = value
  	end
})

Orion:Init()