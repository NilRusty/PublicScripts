--// Shitty case game
--// By Rusty#9462

getgenv().autoFarm = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local BEST_CASE = "breakout_case"

local openCase = ReplicatedStorage.Remotes.OpenCase
local settings = ReplicatedStorage.Remotes.SettingsEvent
local buy = ReplicatedStorage.Remotes.BuyBulk

local function autoFarmCrate()
	while autoFarm and task.wait() do
		if not autoFarm then break end

		openCase:InvokeServer(BEST_CASE, 3)
		task.delay(1, function()
			settings:FireServer("SellSkins")
			settings:FireServer("SellSkinsRed")
			buy:FireServer(BEST_CASE, 5)
		end)
	end
end

--// AnitAfk
loadstring(game:HttpGet(('https://raw.githubusercontent.com/NilRusty/PublicScripts/main/Util/AntiAfk.lua')))()

--// UI
local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow = Orion:MakeWindow({
	Name = "reroll.pp by Rusty#9462",
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

AutoTab:AddToggle({
	Name = "Autofarm";
	Callback = function(value)
		autoFarm = value
		autoFarmCrate()
	end
})

Orion:Init()