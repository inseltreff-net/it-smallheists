fx_version 'cerulean'
game 'gta5'

author 'Inseltreff'
description 'A heist script for the QBCore Framework'

version '1.2.6'

shared_scripts {
    -- config files
    'shared/config.lua',
    'shared/heists/*.lua',

    -- local files
    'locales/en.lua',
    'locales/*.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/*.lua'
}

server_scripts {
    'server/version.lua',
    'server/webhook.lua',
    'server/main.lua',
}

dependencies {
    'qb-core',
    'qb-target',
    'PolyZone',
    'ps-ui',
}

lua54 'yes'
usefxv2oal 'yes'