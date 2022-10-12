repeat task.wait() until game:IsLoaded()

local function ensureTycoonLoaded()
	while true and task.wait() do
		if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerData", true) then
			break
		end
	end
end
ensureTycoonLoaded()


local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow = Orion:MakeWindow({Name = "Mini Miners Menu", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab1 = Window:MakeTab({
	Name = "Miners Haven",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})