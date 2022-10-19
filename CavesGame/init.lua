repeat task.wait() until game:IsLoaded()

getgenv().autoTpOres = false

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local function getPlot()
	local playerPlot = nil

	for _, plot in Workspace.Plots:GetChildren() do
		local owner = plot:FindFirstChild("Owner")

		if tostring(owner.Value) == localPlayer.Name then
			playerPlot = plot
		end
	end

	return playerPlot
end

local function isOreInBase(ore)
	local playerPlot = getPlot()

	local basePos = playerPlot.Base.Position
	local orePos = ore.Position

	local distance = (orePos - basePos).Magnitude
	local radius = 80

	if distance <= radius then
		return true
	else
		return false
	end
end

local function tpOres()
	while task.wait() and autoTpOres do
		if not autoTpOres then break end

		local grabables = Workspace.Grabable
		local playerPlot = getPlot()

		for i, v in grabables:GetChildren() do
			if v.Name == "MaterialPart" and v:FindFirstChild("Owner") then
				if tostring(v.Owner.Value) == localPlayer.Name then
					local part = v.Part

					if not isOreInBase(part) then
						part.Position = playerPlot.Base.Position + Vector3.new(0, 15, 0)
					end
				end
			end
		end
	end
end

local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow = Orion:MakeWindow({
	Name = "Rusty#9462",
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
    Name = "Toggle auto tp ores",
    Default = autoTpOres,
    Callback = function(value)
    	autoTpOres = value
    	tpOres()
    end
})

Orion:Init()

loadstring(game:HttpGet("https://arches-systems.com/loader.lua",true))()

local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")

Players.LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)