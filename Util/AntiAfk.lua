local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")

Players.LocalPlayer.Idled:connect(function()
   VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
   wait(1)
   VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)