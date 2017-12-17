/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return 1
		return (!mover.density || !density || lying)
	else
		return (!mover.density || !density || lying)
	return

/mob/proc/setMoveCooldown(var/timeout)
	if(client)
		client.move_delay = max(world.time + timeout, client.move_delay)

/client/North()
	..()


/client/South()
	..()


/client/West()
	..()


/client/East()
	..()


/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				usr << "\red This mob type cannot throw items."
			return
		if(NORTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.get_active_hand())
					usr << "\red You have nothing to drop in your hand."
					return
				drop_item()
			else
				usr << "\red This mob type cannot drop items."
			return

//This gets called when you press the delete button.
/client/verb/delete_key_pressed()
	return // TODO REMOVE FROM SKIN

/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		mob:swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob:toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		return mob.drop_item()
	return


/client/Center()
	/* No 3D movement in 2D spessman game. dir 16 is Z Up
	if (isobj(mob.loc))
		var/obj/O = mob.loc
		if (mob.canmove)
			return O.relaymove(mob, 16)
	*/
	return

/atom/movable
	var/self_move = FALSE

//This proc should never be overridden elsewhere at /atom/movable to keep directions sane.
/atom/movable/Move(newloc, direct)
	if (direct & (direct - 1))
		if (direct & 1)
			if (direct & 4)
				if (step(src, NORTH))
					step(src, EAST)
				else
					if (step(src, EAST))
						step(src, NORTH)
			else
				if (direct & 8)
					if (step(src, NORTH))
						step(src, WEST)
					else
						if (step(src, WEST))
							step(src, NORTH)
		else
			if (direct & 2)
				if (direct & 4)
					if (step(src, SOUTH))
						step(src, EAST)
					else
						if (step(src, EAST))
							step(src, SOUTH)
				else
					if (direct & 8)
						if (step(src, SOUTH))
							step(src, WEST)
						else
							if (step(src, WEST))
								step(src, SOUTH)
	else
		var/atom/A = src.loc
		var/olddir = dir //we can't override this without sacrificing the rest of movable/New()

		/*
		if(self_move)
			glide_size = world.icon_size / max(movement_delay(), world.tick_lag) * world.tick_lag
		else
			glide_size = 0
		*/

		. = ..()

		if(direct != olddir)
			dir = olddir
			set_dir(direct)

		src.move_speed = world.time - src.l_move_time
		src.l_move_time = world.time
		src.m_flag = 1
		if ((A != src.loc && A && A.z == src.z))
			src.last_move = get_dir(A, src.loc)

		if(. && bound_overlay)
			// The overlay will handle cleaning itself up on non-openspace turfs.
			bound_overlay.forceMove(get_step(src, UP))
			if (bound_overlay.dir != dir)
				bound_overlay.set_dir(dir)

	return

/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)	return
			mob.control_object.dir = direct
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))
	return


/client/Move(n, direct)
	if(!mob)
		return // Moved here to avoid nullrefs below

	if(mob.control_object)	Move_object(direct)

	if(mob.incorporeal_move && isobserver(mob))
		Process_Incorpmove(direct)
		return

	if(moving)	return 0

	if(world.time < move_delay)	return

	if(locate(/obj/effect/stop/, mob.loc))
		for(var/obj/effect/stop/S in mob.loc)
			if(S.victim == mob)
				return

	if(mob.stat==DEAD && isliving(mob))
		mob.ghostize()
		return

	// handle possible Eye movement
	if(mob.eyeobj)
		return mob.EyeMove(n,direct)

	if(mob.transforming)	return//This is sota the goto stop mobs from moving var

	if(isliving(mob))
		var/mob/living/L = mob
		if(L.incorporeal_move)//Move though walls
			Process_Incorpmove(direct)
			return
		if(mob.client)
			if(mob.client.view != world.view) // If mob moves while zoomed in with device, unzoom them.
				for(var/obj/item/item in mob.contents)
					if(item.zoom)
						item.zoom(mob)
						break

	if(Process_Grab())	return

	if(!mob.canmove)
		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	if(!mob.check_solid_ground())
		var/allowmove = mob.Allow_Spacemove(0)
		if(!allowmove)
			return 0
		else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
			return 0
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and move

	if(isobj(mob.loc) || ismob(mob.loc))//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	if(isturf(mob.loc))

		if(mob.restrained() && LAZYLEN(mob.grabbed_by)) //Why being pulled while cuffed prevents you from moving
			to_chat(src, "<span class='notice'>You're restrained! You can't move!</span>")
			return 0

		if(mob.pinned.len)
			src << "\blue You're pinned to a wall by [mob.pinned[1]]!"
			return 0

		move_delay = world.time + mob.movement_delay()

		if(istype(mob.buckled, /obj/vehicle))
			//manually set move_delay for vehicles so we don't inherit any mob movement penalties
			//specific vehicle move delays are set in code\modules\vehicles\vehicle.dm
			move_delay = world.time
			//drunk driving
			if(mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
				direct = turn(direct, pick(90, -90))
			return mob.buckled.relaymove(mob,direct)

		if(istype(mob.machine, /obj/machinery))
			if(mob.machine.relaymove(mob,direct))
				return

		if(mob.buckled) // Wheelchair driving!
			if(istype(mob.loc, /turf/space))
				return // No wheelchair driving in space
			if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
				if(ishuman(mob))
					var/mob/living/carbon/human/driver = mob
					var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_HAND)
					var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_HAND)
					if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
						return // No hands to drive your chair? Tough luck!
				//drunk wheelchair driving
				else if(mob.confused)
					switch(mob.m_intent)
						if("run")
							if(prob(50))	direct = turn(direct, pick(90, -90))
						if("walk")
							if(prob(25))	direct = turn(direct, pick(90, -90))
				move_delay += 2
				return mob.buckled.relaymove(mob,direct)

		//We are now going to move
		moving = 1

		if(mob.confused)
			switch(mob.m_intent)
				if("run")
					if(prob(75))
						direct = turn(direct, pick(90, -90))
						n = get_step(mob, direct)
				if("walk")
					if(prob(25))
						direct = turn(direct, pick(90, -90))
						n = get_step(mob, direct)

		var/lastloc = mob.loc
		. = mob.SelfMove(n, direct)

		// Grabbing and dragging things.
		if(. && lastloc != mob.loc)
			var/list/grabs = mob.get_grabs()
			if(LAZYLEN(grabs))
				move_delay = max(move_delay, world.time + 4)
				for(var/obj/item/grab/G in grabs)
					if(get_dist(G.affecting.loc, lastloc) == 1)
						step_towards(G.affecting, lastloc)
					if(G && G.affecting)
						if(get_dist(G.affecting.loc, mob.loc) > 1)
							mob.drop_from_inventory(G)
							continue
						if (G.state == GRAB_NECK)
							mob.set_dir(reverse_dir[direct])
						G.adjust_position()

			for (var/obj/item/grab/G in mob.grabbed_by)
				G.adjust_position()

		moving = 0

/mob/proc/SelfMove(turf/n, direct)
	self_move = TRUE
	. = Move(n, direct)
	self_move = FALSE

///Process_Incorpmove
///Called by client/Move()
///Allows mobs to run though walls
/client/proc/Process_Incorpmove(direct)
	var/turf/T = get_step(mob, direct)
	if(mob.check_holy(T))
		mob << "<span class='warning'>You cannot get past holy grounds while you are in this plane of existence!</span>"
		return

	if(T)
		mob.forceMove(T)
	mob.dir = direct

	mob.Post_Incorpmove()
	return 1

/mob/proc/Post_Incorpmove()
	return

// Checks whether this mob is allowed to move in space
// Return 1 for movement, 0 for none,
// -1 to allow movement but with a chance of slipping
/mob/proc/Allow_Spacemove(var/check_drift = 0)
	if(!Check_Dense_Object()) //Nothing to push off of so end here
		return 0

	if(restrained()) //Check to see if we can do things
		return 0

	return -1

//Checks if a mob has solid ground to stand on
//If there's no gravity then there's no up or down so naturally you can't stand on anything.
//For the same reason lattices in space don't count - those are things you grip, presumably.
/mob/proc/check_solid_ground()
	if(istype(loc, /turf/space))
		return 0

	if(!lastarea)
		lastarea = get_area(loc)
	if(lastarea && !lastarea.has_gravity)
		return 0

	return 1

/mob/proc/Check_Dense_Object() //checks for anything to push off or grip in the vicinity. also handles magboots on gravity-less floors tiles

	var/shoegrip = Check_Shoegrip()

	for(var/turf/simulated/T in trange(1,src)) //we only care for non-space turfs
		if(T.density)	//walls work
			return 1
		else
			var/area/A = T.loc
			if(A.has_gravity || shoegrip)
				return 1

	for(var/obj/O in orange(1, src))
		if(istype(O, /obj/structure/lattice))
			return 1
		if(O && O.density && O.anchored)
			return 1

	return 0

/mob/proc/Check_Shoegrip()
	return 0

//return 1 if slipped, 0 otherwise
/mob/proc/handle_spaceslipping()
	if(prob(slip_chance(5)) && !buckled)
		src << "<span class='warning'>You slipped!</span>"
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 1
	return 0

/mob/proc/slip_chance(var/prob_slip = 5)
	if(stat)
		return 0
	if(Check_Shoegrip())
		return 0
	return prob_slip
