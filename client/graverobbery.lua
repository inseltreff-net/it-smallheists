-- [[ Blip Variables ]] --
CementaryLocation = {}
local blipSpawned = false

-- [[ Grave Variables ]] --
local isDigging = false

-- [[ Resource Metadata ]] -- 
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        removeBlip()
    end
end)

-- [[ Function for Grave Stones ]] --
local ZoneSpawned = false 
local ZoneCreated = {}

CreateThread(function()
    for k, v in pairs(Config.Graves) do
        if ZoneSpawned then
            return
        end

        for k, v in pairs(Config.Graves) do
            if not ZoneCreated[k] then
                ZoneCreated[k] = {}
            end

            ZoneCreated[k] = exports['qb-target']:AddBoxZone(v["GraveName"], v["Coords"], v["Length"], v["Width"], {
                name = v["GraveName"],
                heading = v["Heading"],
                debugPoly = Config.DebugPoly,
            }, {
                options = {
                    {
                        icon = "fa-solid fa-trowel",
                        label = "Dig Grave",
                        event = "it-smallheists:Client:StartDigging",
                    },
                },
        
                distance = 1
            })

            ZoneSpawned = true
        end
    end
end)

-- [[ Events ]] -- 
RegisterNetEvent('it-smallheists:client:ResetGrave', function(OldGrave, state)
    Config.Graves[OldGrave].Looted = state
end)

RegisterNetEvent("it-smallheists:client:StartDigging", function()
    if isDigging == false and QBCore.Functions.HasItem('shovel') then
        local ped = PlayerPedId()
        local playerPos = GetEntityCoords(ped)
        TriggerEvent('animations:client:EmoteCommandStart', {"dig"})
        for k, v in pairs(Config.Graves) do
            local dist = #(GetEntityCoords(ped) - vector3(Config.Graves[k]["Coords"].x, Config.Graves[k]["Coords"].y, Config.Graves[k]["Coords"].z))
            if dist <= 2 then
                if Config.Graves[k].Looted == false then
                    Config.Graves[k].Looted = true
                    CurGrave = k
                    QBCore.Functions.Progressbar("digging", "Digging...", math.random(8000, 15000), false, true, {
                        disableMovement = true,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        Diggin = true
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerServerEvent('it-smallheists:server:setGraveState', CurGrave)
                        TriggerServerEvent('it-smallheists:server:GiveItems', CurGrave)
                        policeAlert()
                    end, function() -- Cancel
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        QBCore.Functions.Notify("Cancelled.", "error")
                    end)
                elseif Config.Graves[k].Looted == true then
                    QBCore.Functions.Notify('Seems like someone beat you to it!', 'error', 5000)
                end
            end
        end
    end
end)

-- [[ Blip Function ]] --
if Config.Blip then
    createBlip(vector3(-1683.29, -293.2, 51.89), 'Cemetery', 310, 39, 1.0, 3, false)
end

function removeBlip()
    for i, GravBlip in pairs(CementaryLocation) do
        removeBlip(GravBlip)
    end
end

-- [[ Animation Functions ]] --
function LoadAnimDict( dict )
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Wait(5)
    end
end