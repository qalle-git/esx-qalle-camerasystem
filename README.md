# esx-qalle-camerasystem

[NOTES]

* This is a simple script i made along time ago, still useful.

* This gives you the opportunity to have CCTV in some place or to add it into the sell drugs to npc script.

* Example : I added this into my selldrugs to npc script. Which makes them take the phone and send it to police station.

```lua
function CallPolice()
    local currentPed = oldPed

    ESX.ShowNotification('I dont want this kind of stuff!')

    FreezeEntityPosition(currentPed, false)

    Citizen.Wait(2000)

    ESX.LoadAnimDict('cellphone@')

    TaskReactAndFleePed(currentPed, PlayerPedId())

    Citizen.Wait(1000)

    TaskPlayAnim(currentPed, 'cellphone@','cellphone_call_listen_base' ,3.0, -1, -1, 50, 0, false, false, false)

    Citizen.Wait(3000)

    if GetEntityHealth(currentPed) > 0 then

        local x,y,z = table.unpack(GetEntityCoords(currentPed))

        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin, "Drugvictim")
        end)

        TriggerServerEvent('esx_phone:send', 'police', 'Someone tried selling me drugs, I did get a photograph of him, sent it to you!', { x = x, y = y, z = z })
    end 

    currentlyDoingDeal = false

end
```

* This make them be added to the witness list:

```lua
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx-qalle-camerasystem:addWitness', skin, "Label")
    end)
```

* You could easily make a cctv system and count everyone that walks in of an door with the code-snippet above ^

[REQUIREMENTS]
  
* ESX
* esx_skin
* skinchanger

[INSTALLATION]

1) Download: https://github.com/qalle-fivem/esx-qalle-camerasystem

2) Add this in your server.cfg :
``start esx-qalle-camerasystem``

[SCREENSHOTS]

