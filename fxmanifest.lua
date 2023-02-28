-------------------------------------------------
-------------- Axio Spikes by Derass ------------
------------- Discord : Derass#4974 -------------
--------- https://discord.gg/HPD35pasA5 ---------
-------------------------------------------------

fx_version	'cerulean'
lua54		'yes'
game		'gta5'

name		'Axio Spike'
author		'derass#4974'
description 'Spike script'
version		'1.1.0'

shared_scripts {
    "@ox_lib/init.lua",
    "config.lua",
}

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    'ox_lib',
    'ox_target'
}

files {
	'locales/*.json'
}

escrow_ignore {
    'client.lua',
    'server.lua',
    'config.lua'
}