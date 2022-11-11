--// Mechanical Ascension X Autofarm
--// Work in progress!!!!
--// By Rusty#9462

getgenv().autoLoadLayout = false
getgenv().autoRebirth = false
getgenv().autoQuests = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local communicator = require(ReplicatedStorage.Modules.Communicator)

local function ensureTycoonLoaded()
	while true and task.wait() do
		if localPlayer:FindFirstChild("Loaded") and localPlayer:FindFirstChild("ClientLoaded") then
			task.wait(1)
			break
		end
	end
end
ensureTycoonLoaded()

local playerBase = localPlayer:FindFirstChild("BaseOwned").Value
local itemsFolder = playerBase.Items

--// Layouts without having to buy blueprints
local customLayoutData = {
	[1] = {Items={},ItemCFrames={}},
	[2] = {Items={},ItemCFrames={}},
	[3] = {Items={},ItemCFrames={}},
	[4] = {Items={},ItemCFrames={}},
	[5] = {Items={},ItemCFrames={}},
}
local layoutToLoad = 1

local function setLayoutData(id)
	local customLayout = customLayoutData[id]

	table.clear(customLayout.Items)
	table.clear(customLayout.ItemCFrames)

	for _, item in itemsFolder:GetChildren() do
		table.insert(customLayout.Items, {item.Name})
		table.insert(customLayout.ItemCFrames, item:GetPrimaryPartCFrame())
	end
end

local function getCurrentLayoutData()
	local currentLayout = customLayoutData[layoutToLoad]

	return currentLayout.Items, currentLayout.ItemCFrames
end

local function loadSetLayout()
	communicator.listenerFunction("Placement"):Invoke("placeItem", getCurrentLayoutData())
end

local function withdrawCurrentLayout()
	communicator.listenerFunction("Placement"):Invoke("withdrawItem", itemsFolder:GetChildren())
end

local function rebirth()
	communicator.listenerFunction("Reincarnate"):Invoke()
end

local function clearOre()
	communicator.listenerFunction("Misc"):Invoke("clearAllOres")
end

local function completeQuest(questID)
	communicator.listenerFunction("HalloweenQuest"):Invoke("ClaimRewards", tostring(questID))
end

local function autofarmQuests()
	while autoQuests and task.wait(10) do
		if not autoQuests then break end

		local questData = communicator.listenerFunction("HalloweenQuest"):Invoke("Get")
		for questID, data in questData do
			for name, has in data.Progress do
				if has >= data.Reqs[name] then
					completeQuest(questID)
				end
			end
		end
	end
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

local debounce = false
localPlayer.SaveStats.RealLife.Changed:Connect(function()
    if not debounce then
        debounce = true
        wait(0.1)
        if autoLoadLayout then
            local loaded = false
            while loaded ~= true do
                if #itemsFolder:GetChildren() <= 0 then
                	loadSetLayout()
                elseif #itemsFolder:GetChildren() > 2 then
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

--// Auto
AutoTab:AddLabel("- Default")
AutoTab:AddToggle({
	Name = "Auto load set layout",
	Callback = function(value)
		autoLoadLayout = value
		if value then
			task.wait(0.75)
			loadSetLayout()
		end
  	end
})
AutoTab:AddToggle({
	Name = "Auto rebirth",
	Callback = function(value)
		autoRebirth = value
		if value then
			rebirth()
		end
  	end
})
AutoTab:AddToggle({
	Name = "Auto quests",
	Callback = function(value)
		autoQuests = value
		autofarmQuests()
  	end
})

--// Layouts
LayoutTab:AddLabel("- Default")
LayoutTab:AddTextbox({
	Name = "Layout to load",
	Default = "1",
	TextDisappear = false,
	Callback = function(value)
		layoutToLoad = math.clamp(tonumber(value), 1, 5)
	end
})
LayoutTab:AddDropdown({
	Name = "Set layout data (set current placed layout to specific num)",
	Options = {"1", "2", "3", "4", "5"},
	Callback = function(value)
		setLayoutData(tonumber(value))
	end
})
LayoutTab:AddLabel("- Misc")
LayoutTab:AddButton({
	Name = "Load set layout",
	Callback = function()
		loadSetLayout()
  	end
})
LayoutTab:AddButton({
	Name = "Rebirth",
	Callback = function()
		rebirth()
  	end
})
LayoutTab:AddButton({
	Name = "Clear ores",
	Callback = function()
		clearOre()
  	end
})
LayoutTab:AddButton({
	Name = "Withdraw items",
	Callback = function()
		withdrawCurrentLayout()
  	end
})

--// Gui
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

Orion:Init()