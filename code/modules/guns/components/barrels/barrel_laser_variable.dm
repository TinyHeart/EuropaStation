/obj/item/gun_component/barrel/laser/variable
	icon_state="las_pistol"
	caliber = "variable"
	weapon_type = GUN_PISTOL
	firemodes = list(
		list(mode_name="stun",   caliber = CALIBER_LASER_TASER),
		list(mode_name="lethal", caliber = CALIBER_LASER),
		)

/obj/item/gun_component/barrel/laser/variable/New()
	..()
	var/list/fmode = firemodes[1]
	caliber = (fmode["caliber"] ? fmode["caliber"] : CALIBER_LASER)

/obj/item/gun_component/barrel/laser/variable/assault
	icon_state="las_assault"
	weapon_type = GUN_ASSAULT

/obj/item/gun_component/barrel/laser/variable/smg
	icon_state="las_smg"
	weapon_type = GUN_SMG
	firemodes = list(
		list(mode_name="stun",                  caliber = CALIBER_LASER_TASER),
		list(mode_name="stun 3-round bursts",   caliber = CALIBER_LASER_SHOCK, burst=3, fire_delay = null, move_delay = 4, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="lethal",                caliber = CALIBER_LASER_WEAK),
		list(mode_name="lethal 3-round bursts", caliber = CALIBER_LASER,       burst=3, fire_delay = null, move_delay = 4, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 1.0)),
		)
