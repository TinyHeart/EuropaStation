
/obj/item/encryptionkey
	name = "standard encryption key"
	desc = "An encryption key for a radio headset. Contains cypherkeys."
	icon = 'icons/obj/radio.dmi'
	icon_state = "cypherkey"
	item_state = ""
	w_class = 1
	slot_flags = SLOT_EARS
	var/translate_binary = 0
	var/translate_hive = 0
	var/syndie = 0
	var/list/channels = list()

/obj/item/encryptionkey/attackby(var/obj/item/W, var/mob/user)

/obj/item/encryptionkey/syndicate
	icon_state = "cypherkey"
	channels = list("Mercenary" = 1)

	syndie = 1//Signifies that it de-crypts Syndicate transmissions

/obj/item/encryptionkey/binary
	icon_state = "cypherkey"
	translate_binary = 1


/obj/item/encryptionkey/headset_sec
	name = "security radio encryption key"
	icon_state = "sec_cypherkey"
	channels = list("Security" = 1)

/obj/item/encryptionkey/headset_eng
	name = "engineering radio encryption key"
	icon_state = "eng_cypherkey"
	channels = list("Engineering" = 1)

/obj/item/encryptionkey/headset_rob
	name = "robotics radio encryption key"
	icon_state = "rob_cypherkey"
	channels = list("Engineering" = 1, "Science" = 1)

/obj/item/encryptionkey/headset_med
	name = "medical radio encryption key"
	icon_state = "med_cypherkey"
	channels = list("Medical" = 1)

/obj/item/encryptionkey/headset_sci
	name = "science radio encryption key"
	icon_state = "sci_cypherkey"
	channels = list("Science" = 1)

/obj/item/encryptionkey/headset_medsci
	name = "medical research radio encryption key"
	icon_state = "medsci_cypherkey"
	channels = list("Medical" = 1, "Science" = 1)

/obj/item/encryptionkey/headset_com
	name = "command radio encryption key"
	icon_state = "com_cypherkey"
	channels = list("Command" = 1)

/obj/item/encryptionkey/heads/captain
	name = "colony director's encryption key"
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 0, "Science" = 0, "Medical" = 0, "Supply" = 0, "Service" = 0)

/obj/item/encryptionkey/heads/ai_integrated
	name = "integrated encryption key"
	desc = "Integrated encryption key."
	icon_state = "cap_cypherkey"
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1, "AI Private" = 1)

/obj/item/encryptionkey/heads/rd
	name = "scientist's encryption key"
	icon_state = "rd_cypherkey"
	channels = list("Science" = 1, "Command" = 1)

/obj/item/encryptionkey/heads/hos
	name = "chief of police's encryption key"
	icon_state = "hos_cypherkey"
	channels = list("Security" = 1, "Command" = 1)

/obj/item/encryptionkey/heads/ce
	name = "chief of engineering's encryption key"
	icon_state = "ce_cypherkey"
	channels = list("Engineering" = 1, "Command" = 1)

/obj/item/encryptionkey/heads/cmo
	name = "chief medical officer's encryption key"
	icon_state = "cmo_cypherkey"
	channels = list("Medical" = 1, "Command" = 1)

/obj/item/encryptionkey/heads/hop
	name = "colony liaison's encryption key"
	icon_state = "hop_cypherkey"
	channels = list("Supply" = 1, "Service" = 1, "Command" = 1, "Security" = 0)


/*
/obj/item/encryptionkey/headset_mine
	name = "mining radio encryption key"
	icon_state = "mine_cypherkey"
	channels = list("Mining" = 1)

/obj/item/encryptionkey/heads/qm
	name = "quartermaster's encryption key"
	icon_state = "qm_cypherkey"
	channels = list("Cargo" = 1, "Mining" = 1)
*/
/obj/item/encryptionkey/headset_cargo
	name = "supply radio encryption key"
	icon_state = "cargo_cypherkey"
	channels = list("Supply" = 1)

/obj/item/encryptionkey/headset_service
	name = "service radio encryption key"
	icon_state = "srv_cypherkey"
	channels = list("Service" = 1)

/obj/item/encryptionkey/ert
	name = "\improper ERT radio encryption key"
	channels = list("Response Team" = 1, "Science" = 1, "Command" = 1, "Medical" = 1, "Engineering" = 1, "Security" = 1, "Supply" = 1, "Service" = 1)

/obj/item/encryptionkey/entertainment
	name = "entertainment radio key"
	channels = list("Entertainment" = 1)
