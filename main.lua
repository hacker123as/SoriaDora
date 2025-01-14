-- SoriaDora: TuerSS 2Way Execute Script
-- This script checks for new scripts to execute every 2 seconds.
-- It retrieves a script from the API endpoint based on the Roblox player's username,
-- executes it, and sends feedback to the server whether it was successful or not.

-- Function to send POST feedback to the server
function sendFeedback(username, status)
    local httpService = game:GetService("HttpService") -- Roblox's HTTP service for making web requests
    local feedbackUrl = "https://tuerss.com/api/executes/" .. username .. "/feedback"
    local data = {
        message = status -- Either "executed successfully" or "failed to execute"
    }
    
    -- Convert data table to JSON format
    local jsonData = httpService:JSONEncode(data)
    
    -- Send a POST request with the feedback data
    local success, response = pcall(function()
        return httpService:PostAsync(feedbackUrl, jsonData, Enum.HttpContentType.ApplicationJson)
    end)
    
    -- Print the result for debugging purposes
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
    
    -- Fetch the script from the API
    local success, scriptContent = pcall(function()
        return httpService:GetAsync(executeUrl)
    end)
    
    if success and scriptContent and scriptContent ~= "-- nothing here" then
        -- Try to execute the script using Roblox's loadstring function
        local executeSuccess, errorMessage = pcall(function()
            loadstring(scriptContent)() -- Executes the fetched Lua script
        end)
        
        -- Send feedback based on whether the execution was successful
        if executeSuccess then
            sendFeedback(username, "executed successfully")
        else
            sendFeedback(username, "failed to execute: " .. errorMessage)
        end
    else
        print("No script to execute or failed to fetch script")
    end
end

-- Main loop to check for new scripts every 2 seconds
local username = game.Players.LocalPlayer.Name -- Get the Roblox player's username
while true do
    checkAndExecute(username) -- Check and execute script for the player
    wait(2) -- Wait for 2 seconds before checking again
end
