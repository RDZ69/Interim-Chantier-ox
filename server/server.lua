ESX = exports["es_extended"]:getSharedObject()

RegisterServerEvent('RDZ:Ballayer')
AddEventHandler('RDZ:Ballayer', function()
    local _source = source

    TriggerClientEvent('RDZ:Circle:Ballayer', _source)
end)

RegisterServerEvent('RDZ:Ballayer:Rewards')
AddEventHandler('RDZ:Ballayer:Rewards', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local amountToAdd = math.random(Config.debris.minMoney, Config.debris.maxMoney)  -- Génère la quantité à ajouter

        xPlayer.addMoney(amountToAdd)
        
        -- Envoyer l'événement client pour changer la position du marqueur
        TriggerClientEvent('RDZ:ChangeMarkerPosition', _source)

        if Config.Notification == 'ox' then
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'Boss',
                description = "Vous avez reçu " .. amountToAdd .. " $.",
                type = 'success',
            })
        elseif Config.Notification == 'esx' then
            TriggerClientEvent('esx:showNotification', _source, "Vous avez reçu " .. amountToAdd .. " $.")
        end
    end
end)

RegisterServerEvent('RDZ:Soudée')
AddEventHandler('RDZ:Soudée', function()
    local _source = source

    TriggerClientEvent('RDZ:Circle:Soudée', _source)
end)

RegisterServerEvent('RDZ:Soudée:Rewards')
AddEventHandler('RDZ:Soudée:Rewards', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local amountToAdd = math.random(Config.Soude.minMoney, Config.Soude.maxMoney)  -- Génère la quantité à ajouter

        xPlayer.addMoney(amountToAdd)
        
        -- Envoyer l'événement client pour changer la position du marqueur
        TriggerClientEvent('RDZ:ChangeMarkerSoudée', _source)

        if Config.Notification == 'ox' then
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'Boss',
                description = "Vous avez reçu " .. amountToAdd .. " $.",
                type = 'success',
            })
        elseif Config.Notification == 'esx' then
            TriggerClientEvent('esx:showNotification', _source, "Vous avez reçu " .. amountToAdd .. " $.")
        end
    end
end)

RegisterServerEvent('RDZ:percée')
AddEventHandler('RDZ:percée', function()
    local _source = source

    TriggerClientEvent('RDZ:Circle:percée', _source)
end)

RegisterServerEvent('RDZ:Percée:Rewards')
AddEventHandler('RDZ:Percée:Rewards', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local amountToAdd = math.random(Config.Drill.minMoney, Config.Drill.maxMoney)  -- Génère la quantité à ajouter

        xPlayer.addMoney(amountToAdd)
        
        -- Envoyer l'événement client pour changer la position du marqueur
        TriggerClientEvent('RDZ:ChangeMarkerPercée', _source)

        if Config.Notification == 'ox' then
            TriggerClientEvent('ox_lib:notify', _source, {
                title = 'Boss',
                description = "Vous avez reçu " .. amountToAdd .. " $.",
                type = 'success',
            })
        elseif Config.Notification == 'esx' then
            TriggerClientEvent('esx:showNotification', _source, "Vous avez reçu " .. amountToAdd .. " $.")
        end
    end
end)