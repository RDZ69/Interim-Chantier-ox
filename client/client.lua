ESX = exports["es_extended"]:getSharedObject()
local conversationAvecPNJbucheron = false
local blips = {}
local ballaisPressed = false
local SoudeballaisPressed = false
local drillPressed = false
local CoordsBalleyer = {
    { x = -453.0689, y = -1004.1306, z = 23.8983 },
    { x = -451.5812, y = -1002.3510, z = 23.9256 },
    { x = -447.6202, y = -1001.9880, z = 23.9854 },
    { x = -446.8782, y = -1004.5437, z = 24.0013 },
    { x = -448.4866, y = -1006.6518, z = 23.9709 },
    { x = -451.0423, y = -1007.0919, z = 24.0903 },
}
local CoordsSoudee = {
    { x = -447.7161, y = -997.1418, z = 23.9839 },
    { x = -462.9481, y = -998.6558, z = 23.7407 },
    { x = -464.3241, y = -1014.9700, z = 23.7206 },
    { x = -463.0275, y = -1016.7921, z = 23.7400 },
    { x = -449.1218, y = -1016.4659, z = 23.9674 },
}
local CoordsDrill = {
    { x = -463.8233, y = -1006.8613, z = 23.9839 },
    { x = -460.9958, y = -1001.7836, z = 23.7511 },
    { x = -457.6921, y = -1004.2256, z = 23.8242 },
    { x = -455.0536, y = -1006.6631, z = 23.8642 },
    { x = -457.9944, y = -998.6470, z = 23.8349 },
}

--- Blips Chantier
function CreateBlipCircle(coords, text, color, sprite)
	blip = AddBlipForCoord(coords)

	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 0.8)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	CreateBlipCircle(vector3(Config.Chantier.x, Config.Chantier.y, Config.Chantier.z), Config.ChantierBlipText, Config.ChantierBlipColor, Config.ChantierBlipSprite)
end)

-- Ped Pour prendre service
Citizen.CreateThread(function()
    local hash = GetHashKey(Config.priseservice.Ped)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", Config.priseservice.Ped, Config.priseservice.PedCoords, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

exports.ox_target:addBoxZone({
    coords = Config.priseservice.Coords,
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'box',
            event = 'RDZ:SService',
            icon = 'fas fa-tags',
            label = "Parlez au boss du chantier",
        }
    }
})


lib.registerContext({
  id = 'RDZ:Service',
  title = 'Boss Chantier',
  options = {
    {
    title = 'Prendre de service',
    icon = 'fa-solid fa-house',
    event = 'RDZ:Prisedeservice'
    },
    {
    title = 'Fin de service',
    icon = 'fa-solid fa-house',
    event = 'RDZ:Finservice'
    },  
  }
})

RegisterNetEvent('RDZ:SService')
AddEventHandler('RDZ:SService', function()
    lib.showContext('RDZ:Service')
end)

RegisterNetEvent('RDZ:Prisedeservice')
AddEventHandler('RDZ:Prisedeservice', function()
    local playerPed = PlayerPedId()
    local playerName = GetPlayerName(PlayerId())
    conversationAvecPNJbucheron = true 

    if Config.Notification == 'ox' then
        lib.notify({ 
            title = 'Boss Chantier',
            description = "Mr " .. playerName ..  " Prise de service, regardez vos GPS",
            type = 'success',
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification( "Mr " .. playerName .. " vous avez pris de service, regardez vos GPS")
    else
        print('Type de notification non pris en charge que le ox ou esx')
    end

    setUniform('Chantier_wear', playerPed)

    -- Définition des coordonnées des blips
    local blipCoords = {
        { x = -441.3876, y = -989.3051, z = 23.8862, sprite = 1, scale = 1.0, color = 1, label = "Soudée" }, -- Fait
        { x = -479.5995, y = -1005.2922, z = 22.5505, sprite = 1, scale = 1.0, color = 1, label = "Nettoyer" }, -- Fait
        { x = -433.0150, y = -1017.4095, z = 25.8981, sprite = 1, scale = 1.0, color = 1, label = "Bois" }, -- Pas Fait
    }

    -- Création des blips
    for i = 1, #blipCoords do
        local blip = AddBlipForCoord(blipCoords[i].x, blipCoords[i].y, blipCoords[i].z)
        SetBlipSprite(blip, blipCoords[i].sprite)
        SetBlipDisplay(blip, 2)
        SetBlipScale(blip, blipCoords[i].scale)
        SetBlipColour(blip, blipCoords[i].color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blipCoords[i].label)
        EndTextCommandSetBlipName(blip)

        table.insert(blips, blip)
    end
end)

RegisterNetEvent('RDZ:Finservice')
AddEventHandler('RDZ:Finservice', function()
    local playerName = GetPlayerName(PlayerId())
        
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)		
        TriggerEvent('skinchanger:loadSkin', skin)											

        -- Suppression des blips
        for _, blip in ipairs(blips) do
            RemoveBlip(blip)
        end
        blips = {}

        -- Affichage de la notification
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Mr " .. playerName ..  " Vous avez pris votre fin de service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Mr " .. playerName ..  " Vous avez pris votre fin de service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end)
end)


function setUniform(job)
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            if Config.Uniforms[job].male ~= nil then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].male)
            end

            if job == 'Chantier_wear' then
				SetPedArmour(playerPed, 0)
            end
        else
            if Config.Uniforms[job].female ~= nil then
                TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms[job].female)
            end

            if job == 'Chantier_wear' then
                SetPedArmour(playerPed, 0)
            end
        end
    end)
end

-- Ped pour netoyer
Citizen.CreateThread(function()
    local hash = GetHashKey(Config.debris.Ped)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", Config.debris.Ped, -479.5995, -1005.2922, 22.5505, 262.8149, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

local markerbalayage

function createMarkerBallayage(coords)
    coords.z = coords.z - 0.5

    markerbalayage = lib.marker.new({
        type = 2,
        coords = coords,
        width = 0.30,
        height = 0.25,
        color = { r = 0, g = 60, b = 255, a = 200 },
    })
end


RegisterNetEvent('RDZ:BlipsBalleyage')
AddEventHandler('RDZ:BlipsBalleyage', function()
    if conversationAvecPNJbucheron then -- Vérifier si le joueur a parlé au PNJ
    local randomIndex = math.random(1, #CoordsBalleyer)
    local randomCoords = CoordsBalleyer[randomIndex]
    createMarkerBallayage(randomCoords)

    -- Ajouter un GPS
    SetNewWaypoint(randomCoords.x, randomCoords.y)

    if Config.Notification == 'ox' then
        lib.notify({ 
            title = 'Boss Chantier',
            description = "Regardez votre GPS pour trouver ou passer le balais.",
            type = 'success',
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification("Regardez votre GPS pour trouver ou passer le balais.")
    else
        print('Type de notification non pris en charge que le ox ou esx')
    end
    else
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Vous devez prendre votre service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Vous devez prendre votre service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end
end)

RegisterNetEvent('RDZ:ChangeMarkerPosition')
AddEventHandler('RDZ:ChangeMarkerPosition', function()
    local randomIndex = math.random(1, #CoordsBalleyer)
    local randomCoords = CoordsBalleyer[randomIndex]
    createMarkerBallayage(randomCoords)

    -- Ajouter un GPS
    SetNewWaypoint(randomCoords.x, randomCoords.y)

    if Config.Notification == 'ox' then
        lib.notify({ 
            title = 'Boss Chantier',
            description = "Va ici pour passer le balais.",
            type = 'success',
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification("Va ici pour passer le balais.")
    else
        print('Type de notification non pris en charge que le ox ou esx')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if markerbalayage then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local markerCoords = markerbalayage.coords
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, markerCoords.x, markerCoords.y, markerCoords.z)
    
            markerbalayage:draw()

            if distance < 1.5 then
                if not lib.isTextUIOpen() then
                    lib.showTextUI("[E] Pour nettoyer le sol")
                end
    
                if IsControlJustPressed(0, 51) and not ballaisPressed then
                    TriggerEvent('RDZ:Ballayage')
                end
            else
                lib.hideTextUI() -- Supprime le gros truck moche appuie sur E 
            end
        end
    end
end)

exports.ox_target:addBoxZone({
    coords = vec3(-479.5995, -1005.2922, 23.5505),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'box',
            event = 'RDZ:BlipsBalleyage',
            icon = 'fa-regular fa-user',
            label = "Parler a bob pour travailler",
        },
        {
            name = 'box',
            event = 'RDZ:BlipsFinBalleyage',
            icon = 'fa-regular fa-user',
            label = "Arret de travail",
        }

    }
})

RegisterNetEvent("RDZ:BlipsFinBalleyage")
AddEventHandler("RDZ:BlipsFinBalleyage", function()
    if markerbalayage ~= nil then
        for _, markerId in ipairs(markerbalayage) do
            RemoveBlip(markerId)
        end
        markerbalayage = nil
    end
end)

RegisterNetEvent('RDZ:Ballayage')
AddEventHandler('RDZ:Ballayage', function()
    TriggerServerEvent('RDZ:Ballayer')
end)

RegisterNetEvent('RDZ:Circle:Ballayer')
AddEventHandler('RDZ:Circle:Ballayer', function()
    if conversationAvecPNJbucheron then
        ballaisPressed = true
        TriggerEvent('RDZ:Animation:Ballayer') -- Déclenche l'animation de balayage

        -- Affichage du cercle de progression
        lib.progressCircle({
            duration = 4000,
            label = 'Nettoie le sol',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            anim = {
                dict = 'anim@amb@drug_field_workers@rake@male_a@idles',
                clip = 'idle_b'
            },
            prop = {
                model = GetHashKey('prop_tool_broom'),
                pos = vector3(-0.010000, 0.040000, -0.030000),
                rot = vector3(0.000000, 0.000000, 0.000000),
            },
        }, function(cancelled)
            if not cancelled then
                TriggerServerEvent('RDZ:Ballayer:Rewards') -- Si la progression n'a pas été annulée, déclenche l'événement côté serveur pour récompenser le joueur
            end
        end)

        -- Arrête l'animation de balayage lorsque la progression est terminée
        TriggerEvent('RDZ:Animation:StopBallayer')

        ballaisPressed = false
    else
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Vous devez prendre votre service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Vous devez prendre votre service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end
end)

RegisterNetEvent("RDZ:Animation:Ballayer")
AddEventHandler("RDZ:Animation:Ballayer", function()
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_JANITOR", 0, true)
    FreezeEntityPosition(PlayerPedId(), true)
end)

RegisterNetEvent("RDZ:Animation:StopBallayer")
AddEventHandler("RDZ:Animation:StopBallayer", function()
    ClearPedTasksImmediately(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)

-- Ped pour Travailer soudée

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.Soude.Ped)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Soude.Ped, -441.5910, -990.2573, 22.8793, 94.8829, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

local markersoude

function createMarkerSoudee(coords)
    coords.z = coords.z - 0.5

    markersoude = lib.marker.new({
        type = 2,
        coords = coords,
        width = 0.30,
        height = 0.25,
        color = { r = 0, g = 60, b = 255, a = 200 },
    })
end

RegisterNetEvent('RDZ:BlipsSoudee')
AddEventHandler('RDZ:BlipsSoudee', function()
    if conversationAvecPNJbucheron then -- Vérifier si le joueur a parlé au PNJ
        local randomIndex = math.random(1, #CoordsSoudee)
        local randomCoords = CoordsSoudee[randomIndex]
        createMarkerSoudee(randomCoords)

        -- Ajouter un GPS
        SetNewWaypoint(randomCoords.x, randomCoords.y)

        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Regardez votre GPS pour trouver ou allez souder.",
                type = 'success',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Regardez votre GPS pour trouver ou allez souder.")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    else
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Vous devez prendre votre service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Vous devez prendre votre service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end
end)

RegisterNetEvent('RDZ:ChangeMarkerSoudée')
AddEventHandler('RDZ:ChangeMarkerSoudée', function()
    local randomIndex = math.random(1, #CoordsSoudee)
    local randomCoords = CoordsSoudee[randomIndex]
    createMarkerSoudee(randomCoords)

    -- Ajouter un GPS
    SetNewWaypoint(randomCoords.x, randomCoords.y)

    if Config.Notification == 'ox' then
        lib.notify({ 
            title = 'Boss Chantier',
            description = "Je t'ai mis la postion GPS pour soudée.",
            type = 'success',
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification("Je t'ai mis la postion GPS pour soudée.")
    else
        print('Type de notification non pris en charge que le ox ou esx')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if markersoude then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local markerCoords = markersoude.coords
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, markerCoords.x, markerCoords.y, markerCoords.z)
    
            markersoude:draw()

            if distance < 1.5 then
                if not lib.isTextUIOpen() then
                    lib.showTextUI("[E] Pour souder")
                end
    
                if IsControlJustPressed(0, 51) and not SoudeballaisPressed then
                    SoudeballaisPressed = true
                    TriggerEvent('RDZ:soudee')
                    markersoude = nil -- Supprime le Marker
                    lib.hideTextUI() -- Supprime le gros truck moche appuie sur E 
                end
            end
        end
    end
end)

exports.ox_target:addBoxZone({
    coords = vector3(-441.5910, -990.2573, 23.8793),
    size = vector3(1, 1, 1),
    rotation = 45.0,
    debug = drawZones,
    options = {
        {
            name = 'box',
            event = 'RDZ:BlipsSoudee',
            icon = 'fa-regular fa-user',
            label = "Parler a bob pour travailler",
        },
        {
            name = 'box',
            event = 'RDZ:MarkerFinSoudée',
            icon = 'fa-regular fa-user',
            label = "Arret de travail",
        }
    }
})

RegisterNetEvent("RDZ:MarkerFinSoudée")
AddEventHandler("RDZ:MarkerFinSoudée", function()
    if markersoude ~= nil then
        for _, markerId in ipairs(markersoude) do
            RemoveBlip(markerId)
        end
        markersoude = nil
    end
end)

RegisterNetEvent('RDZ:soudee')
AddEventHandler('RDZ:soudee', function()
    TriggerServerEvent('RDZ:Soudée')
end)

RegisterNetEvent('RDZ:Circle:Soudée')
AddEventHandler('RDZ:Circle:Soudée', function()
    if conversationAvecPNJbucheron then
        SoudeballaisPressed = true
        TriggerEvent("RDZ:Animation:Soudée")
        lib.progressCircle({
            duration = 4000,
            label = 'Vous soudé les poutre',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
        })
        TriggerEvent('RDZ:Animation:StopSoudée') -- Arrête l'animation de balayage
        TriggerServerEvent('RDZ:Soudée:Rewards') -- Redirection vers le serveur pour les récompenses
        SoudeballaisPressed = false
    else
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Vous devez prendre votre service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Vous devez prendre votre service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end
end)

RegisterNetEvent("RDZ:Animation:Soudée")
AddEventHandler("RDZ:Animation:Soudée", function()
    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
end)

RegisterNetEvent("RDZ:Animation:StopSoudée")
AddEventHandler("RDZ:Animation:StopSoudée", function()
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)  
end)



-- Ped Drill 

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.Drill.Ped)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVFEMALE", Config.Drill.Ped, -458.1207, -1008.6492, 22.8262, 358.8804, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

local markerdrill

function createMarkerdrill(coords)
    coords.z = coords.z - 0.5

    markerdrill = lib.marker.new({
        type = 2,
        coords = coords,
        width = 0.30,
        height = 0.25,
        color = { r = 0, g = 60, b = 255, a = 200 },
    })
end

RegisterNetEvent('RDZ:BlipsPercée')
AddEventHandler('RDZ:BlipsPercée', function()
    if conversationAvecPNJbucheron then
        local randomIndex = math.random(1, #CoordsDrill)
        local randomCoords = CoordsDrill[randomIndex]
        createMarkerdrill(randomCoords)

        -- Ajouter un GPS
        SetNewWaypoint(randomCoords.x, randomCoords.y)

        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Regardez votre GPS pour trouver ou casser le sol.",
                type = 'success',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Regardez votre GPS pour trouver ou casser le sol.")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    else
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Vous devez prendre votre service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Vous devez prendre votre service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end
end)

RegisterNetEvent('RDZ:ChangeMarkerPercée')
AddEventHandler('RDZ:ChangeMarkerPercée', function()
    local randomIndex = math.random(1, #CoordsDrill)
    local randomCoords = CoordsDrill[randomIndex]
    createMarkerdrill(randomCoords)

    -- Ajouter un GPS
    SetNewWaypoint(randomCoords.x, randomCoords.y)

    if Config.Notification == 'ox' then
        lib.notify({ 
            title = 'Boss Chantier',
            description = "Je t'ai mis la postion GPS pour casser le sol.",
            type = 'success',
        })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification("Je t'ai mis la postion GPS pour casser le sol.")
    else
        print('Type de notification non pris en charge que le ox ou esx')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if markerdrill then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local markerCoords = markerdrill.coords
            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, markerCoords.x, markerCoords.y, markerCoords.z)
    
            markerdrill:draw()

            if distance < 1.5 then
                if not lib.isTextUIOpen() then
                    lib.showTextUI("[E] Percée")
                end
    
                if IsControlJustPressed(0, 51) and not drillPressed then
                    drillPressed = true
                    TriggerEvent('RDZ:percée1')
                    markerdrill = nil -- Supprime le Marker
                    lib.hideTextUI() -- Supprime le gros truck moche appuie sur E 
                end
            end
        end
    end
end)

exports.ox_target:addBoxZone({
    coords = vec3(-458.1207, -1008.6492, 23.8262),
    size = vec3(1, 1, 1),
    rotation = 45,
    debug = drawZones,
    options = {
        {
            name = 'box',
            event = 'RDZ:BlipsPercée',
            icon = 'fa-regular fa-user',
            label = "Parler a bob pour travailler",
        },
        {
            name = 'box',
            event = 'RDZ:MarkerFinPercée',
            icon = 'fa-regular fa-user',
            label = "Arret de travail",
        }
    }
})

RegisterNetEvent("RDZ:MarkerFinPercée")
AddEventHandler("RDZ:MarkerFinPercée", function()
    if markerdrill ~= nil then
        for _, markerId in ipairs(markerdrill) do
            -- Supprimer le marqueur avec l'identifiant markerId
            RemoveBlip(markerId)
        end
        markerdrill = nil -- Réinitialiser la variable à nil
    end
end)

RegisterNetEvent('RDZ:percée1')
AddEventHandler('RDZ:percée1', function()
    TriggerServerEvent('RDZ:percée')
end)

RegisterNetEvent('RDZ:Circle:percée')
AddEventHandler('RDZ:Circle:percée', function()
    if conversationAvecPNJbucheron then
        drillPressed = true
        TriggerEvent("RDZ:Animation:Percée")
        lib.progressCircle({
            duration = 4000,
            label = 'Vous percée le sol',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
            },
        })
        TriggerEvent('RDZ:Animation:StopPercée') -- Arrête l'animation de balayage
        TriggerServerEvent('RDZ:Percée:Rewards') -- Redirection vers le serveur pour les récompenses
        drillPressed = false
    else
        if Config.Notification == 'ox' then
            lib.notify({ 
                title = 'Boss Chantier',
                description = "Vous devez prendre votre service",
                type = 'error',
            })
        elseif Config.Notification == 'esx' then
            ESX.ShowNotification("Vous devez prendre votre service")
        else
            print('Type de notification non pris en charge que le ox ou esx')
        end
    end
end)

RegisterNetEvent("RDZ:Animation:Percée")
AddEventHandler("RDZ:Animation:Percée", function()
    FreezeEntityPosition(PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_CONST_DRILL", 0, true)
end)

RegisterNetEvent("RDZ:Animation:StopPercée")
AddEventHandler("RDZ:Animation:StopPercée", function()
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)  
end)