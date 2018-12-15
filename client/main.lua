ESX                           = nil

local witnessPed = nil

local Markers = {
    ['OpenWitnessMenu'] = { ['x'] = 440.56942749023, ['y'] = -993.33453369141, ['z'] = 30.689599990845 },
    ['SpawnWitness'] = { ['x'] = 436.97479248047, ['y'] = -993.30126953125, ['z'] = 30.689598083496, ['h'] = 268.82745361328 }
}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

        Citizen.Wait(1)
    end

    if ESX.IsPlayerLoaded() then
        ESX.PlayerData = ESX.GetPlayerData()

        LoadMarkers()
    end
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(response)
    ESX.PlayerData = response

    LoadMarkers()
end)
  
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(response)
    ESX.PlayerData["job"] = response
end)

function LoadMarkers()
    Citizen.CreateThread(function()
        while true do
            local sleep = 500

            for place, val in pairs(Markers) do
                local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), val.x, val.y, val.z, true)

                if distance < 4.5 then
                    sleep = 5

                    if place == 'OpenWitnessMenu' then
                        DrawM('[E] Witnesses', 27, val.x, val.y, val.z - 0.945, 255, 255, 255, 0.7, 0.7)
                    end

                    if distance < 0.5 then
                        if IsControlJustReleased(0, 38) and ESX.PlayerData["job"]["name"] == "police" then
                            OpenWitnessMenu()
                        end
                    end
                end
            end

            Citizen.Wait(sleep)
        end
    
    end)
end

--[[## Code to add to witness menu ##
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin)
    end)
]]


RegisterCommand("addwitness", function()
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin, "Drugs")
    end)
end)

function OpenWitnessMenu()

    local elements = {}

    ESX.TriggerServerCallback('esx-qalle-camerasystem:getWitnesses', function(value)

        for k,v in pairs(value) do

            if v.action ~= nil then
                table.insert(elements, { label = v.action .. " - Witness ID: " .. v.number, clothes = v.clothes })
            else
                table.insert(elements, { label = "Witness ID: " .. v.number, clothes = v.clothes })
            end

        end

        ESX.UI.Menu.Open(
            'default', GetCurrentResourceName(), 'witness_menu',
            {
                title    = "Witnesses",
                align    = "right",
                elements = elements
            },
        function(data, menu)
            local action = data.current.value
            local clothes = data.current.clothes

            if witnessPed == nil then
                loadPed(action, clothes)
            else
                deleteWitness()

                Citizen.Wait(100)

                loadPed(action, clothes)
            end
                
        end, function(data, menu)
            deleteWitness()

            menu.close()
        end)
    end)
end

function deleteWitness()
    if witnessPed ~= nil then
        DeleteEntity(witnessPed)

        witnessPed = nil
    end 
end
  
function loadPed(witnessId, skin)
    deleteWitness()

    if witnessPed == nil then

        local CharacterModel = GetHashKey('mp_m_freemode_01')

        if skin["sex"] ~= 0 then
            CharacterModel = GetHashKey('mp_f_freemode_01')
        end

        while not HasModelLoaded(CharacterModel) do
            RequestModel(CharacterModel)

            Citizen.Wait(5)
        end

        witnessPed = CreatePed(5, CharacterModel, Markers['SpawnWitness']['x'], Markers['SpawnWitness']['y'], Markers['SpawnWitness']['z'] - 1, Markers['SpawnWitness']['h'], false, false)

        FreezeEntityPosition(witnessPed, true)
        SetPedAlertness(witnessPed, 0)

        ApplySkin(skin, witnessPed)
    else
        deleteWitness()
        witnessPed = nil
    end
end

-- ## Taken from skinchanger ## --

function ApplySkin(skin, ped)

    local Character = {}

    local playerPed = ped

    for k,v in pairs(skin) do
        Character[k] = v
    end

    SetPedHeadBlendData     (playerPed, Character['face'], Character['face'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)
    SetPedHairColor         (playerPed,       Character['hair_color_1'],   Character['hair_color_2'])           -- Hair Color
    SetPedHeadOverlay       (playerPed, 3,    Character['age_1'],         (Character['age_2'] / 10) + 0.0)      -- Age + opacity
    SetPedHeadOverlay       (playerPed, 1,    Character['beard_1'],       (Character['beard_2'] / 10) + 0.0)    -- Beard + opacity
    SetPedHeadOverlay       (playerPed, 2,    Character['eyebrows_1'],    (Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
    SetPedHeadOverlay       (playerPed, 4,    Character['makeup_1'],      (Character['makeup_2'] / 10) + 0.0)   -- Makeup + opacity
    SetPedHeadOverlay       (playerPed, 8,    Character['lipstick_1'],    (Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
    SetPedComponentVariation(playerPed, 2,    Character['hair_1'],         Character['hair_2'], 2)              -- Hair
    SetPedHeadOverlayColor  (playerPed, 1, 1, Character['beard_3'],        Character['beard_4'])                -- Beard Color
    SetPedHeadOverlayColor  (playerPed, 2, 1, Character['eyebrows_3'],     Character['eyebrows_4'])             -- Eyebrows Color
    SetPedHeadOverlayColor  (playerPed, 4, 1, Character['makeup_3'],       Character['makeup_4'])               -- Makeup Color
    SetPedHeadOverlayColor  (playerPed, 8, 1, Character['lipstick_3'],     Character['lipstick_4'])             -- Lipstick Color

    if Character['ears_1'] == -1 then
        ClearPedProp(playerPed, 2)
    else
        SetPedPropIndex(playerPed, 2, Character['ears_1'], Character['ears_2'], 2)  -- Ears Accessories
    end

    SetPedComponentVariation(playerPed, 8,  Character['tshirt_1'],  Character['tshirt_2'], 2)     -- Tshirt
    SetPedComponentVariation(playerPed, 11, Character['torso_1'],   Character['torso_2'], 2)      -- torso parts
    SetPedComponentVariation(playerPed, 3,  Character['arms'], 0, 2)                              -- torso
    SetPedComponentVariation(playerPed, 10, Character['decals_1'],  Character['decals_2'], 2)     -- decals
    SetPedComponentVariation(playerPed, 4,  Character['pants_1'],   Character['pants_2'], 2)      -- pants
    SetPedComponentVariation(playerPed, 6,  Character['shoes_1'],   Character['shoes_2'], 2)      -- shoes
    SetPedComponentVariation(playerPed, 1,  Character['mask_1'],    Character['mask_2'], 2)       -- mask
    SetPedComponentVariation(playerPed, 9,  Character['bproof_1'],  Character['bproof_2'], 2)     -- bulletproof
    SetPedComponentVariation(playerPed, 7,  Character['chain_1'],   Character['chain_2'], 2)      -- chain
    SetPedComponentVariation(playerPed, 5,  Character['bags_1'],    Character['bags_2'], 2)       -- Bag

    if Character['helmet_1'] == -1 then
        ClearPedProp(playerPed, 0)
    else
        SetPedPropIndex(playerPed, 0, Character['helmet_1'], Character['helmet_2'], 2)  -- Helmet
    end

    if Character['watches_1'] == -1 then
        ClearPedProp(playerPed,  6)
    else
        SetPedPropIndex(playerPed, 6, Character['watches_1'], Character['watches_2'], 2)                      -- Watches
    end

    if Character['bracelets_1'] == -1 then
        ClearPedProp(playerPed,  7)
    else
        SetPedPropIndex(playerPed, 7, Character['bracelets_1'], Character['bracelets_2'], 2)                      -- Bracelets
    end

    if Character['glasses_1'] == -1 then
        ClearPedProp(playerPed,  1)
    else
        SetPedPropIndex(playerPed, 1, Character['glasses_1'], Character['glasses_2'], 2)                  -- Glasses
    end
  
end

function DrawM(hint, type, x, y, z)
	ESX.Game.Utils.DrawText3D({x = x, y = y, z = z + 1.0}, hint, 0.4)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 2.0, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end