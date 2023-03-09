getgenv().autofarm = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local betterTp = loadstring(game:HttpGet(("https://raw.githubusercontent.com/NilRusty/PublicScripts/main/Util/BetterTp.lua")))()

local localPlayer = Players.LocalPlayer
local entityPath = workspace.RENDER.ENTITIES

local currentTarget = nil
local doneTp = false

local function tp(cframe)
	betterTp(cframe)

	task.spawn(function()
		while task.wait() do
			if localPlayer.Character.HumanoidRootPart.CFrame == cframe then
				break
			end
		end
	end)
end

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
				tp(currentTarget.PrimaryPart.CFrame)
				doneTp = true
			else
				
			end
		end
	end
end)