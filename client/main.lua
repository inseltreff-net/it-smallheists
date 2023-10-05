QBCore = exports['qb-core']:GetCoreObject()
activeJob = false
currentCops = 0

-- This is the handler for the cop count, you can change this to anything you want as this is by default the qb-policejob event
RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end

end)

function hasItem(items, amount)
    return QBCore.Functions.HasItem(items, amount)
end

function sendMail(mailSender, mailSubject, mailMessage)
    if Config.PhoneScript == 'qb' then
        TriggerServerEvent('qb-phone:server:sendNewMail', {sender = mailSender, subject = mailSupject,
            message = mailMessage--"Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download that research. <br/> i will email again when i see the firewall is down!" ,
        })
    elseif Config.PhoneScript == 'qs' then
        TriggerServerEvent('qs-smartphone:server:sendNewMail', {sender = mailSender, subject = mailSupject,
            message = mailMessage--"Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download that research. <br/> i will email again when i see the firewall is down!" ,
            button = {}
        })
    elseif Config.PhoneScript == 'road' then
        TriggerServerEvent('roadphone:receiveMail', {sender = mailSender, subject = mailSupject,
            message = mailMessage--"Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download that research. <br/> i will email again when i see the firewall is down!" ,
            image = '/public/html/static/img/icons/app/mail.png',
            button = {}
        })
    elseif Config.PhoneScript == 'gks' then
        TriggerServerEvent('gksphone:NewMail', {sender = mailSender, image = '/html/static/img/icons/mail.png', subject = mailSupject,
        message = mailMessage --"Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download that research. <br/> i will email again when i see the firewall is down!" ,
        button = {}
        })
    else
        QBCore.Functions.Notify(mailMessage, "primary")
    end
end

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end