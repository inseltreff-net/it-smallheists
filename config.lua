Config = {}

--=== PHONE SETTINGS ===--
Config.PhoneScript = 'qs'
-- qb = qb-phone
-- qs = quasar smartphone
-- road = roadphone
-- gks = gks phone

--=== DEBUG SETTINGS ===--
Config.Debug = false -- Set to true to enable debug mode
Config.DebugPoly = true -- Set to true to enable debug mode for PolyZone

--=== POLICE SETTINGS ===--
Config.PoliceRequired = 0 -- Amount of police required to start the heist
Config.PoliceAlertLab = true -- Set to true to enable police alert for the Lab heist
Config.PoliceAlertMW = true -- Set to true to enable police alert for the MW heist

--=== GENERAL HEIST SETTINGS ===--
Config.HeistCooldownLab = 3600 -- Cooldown in seconds between two Lab heists
Config.HeistCooldownMW = 3600 -- Cooldown in seconds between two MW heists

Config.MoneyType = 'cash' -- cash/bank/black_money - Type of money you get from the heist
Config.MailTime = 10 -- Time in seconds to wait for the mail to arrive

--=== HACKING SETTINGS ===--
Config.HackItem = 'electronickit' -- Item required to start the hacking
Config.HackingTime = 20 -- Time in seconds for hacking progressbars / Time bevore the MiniGame starts

Config.LabHackType = 'numeric' -- can be alphabet, numeric, alphanumeric, greek, braille, runes
Config.LabHackTime = 60 -- Time in seconds to hack the Lab door
Config.BypassHackTime = 60 -- minigame timer for 1 shot to bypass security at secret location to stop guards from spawning inside lab

Config.MWHackType = 'numeric' -- can be alphabet, numeric, alphanumeric, greek, braille, runes
Config.MWHackTime = 60 -- Time in seconds to hack the MW door

--=== LAB RAID STUFF ===--

Config.LabHeistTime = 600 -- Time in seconds to complete the heist

Config.LabBoss = { -- Ped for starting the Lab heist you can change every setting for the ped
    model = 's_m_y_westsec_01',
    location = vector4(2363.2644, 2520.1455, 46.6677, 325.7810),
    scenario = 'WORLD_HUMAN_GUARD_STAND',
}

Config.LabPayment = math.random(100000, 200000) -- Amount of money you get from the heist set this to 0 to disable money reward

Config.LabRewardAmount = math.random(2, 3) -- Amount of items you get from the heist set this to 0 to disable item reward
Config.LabRewards = {
    'weapon_pistol',
    'weapon_pistol_mk2',
}

--== LAB GUARD SETTINGS ==--
Config.LabGuardAccuracy = 75 -- out of 100 how accurate the guards are (100 = 100%)
Config.LabGuardWeapons = { -- this must be the weapon hash not just the weapon item name --this randomises between different guns everytime the guards are spawned
    'WEAPON_PISTOL',
    'WEAPON_COMBATPDW',
}

Config.LabSecurity = {
    ['labpatrol'] = {
        { coords = vector3(3532.46, 3649.46, 27.52), heading = 63.5, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3537.36, 3645.83, 28.13), heading = 46.35, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3546.64, 3642.28, 28.12), heading = 96.74, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3550.22, 3654.24, 28.12), heading = 156.29, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3554.83, 3661.73, 28.12), heading = 21.64, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3557.54, 3674.59, 28.12), heading = 104.25, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3564.64, 3682.23, 28.12), heading = 48.35, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3594.74, 3686.06, 27.62), heading = 124.5, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3593.82, 3712.27, 29.69), heading = 139.73, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3608.93, 3729.39, 29.69), heading = 323.56, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3618.91, 3722.51, 29.69), heading = 85.71, model = 's_m_m_fiboffice_02'},
        { coords = vector3(3596.07, 3703.44, 29.69), heading = 344.89, model = 's_m_m_fiboffice_02'},
    },
}





--=== TRANSLATION ===--
Translation = {
    ['labHeist'] = {
        mail = {
            sender = "Lugo Bervic",
            subject = "Bio Research...",
            messages = {
                heistStart = "Heres the location. You Need to hack the firewall through the computer in laboratory 1 and then download that research. <br/> i will email again when i see the firewall is down!",
                heistHack = "Great you did it! now head to the Cold Room and bring me some samples of their work and any files you see!",
                heistEnd = "Now Bring the Research, Samples and Files back to me for your payment!",
            },
        },
        notifications = {
            noCops = "There currently not enought cops online",
            activeJob = "You are already doing a heist",
            location = "You will be emailed shortly with the location",
            guads = "Guards Alerted!",
            hackFailed = "You failed Hacking, try again",
            noHackingDevice = "You have no Hacking Device",
            cooldown = "The heist is currently on cooldown",
            activeHeist = "Someone is already doing this heist",
            canceled = "Canceled...",
            policeAlert = "Break in at Humane Labs, Laboratory 1!",
            disabledAlarms = "You Successfully Disabled the alarm system, head on in",
            failAlarms = "You Failed to disable the alarm system, the guards have been alerted",
            noTime = "You ran out of time",
        },
        progessBars = {
            pickup = "Getting Job...",
            firewall = "Bypass Firewall",
            download = "Downloading Research",
            files = "Gabbring Samples and Files",
            security = "Bypassing Security Alarms...",
            rerouting = "Rerouting Alarm Checks..",

        },
        blips = {
            lab = "Bio Research Lab",
            research = "Research",
            security = "Security bypass",
        },
        target = {
            startRaidLab = "Start Lab Raid",
            getPayment = "HandOver Research",
            hackReseach = "Hack Research Files",
            samples = "Streal Samples",
            security = "Bypass Security(1 Shot)"
        },
    },
}
