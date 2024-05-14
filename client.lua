local displayedTexts = {}

RegisterCommand('rolldice', function(source, args)
    local numDice = tonumber(args[1]) or 1
    
    -- Ensure numDice is within bounds
    if numDice < 1 then
        numDice = 1
    elseif numDice > Config.MaxDice then
        numDice = Config.MaxDice
    end

    -- Trigger server event to roll the dice
    TriggerServerEvent('rollDice', numDice)
end)

RegisterNetEvent('displayDiceRolls')
AddEventHandler('displayDiceRolls', function(diceRolls)
    local total = 0
    for _, roll in ipairs(diceRolls) do
        total = total + roll
    end

    local numDiceRolled = #diceRolls
    local text = "Rolled " .. numDiceRolled .. " dice, total: " .. total

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    table.insert(displayedTexts, {
        text = text,
        position = coords,
        displayStart = GetGameTimer()
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Loop through displayed texts to check if any should be hidden
        for i, displayedText in ipairs(displayedTexts) do
            if GetGameTimer() >= displayedText.displayStart + 5000 then -- Display for 5 seconds
                table.remove(displayedTexts, i)
                break -- Exit loop to avoid modifying table while iterating
            else
                -- Update text position and draw it
                UpdateTextPosition(displayedText)
                DrawTextOnStomach(displayedText.position, displayedText.text)
            end
        end
    end
end)

-- Function to update text position to follow the player
function UpdateTextPosition(textData)
    local ped = PlayerPedId()
    if DoesEntityExist(ped) then
        local coords = GetEntityCoords(ped)
        textData.position = vector3(coords.x, coords.y, coords.z - 0.1) -- Adjust Z-coordinate for stomach position
    end
end

-- Function to draw text on the stomach of the player
function DrawTextOnStomach(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local scale = 0.45

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(x, y)
        -- local factor = (string.len(text)) / 370 --- umcomment if you would like the drawtext background
        -- DrawRect(x, y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68) --- umcomment if you would like the drawtext background
    end
     
end