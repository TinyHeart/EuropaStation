/*
CONTAINS:
BEDSHEETS
LINEN BINS
*/

/obj/item/bedsheet
	name = "bedsheet"
	desc = "A surprisingly soft linen bedsheet."
	icon = 'icons/obj/items.dmi'
	icon_state = "sheet"
	item_state = "bedsheet"
	randpixel = 0
	slot_flags = SLOT_BACK
	layer = 4.0
	throwforce = 1
	throw_speed = 1
	throw_range = 2
	w_class = 2.0

/obj/item/bedsheet/attack_self(var/mob/user)
	user.drop_item()
	if(layer == initial(layer))
		layer = MOB_LAYER + 0.1
	else
		layer = initial(layer)
	add_fingerprint(user)
	return

/obj/item/bedsheet/attackby(obj/item/I, mob/user)
	if(is_sharp(I))
		user.visible_message("<span class='notice'>\The [user] begins cutting up \the [src] with \a [I].</span>", "<span class='notice'>You begin cutting up \the [src] with \the [I].</span>")
		if(do_after(user, 50, src))
			user << "<span class='notice'>You cut \the [src] into pieces!</span>"
			for(var/i in 1 to rand(2,5))
				new /obj/item/reagent_containers/glass/rag(get_turf(src))
			qdel(src)
		return
	..()

/obj/item/bedsheet/blue
	icon_state = "sheetblue"
	item_state = "sheetblue"

/obj/item/bedsheet/green
	icon_state = "sheetgreen"
	item_state = "sheetgreen"

/obj/item/bedsheet/orange
	icon_state = "sheetorange"
	item_state = "sheetorange"

/obj/item/bedsheet/purple
	icon_state = "sheetpurple"
	item_state = "sheetpurple"

/obj/item/bedsheet/rainbow
	icon_state = "sheetrainbow"
	item_state = "sheetrainbow"

/obj/item/bedsheet/red
	icon_state = "sheetred"
	item_state = "sheetred"

/obj/item/bedsheet/yellow
	icon_state = "sheetyellow"
	item_state = "sheetyellow"

/obj/item/bedsheet/mime
	icon_state = "sheetmime"
	item_state = "sheetmime"

/obj/item/bedsheet/clown
	icon_state = "sheetclown"
	item_state = "sheetclown"

/obj/item/bedsheet/captain
	icon_state = "sheetcaptain"
	item_state = "sheetcaptain"

/obj/item/bedsheet/rd
	icon_state = "sheetrd"
	item_state = "sheetrd"

/obj/item/bedsheet/medical
	icon_state = "sheetmedical"
	item_state = "sheetmedical"

/obj/item/bedsheet/hos
	icon_state = "sheethos"
	item_state = "sheethos"

/obj/item/bedsheet/hop
	icon_state = "sheethop"
	item_state = "sheethop"

/obj/item/bedsheet/ce
	icon_state = "sheetce"
	item_state = "sheetce"

/obj/item/bedsheet/brown
	icon_state = "sheetbrown"
	item_state = "sheetbrown"


/obj/structure/bedsheetbin
	name = "linen bin"
	desc = "A linen bin. It looks rather cosy."
	icon = 'icons/obj/structures/structures.dmi'
	icon_state = "linenbin-full"
	anchored = 1
	var/amount = 20
	var/list/sheets = list()
	var/obj/item/hidden = null


/obj/structure/bedsheetbin/examine(mob/user)
	..(user)

	if(amount < 1)
		user << "There are no bed sheets in the bin."
		return
	if(amount == 1)
		user << "There is one bed sheet in the bin."
		return
	user << "There are [amount] bed sheets in the bin."


/obj/structure/bedsheetbin/update_icon()
	switch(amount)
		if(0)				icon_state = "linenbin-empty"
		if(1 to amount / 2)	icon_state = "linenbin-half"
		else				icon_state = "linenbin-full"


/obj/structure/bedsheetbin/attackby(obj/item/I as obj, var/mob/user)
	if(istype(I, /obj/item/bedsheet))
		user.drop_item()
		I.loc = src
		sheets.Add(I)
		amount++
		user << "<span class='notice'>You put [I] in [src].</span>"
	else if(amount && !hidden && I.w_class < BULKY_ITEM)	//make sure there's sheets to hide it among, make sure nothing else is hidden in there.
		user.drop_item()
		I.loc = src
		hidden = I
		user << "<span class='notice'>You hide [I] among the sheets.</span>"

/obj/structure/bedsheetbin/attack_hand(var/mob/user)
	if(amount >= 1)
		amount--

		var/obj/item/bedsheet/B
		if(sheets.len > 0)
			B = sheets[sheets.len]
			sheets.Remove(B)

		else
			B = new /obj/item/bedsheet(loc)

		B.loc = user.loc
		user.put_in_hands(B)
		user << "<span class='notice'>You take [B] out of [src].</span>"

		if(hidden)
			hidden.loc = user.loc
			user << "<span class='notice'>[hidden] falls out of [B]!</span>"
			hidden = null

	add_fingerprint(user)
