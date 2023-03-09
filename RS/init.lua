getgenv().autofarm = true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local betterTp = loadstring(game:HttpGet(("https://raw.githubusercontent.com/NilRusty/PublicScripts/main/Util/BetterTp.lua")))()

local localPlayer = Players.LocalPlayer
local entityPath = workspace.RENDER.ENTITIES

local currentTarget = nil
local doneTp = false

task.spawn(function()
	while autofarm and task.wait() do
		if currentTarget and not currentTarget.Parent then
			currentTarget = nil
			doneTp = false
		end

		for _, v in entityPath:GetChildren() do
			if currentTarget then
				continue
			end

			if v.PrimaryPart and v.Parent then
				currentTarget = v
			end
		end

		if currentTarget then
			if not doneTp then
				betterTp(currentTarget.PrimaryPart.CFrame, 200)
				doneTp = true
			else
				game:GetService("ReplicatedStorage").Packages._Index["sleitnick_knit@1.1.0-rc.1"].knit.Services.PetsService.__comm__.RE.SwordAttack:FireServer("Enemy", currentTarget.Name)
			end
		end
	end
end)