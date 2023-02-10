getgenv().autoTimeTrial = false

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local inTimeTrial = false

while autoTimeTrial do
    if not inTimeTrial then
        return
    end

    wait()
    pcall(function()
        if localPlayer.Character.Humanoid.Sit then
            local humanoidRootPart = localPlayer.Character.HumanoidRootPart

            for ok, ya in Workspace.Vehicles:GetDescendants() do
                if ya.Name == "Player" and ya.Value == localPlayer then
                    for ye, lo in 
                end
            end
        end
    end)
end
