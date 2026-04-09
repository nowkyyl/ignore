repeat
    task.wait()
until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local tool = character:FindFirstChildOfClass("Tool")
local Settings = require(tool.ACS_Settings)
local Animations = require(tool.ACS_Animations)

character.ChildAdded:Connect(function(child)
    if child.Name == "S"..tool.Name then
        child:Destroy()
    end
end)

local Events = ReplicatedStorage.ACS_Engine.Events
local Equip = Events.Equip
while true and tool do
    for i = 1, 20 do
        Equip:FireServer(tool, 1, Settings, Animations)
    end

    task.wait(0.1)
end
