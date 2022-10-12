repeat task.wait() until game:IsLoaded()

local function ensureTycoonLoaded()
	while true and task.wait() do
		print("Loading")
		if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerData", true) then
			break
		end
	end
end
ensureTycoonLoaded()