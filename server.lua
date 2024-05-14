RegisterServerEvent('rollDice')
AddEventHandler('rollDice', function(numDice)
    local player = source
    local diceRolls = {}
    
    -- Ensure numDice is within bounds
    if numDice > Config.MaxDice then
        numDice = Config.MaxDice
    end

    -- Roll the dice
    for i = 1, numDice do
        table.insert(diceRolls, math.random(1, 6))
    end

    -- Trigger client-side event to display dice rolls
    TriggerClientEvent('displayDiceRolls', player, diceRolls)
end)
