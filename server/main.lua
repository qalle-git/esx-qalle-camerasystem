ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

local WitnessPeds = {}

local lastId = 0

RegisterServerEvent('esx-qalle-camerasystem:addWitness')
AddEventHandler('esx-qalle-camerasystem:addWitness', function(clothes, action)
   
    local src = tonumber(source)
    local pedClothes = clothes

    local newNumber = lastId + 1

    if action ~= nil then
        table.insert(WitnessPeds, {random = newNumber, clothes = pedClothes, action = action})
    else
        table.insert(WitnessPeds, {random = newNumber, clothes = pedClothes})
    end    
end)

ESX.RegisterServerCallback('esx-qalle-camerasystem:getWitnesses', function(source, cb)
    local witnesses = {}

    for id, val in pairs(WitnessPeds) do
        if val.action ~= nil then
            table.insert(witnesses, { number = val.random, clothes = val.clothes, action = val.action })
        else
            table.insert(witnesses, { number = val.random, clothes = val.clothes })
        end
    end
    
    cb(witnesses)
end)
