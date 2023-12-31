local containers = {}
local containerFee = Config.ContainerFee

local policeAlert = false

local heistTime = Config.HeistTime['container'] * 1000
local mailTime = Config.MailTime['container'] * 1000

local function removeContainerTarget(target)
    debugMessage('Removing container target: ' .. target)
    exports['qb-target']:RemoveZone('container-'..target)
    containers[target] = nil
end

local function openContainer(contID)
    local hasItem = hasItem(Config.ContainerItem)
    debugMessage('Player has item: ' .. tostring(hasItem))
    if not hasItem then
        sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_NO_ITEM']:format(Config.ContainerItem), 'error')
        return
    end

    local currentContainer = containers[contID]
    if currentContainer == nil then return end
    TriggerEvent('animations:client:EmoteCommandStart', {"weld"})
    exports['ps-ui']:Circle(function(success)
        if success then
            QBCore.Functions.Progressbar('loot_container', Locales[language]['CONTAINER_HEIST_PROGRESSBAR_LOOT'], 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
            }, {}, {}, {}, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                -- Get Loot
                local loot = Config.Container[contID].loot
                if loot ~= nil then
                    for k, v in pairs(loot) do
                        local lootAmount = math.random(Config.LootAmount.min, Config.LootAmount.max)
                        TriggerServerEvent('it-smallheists:server:giveItem', v, lootAmount)
                        TriggerServerEvent('it-smallheists:server:sendWebhook', 'Container Heist', 'Player '..GetPlayerName(PlayerId())..' looted '..lootAmount..'x '..v..' from Container '..contID, 16711680, false)
                    end
                end
                -- Remove container
                removeContainerTarget(contID)
                -- Remove item
                local breakItem = math.random(1, 100)
                if breakItem <= Config.BreakChange then
                    TriggerServerEvent('it-smallheists:server:removeItem', Config.ContainerItem, 1)
                    sendMessage(Locales[language]['CONTAINER_HEIST_NOTIFICATION_ITEM_BREAK'], 'error')
                end
                -- Check if all containers are done
                if #containers == 0 then
                    TriggerServerEvent('it-smallheists:server:heistCooldown', 'container')
                    sendMessage(Locales[language]['CONTAINER_HEIST_NOTIFICATION_FINISHED'], 'success')
                    finished = true
                    activeJob = false
                end
            end, function() -- Cancel
                sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_CANCELED'], 'error')
            end)
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            TriggerServerEvent('it-smallheists:server:removeItem', Config.ContainerItem, 1)
            sendMessage(Locales[language]['CONTAINER_HEIST_NOTIFICATION_FAIL_LOOT'], 'error')

            if not policeAlert then
                policeAlert = true
                local coords = GetEntityCoords(PlayerPedId())
                sendDispatch(Locales[language]['CONTAINER_HEIST_NOTIFICATION_POLICE_ALERT'], coords)
            end

        end
    end, Config.ContainerNumberOfCircles, Config.ContainerMinigameTime)
end

local function createContainerTargets()
    for k, v in ipairs(containers) do
        debugMessage('Creating container target: ' .. v.location)
        exports['qb-target']:AddBoxZone('container-'..k, v.coords, 1, 1, {
            name = 'container-'..k,
            heading = 350,
            debugPoly = Config.DebugPoly,
        }, {
            options = {
                {
                    action = function()
                        openContainer(k)
                    end,
                    icon = 'fas fa-box-open',
                    label = Locales[language]['CONTAINER_HEIST_TARGET_CONTAINER'],
                    
                },
            },
            distance = 2.0
        })
    end
end

local function startContainerHeist()
    -- Check if player is in a job
    debugMessage('Player job status: ' .. tostring(activeJob))
    if activeJob then
        sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_ACTIVE_JOB'], 'error')
        return
    end
    debugMessage('Player has a phone: ' .. tostring(hasPhone()))
    if not hasPhone() then
        sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_NO_ITEM']:format('Handy'), 'error')
        return
    end

    QBCore.Functions.TriggerCallback('it-smallheists:server:getHeistStatus', function(status)
        debugMessage('Heist status: ' .. status)
        if status == 'cooldown' then
            sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_COOLDOWN'], 'error')
            return
        elseif status == 'active' then
            sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_ACTIVE_HEIST'], 'error')
            return
        end

        QBCore.Functions.TriggerCallback('it-smallheists:server:getPlayerMoney', function(money)
            local hasMoney = money >= containerFee
            debugMessage('Player has enough money: (' .. money .. '/' .. containerFee .. ')')
            if not hasMoney then
                sendMessage(Locales[language]['CONTAINER_HEIST_NOTIFICATION_NO_MONEY'], 'error')
                return
            else
                TriggerServerEvent('it-smallheists:Server:removeMoney', 'cash', containerFee, 'Container Fee')
            end

            activeJob = true
            finished = false
            TriggerEvent('animations:client:EmoteCommandStart', {"crossarms"})
            TriggerServerEvent('it-smallheists:server:setHeistStatus', 'container', 'active')

            QBCore.Functions.Progressbar('pickup', Locales[language]['CONTAINER_HEIST_PROGRESSBAR_PICKUP'], 5000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
            }, {}, {}, {}, function() -- Done

                local containerAmount = math.random(Config.MinContainer, Config.MaxContainer)
                local locationString = ''

                debugMessage('Container amount: ' .. containerAmount)

                while #containers < containerAmount do
                    local container = Config.Container[math.random(1, #Config.Container)]
                    if not table_contains(containers, container) then
                        table.insert(containers, container)
                        locationString = locationString..container.location..'<br/>'
                    end
                end
                debugMessage('Container locations: ' .. locationString)
                createContainerTargets()

                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_LOCATION'], 'primary')
                TriggerServerEvent('it-smallheists:server:sendWebhook', 'Container Heist', 'Player '..GetPlayerName(PlayerId())..' started a container heist for '..containerFee..'$ and get '..#containers.." Containers\nLocations:\n"..locationString, 16711680, false)
                Wait(mailTime)
                sendMail(Locales[language]['CONTAINER_HEIST_MAIL_SENDER'], Locales[language]['CONTAINER_HEIST_MAIL_SUBJECT'], Locales[language]['CONTAINER_HEIST_MAIL_MESSAGE_LOCATION']..locationString)
                startHeistTimer('container', heistTime)

            end, function() -- Cancel
                sendMessage(Locales[language]['UNIVERSAL_NOTIFICATION_CANCELED'], 'error')
            end)
        end, 'cash')
    end, 'container')
end

local function removeAllContainerTargets()
    if containers ~= nil then
        if #containers == 0 then return end
        if not next(containers) then return end
        for k, v in ipairs(containers) do
            debugMessage('Removing container target: ' .. k)
            exports['qb-target']:RemoveZone('container-'..k)
        end
    end
    containers = {}
end

-- Spawn Container Boss Ped
CreateThread(function()

    RequestModel(Config.ContainerBoss.model)
    while not HasModelLoaded(Config.ContainerBoss.model) do
        Wait(0)
    end
    local ped = CreatePed(0, Config.ContainerBoss.model, Config.ContainerBoss.location.x, Config.ContainerBoss.location.y, Config.ContainerBoss.location.z - 1, Config.ContainerBoss.location.w, false, false)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                type = 'client',
                label = Locales[language]['CONTAINER_HEIST_TARGET_START_HEIST']:format(containerFee), -- LANG
                icon = 'fas fa-comment',
                action = function()
                    startContainerHeist()
                end,
            },
        },
        distance = 2.5
    })
    debugMessage('Container Boss Ped spawned')
end)

-- Public funtions
function containerCleanUp()
    removeAllContainerTargets()
    TriggerServerEvent('it-smallheists:server:heistCooldown', 'container')
    activeJob = false
    policeAlert = false
end