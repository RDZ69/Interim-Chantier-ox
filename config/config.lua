Config = {}

--- Blip Chantier
Config.Chantier = {x = -511.0418, y = -1001.6915, z = 23.5505} 	
Config.ChantierBlipText = "LSS | Chantier"
Config.ChantierBlipColor = 49
Config.ChantierBlipSprite = 85

Config.Notification = 'ox' -- 'ox' = notification ox_lib 'esx' = Notification de default

Config.priseservice = {
    Coords = vec3(-510.0360, -1001.6890, 23.5505), -- Coordonnée du Target
    PedCoords = vec4(-510.0360, -1001.6890, 22.5505, 94.85975), -- Coordonnée du Ped
    Ped = 's_m_y_construct_02' -- Ped du Boss chantier
}

Config.debris = {
	Ped = 's_m_y_construct_01', -- Coordonnée du Target & Ped
    minMoney = 10, -- Minimum prix par sol netoyer rammaser
    maxMoney = 15, -- Maximum prix par sol netoyer rammaser
}

Config.Soude = {
	Ped = 's_m_y_construct_01', -- Coordonnée du Target & Ped
    minMoney = 10, -- Minimum prix par sol netoyer rammaser
    maxMoney = 15, -- Maximum prix par sol netoyer rammaser
}

Config.Drill = {
	Ped = 's_m_y_construct_01', -- Coordonnée du Target & Ped
    minMoney = 10, -- Minimum prix par sol netoyer rammaser
    maxMoney = 15, -- Maximum prix par sol netoyer rammaser
}

Config.Uniforms = { -- Vettements de prise de service
    Chantier_wear = {
 		male = {
 			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
 			['torso_1'] = 369,   ['torso_2'] = 8,
 			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 40,
 			['pants_1'] = 8,   ['pants_2'] = 3,
 			['shoes_1'] = 7,   ['shoes_2'] = 9,
			['helmet_1'] = 155,  ['helmet_2'] = 1,
			['chain_1'] = 0,    ['chain_2'] = 0,
			['ears_1'] = -1,     ['ears_2'] = 0
        },

 		female = {
 			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
 			['torso_1'] = 27,   ['torso_2'] = 5,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms'] = 0,
			['pants_1'] = 23,   ['pants_2'] = 6,
			['shoes_1'] = 6,   ['shoes_2'] = 0,
 			['helmet_1'] = -1,  ['helmet_2'] = 0,
 			['chain_1'] = 0,    ['chain_2'] = 0,
 			['ears_1'] = -1,     ['ears_2'] = 0	
        },
	},
}