repeat task.wait() until game:IsLoaded()

getgenv().autoCandy = false
getgenv().autoLoadSetLayout = false
getgenv().autoRebirth = false
getgenv().autoQuest = false
getgenv().autoCrates = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local mainRemoteFunction = ReplicatedStorage.Modules.Communicator.RemoteFunction
local mainRemoteEvent = ReplicatedStorage.Modules.Communicator.RemoteEvent

--// Main
local function ensureTycoonLoaded()
	while true and task.wait() do
		if localPlayer:FindFirstChild("Loaded") and localPlayer:FindFirstChild("ClientLoaded") then
			break
		end
	end
end
ensureTycoonLoaded()

local function getBase()
	local baseOwned = localPlayer:FindFirstChild("BaseOwned")
	if not baseOwned then
		return
	end

	return baseOwned.Value
end

local function getLayoutItems()
	local base = getBase()
	if not base then
		return
	end

	return base.Items:GetChildren()
end


local setLayoutData = {}
local function setCurrentLayout()
	table.clear(setLayoutData)

	setLayoutData.Items = {}
	setLayoutData.CFrames = {}

	local items = getLayoutItems()

	for _, item in items do
		table.insert(setLayoutData.Items, {item.Name})
		table.insert(setLayoutData.CFrames, item:GetPrimaryPartCFrame())
	end
end

local function loadSetLayout()
	mainRemoteFunction:InvokeServer("Placement", "placeItem", setLayoutData.Items, setLayoutData.CFrames)
end

local function withdrawCurrentLayout()
	mainRemoteFunction:InvokeServer("Placement", "withdrawItem", getLayoutItems())
end

local function rebirth()
	mainRemoteFunction:InvokeServer("Reincarnate")
end

local function clearOre()
	mainRemoteFunction:InvokeServer("Misc", "clearAllOres")
end

local function completeQuest(questID)
	mainRemoteFunction:InvokeServer("HalloweenQuest", "ClaimRewards", tostring(questID))
end

local function setFrameVisible(frame, visible)
	if visible then
		frame.Visible = true
		frame.Position = UDim2.new(0.5, 1, 0.5, 1)
	else
		frame.Visible = false
	end
end

local function isFrameVisible(frame)
	if frame.Visible then
		return true
	end
	return false
end

local function candyAutofarm()
	while autoCandy and task.wait() do
		if not autoCandy then break end

		local candyFolder = workspace.Dump:FindFirstChild("Candy")

		for _, candy in candyFolder:GetChildren() do
			local primary = candy.PrimaryPart
			if primary then
				primary.Transparency = 1
				primary.Position = localPlayer.Character.HumanoidRootPart.Position
				task.delay(5, function()
					candy:Destroy()
				end)
			end
			task.wait(0.6)
		end
	end
end

local function crateAutoFarm()
	while autoCrates and task.wait() do
		if not autoCrates then break end

		local crateFolder = workspace.Game.Crates

		for _, crate in crateFolder:GetChildren() do
			crate.CanCollide = false
			crate.Transparency = 1

			local tween = TweenService:Create(crate, TweenInfo.new(0, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0), {Position = localPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 12, 0)})
			tween:Play()
			tween.Completed:Connect(function()
				crate.CanCollide = true
			end)
			task.wait(0.8)

			task.delay(20, function()
				crate:Destroy()
			end)
		end
	end
end

local function questAutofarm()
	while autoQuest and task.wait(10) do
		if not autoQuest then break end

		local questData = mainRemoteFunction:InvokeServer("HalloweenQuest", "Get")
		for questID, data in questData do
			for name, has in data.Progress do
				if has >= data.Reqs[name] then
					completeQuest(questID)
				end
			end
		end
	end
end

local debounce = false
localPlayer.SaveStats.RealLife.Changed:Connect(function()
    if not debounce then
        debounce = true
        wait(0.1)
        if autoLoadSetLayout then
            local loaded = false
            while loaded ~= true do
                if #getLayoutItems() <= 0 then
                	loadSetLayout()
                elseif #getLayoutItems() > 1 then
                    loaded = true
                end
                wait(0.3)
            end
        end
        debounce = false
    end
end)

localPlayer.SaveStats.RealMoney.Changed:Connect(function()
	if autoRebirth then
		if tonumber(localPlayer.SaveStats.RealMoney.Value) >= tonumber(localPlayer.SaveStats.LifeStart.Value) * 2 then
			rebirth()
		end
	end
end)

localPlayer.Idled:connect(function()
   VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
   wait(1)
   VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

--// UI
local Orion = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local MainWindow = Orion:MakeWindow({
	Name = "MA:X by Rusty#9462",
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

local LayoutTab = MainWindow:MakeTab({
	Name = "Layout",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local NpcTab = MainWindow:MakeTab({
	Name = "Npc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

LayoutTab:AddLabel("- Layout Setup")
LayoutTab:AddButton({
	Name = "Set Layout",
	Callback = function()
		setCurrentLayout()
  	end
})

LayoutTab:AddLabel("- Main")
LayoutTab:AddButton({
	Name = "Rebirth",
	Callback = function()
		rebirth()
  	end
})

LayoutTab:AddButton({
	Name = "Load Layout",
	Callback = function()
		loadSetLayout()
  	end
})

LayoutTab:AddButton({
	Name = "Withdraw Current Layout",
	Callback = function()
		withdrawCurrentLayout()
  	end
})

LayoutTab:AddButton({
	Name = "Clear All Ore",
	Callback = function()
		clearOre()
  	end
})

AutoTab:AddLabel("- Default")
AutoTab:AddToggle({
	Name = "Auto Rebirth",
	Default = false,
	Callback = function(value)
		autoRebirth = value
		if value then
			rebirth()
		end
	end
})

AutoTab:AddToggle({
	Name = "Auto Load Layout",
	Default = false,
	Callback = function(value)
		autoLoadSetLayout = value
		if value then
			task.wait(0.75)
			loadSetLayout()
		end
	end
})

AutoTab:AddToggle({
	Name = "Crate Autofarm",
	Default = false,
	Callback = function(value)
		autoCrates = value
		crateAutoFarm()
	end
})

AutoTab:AddLabel("- Event")
AutoTab:AddToggle({
	Name = "Candy Autofarm",
	Default = false,
	Callback = function(value)
		autoCandy = value
		candyAutofarm()
	end
})

AutoTab:AddToggle({
	Name = "Quest Autofarm",
	Default = false,
	Callback = function(value)
		autoQuest = value
		questAutofarm()
	end
})

NpcTab:AddLabel("- Default")
NpcTab:AddButton({
	Name = "Merchant",
	Callback = function()
		setFrameVisible(playerGui.Interface.Overlays.Merchant,
			not isFrameVisible(playerGui.Interface.Overlays.Merchant)
		)
  	end
})
NpcTab:AddButton({
	Name = "Crafting",
	Callback = function()
		setFrameVisible(playerGui.Interface.Overlays.Crafting,
			not isFrameVisible(playerGui.Interface.Overlays.Crafting)
		)
  	end
})
NpcTab:AddButton({
	Name = "Leaderboards",
	Callback = function()
		setFrameVisible(playerGui.Interface.Overlays.Leaderboards,
			not isFrameVisible(playerGui.Interface.Overlays.Leaderboards)
		)
  	end
})
NpcTab:AddButton({
	Name = "Prestige",
	Callback = function()
		setFrameVisible(playerGui.Interface.Overlays.Prestige,
			not isFrameVisible(playerGui.Interface.Overlays.Prestige)
		)
  	end
})
NpcTab:AddButton({
	Name = "Prestige Reroll",
	Callback = function()
		setFrameVisible(playerGui.Interface.Overlays.Reroll,
			not isFrameVisible(playerGui.Interface.Overlays.Reroll)
		)
  	end
})

NpcTab:AddLabel("- Event")
NpcTab:AddButton({
	Name = "Halloween",
	Callback = function()
		setFrameVisible(playerGui.Interface.Overlays.Halloween,
			not isFrameVisible(playerGui.Interface.Overlays.Halloween)
		)
  	end
})

Orion:Init()