///////////////ANTIBODY SCANNER///////////////

/obj/item/antibody_scanner
	name = "antibody scanner"
	desc = "Scans living beings for antibodies in their blood."
	icon_state = "health"
	w_class = 2.0
	item_state = "electronic"
	flags = CONDUCT

/obj/item/antibody_scanner/attack(var/mob/M, var/mob/user)
	if(!istype(M,/mob/living/carbon/))
		report("Scan aborted: Incompatible target.", user)
		return

	var/mob/living/carbon/C = M
	if (istype(C,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = C
		if(!H.should_have_organ(BP_HEART))
			report("Scan aborted: The target does not have blood.", user)
			return

	if(!C.antibodies.len)
		report("Scan Complete: No antibodies detected.", user)
		return

	report("Antibodies detected: [antigens2string(C.antibodies)]", user)

/obj/item/antibody_scanner/proc/report(var/text, var/mob/user)
	user << "\blue \icon[src] \The [src] beeps, \"[text]\""

///////////////VIRUS DISH///////////////

/obj/item/virusdish
	name = "virus dish"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	var/datum/disease2/disease/virus2 = null
	var/growth = 0
	var/basic_info = null
	var/info = 0
	var/analysed = 0

/obj/item/virusdish/random
	name = "virus sample"

/obj/item/virusdish/random/New()
	..()
	src.virus2 = new /datum/disease2/disease
	src.virus2.makerandom()
	growth = rand(5, 50)

/obj/item/virusdish/attackby(var/obj/item/W,var/mob/living/carbon/user)
	if(istype(W,/obj/item/hand_labeler) || istype(W,/obj/item/reagent_containers/syringe))
		return
	..()
	if(prob(50))
		user << "<span class='danger'>\The [src] shatters!</span>"
		if(virus2.infectionchance > 0)
			for(var/mob/living/carbon/target in view(1, get_turf(src)))
				if(airborne_can_reach(get_turf(src), get_turf(target)))
					infect_virus2(target, src.virus2)
		qdel(src)

/obj/item/virusdish/examine(mob/user)
	..()
	if(basic_info)
		user << "[basic_info] : <a href='?src=\ref[src];info=1'>More Information</a>"

/obj/item/virusdish/Topic(href, href_list)
	. = ..()
	if(.) return 1

	if(href_list["info"])
		usr << browse(info, "window=info_\ref[src]")
		return 1

/obj/item/ruinedvirusdish
	name = "ruined virus sample"
	icon = 'icons/obj/items.dmi'
	icon_state = "implantcase-b"
	desc = "The bacteria in the dish are completely dead."

/obj/item/ruinedvirusdish/attackby(var/obj/item/W,var/mob/living/carbon/user)
	if(istype(W,/obj/item/hand_labeler) || istype(W,/obj/item/reagent_containers/syringe))
		return ..()

	if(prob(50))
		user << "\The [src] shatters!"
		qdel(src)

///////////////GNA DISK///////////////

/obj/item/diseasedisk
	name = "blank GNA disk"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk0"
	w_class = 1
	var/datum/disease2/effectholder/effect = null
	var/list/species = null
	var/stage = 1
	var/analysed = 1

/obj/item/diseasedisk/premade/New()
	name = "blank GNA disk (stage: [stage])"
	effect = new /datum/disease2/effectholder
	effect.effect = new /datum/disease2/effect/invisible
	effect.stage = stage
