/*
All ShuttleMove procs go here
*/

/************************************Base procs************************************/

// Called on every turf in the shuttle region, returns a bitflag for allowed movements of that turf
// returns the new move_mode (based on the old)
/turf/proc/fromShuttleMove(turf/newT, move_mode)
	if(!(move_mode & MOVE_AREA) || !isshuttleturf(src))
		return move_mode

	return move_mode | MOVE_TURF | MOVE_CONTENTS

// Called from the new turf before anything has been moved
// Only gets called if fromShuttleMove returns true first
// returns the new move_mode (based on the old)
/turf/proc/toShuttleMove(turf/oldT, move_mode, obj/docking_port/mobile/shuttle)
	. = move_mode
	if(!(. & MOVE_TURF))
		return

	var/shuttle_dir = shuttle.dir
	for(var/i in contents)
		var/atom/movable/thing = i
		if(ismob(thing))
			if(isliving(thing))
				var/mob/living/M = thing
				if(M.buckled)
					M.buckled.unbuckle_mob(M, 1)
				M.release_all_grabs()
				M.visible_message(span_warning("[shuttle] slams into [M]!"))
				SSblackbox.record_feedback("tally", "shuttle_gib", 1, M.type)
				log_attack("[key_name(M)] was shuttle gibbed by [shuttle].")
				M.gib()


		else //non-living mobs shouldn't be affected by shuttles, which is why this is an else
			if(istype(thing, /obj/singularity) || istype(thing, /obj/energy_ball))
				continue
			if(!thing.anchored)
				step(thing, shuttle_dir)
			else
				qdel(thing)

/// This proc is called on all moving atoms, before onShuttleMove() is called.
/turf/proc/beforeShuttleMove(turf/newT, list/movement_force, move_dir)
	return

// Called on the old turf to move the turf data
/turf/proc/onShuttleMove(turf/newT, list/movement_force, move_dir)
	if(newT == src) // In case of in place shuttle rotation shenanigans.
		return
	// Destination turf changes.
	// Baseturfs is definitely a list or this proc wouldnt be called.
	var/shuttle_boundary = baseturfs.Find(/turf/baseturf_skipover/shuttle)

	if(!shuttle_boundary)
		CRASH("A turf queued to move via shuttle somehow had no skipover in baseturfs. [src]([type]):[loc]")
	var/depth = baseturfs.len - shuttle_boundary + 1
	newT.CopyOnTop(src, 1, depth, TRUE)
	newT.blocks_air = TRUE
	//newT.air_update_turf(TRUE, FALSE)
	blocks_air = TRUE
	//air_update_turf(TRUE, TRUE)
	if(isopenturf(newT))
		var/turf/open/new_open = newT
		new_open.copy_air_with_tile(src)
	SEND_SIGNAL(src, COMSIG_TURF_ON_SHUTTLE_MOVE, newT)

	return TRUE

// Called on the new turf after everything has been moved
/turf/proc/afterShuttleMove(turf/oldT, rotation)
	//Dealing with the turf we left behind
	oldT.TransferComponents(src)

	var/shuttle_boundary = baseturfs.Find(/turf/baseturf_skipover/shuttle)

	if(shuttle_boundary)
		oldT.ScrapeAway(baseturfs.len - shuttle_boundary + 1)

	if(rotation)
		shuttleRotate(rotation, ALL) //see shuttle_rotate.dm

	return TRUE

/turf/proc/lateShuttleMove(turf/oldT)
	blocks_air = initial(blocks_air)
	//air_update_turf(TRUE, blocks_air)
	oldT.blocks_air = initial(oldT.blocks_air)
	//oldT.air_update_turf(TRUE, oldT.blocks_air)


/////////////////////////////////////////////////////////////////////////////////////

// Called on every area and movable (NOT turfs!) within a shuttle's rectangular bounding box.
// It does not mean the atom is actually within the shuttle.
// Returns the new move_mode (based on the old)
// WARNING: Do not leave turf contents in hypotheticalShuttleMove or dock() will runtime
/atom/movable/proc/hypotheticalShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	return move_mode

/// This proc is called on all moving atoms, before ANYTHING has moved. Movement will occur immediately following.
/atom/movable/proc/beforeShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, rotation)
	return

/// Called on atoms to move the atom to the new location
/atom/movable/proc/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(newT == oldT) // In case of in place shuttle rotation shenanigans.
		return

	if(loc != oldT) // This is for multi tile objects
		return

	abstract_move(newT)

	return TRUE

// Called on atoms after everything has been moved
/atom/movable/proc/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	var/turf/newT = get_turf(src)
	if (newT.z != oldT.z)
		on_changed_z_level(oldT, newT)

	if(light)
		update_light()

	if(rotation)
		shuttleRotate(rotation, ALL)

	return TRUE

/atom/movable/proc/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	if(!movement_force || anchored)
		return
	var/throw_force = movement_force["THROW"]
	if(!throw_force)
		return
	var/turf/target = get_edge_target_turf(src, move_dir)
	var/range = throw_force * 10
	range = CEILING(rand(range-(range*0.1), range+(range*0.1)), 10)/10
	var/speed = range/5
	safe_throw_at(target, range, speed, force = MOVE_FORCE_EXTREMELY_STRONG)

/////////////////////////////////////////////////////////////////////////////////////

// Called on every area and movable (NOT turfs!) within a shuttle's rectangular bounding box. It does not mean the atom is actually within the shuttle.
// Returns the initial move_mode.
/area/proc/hypotheticalShuttleMove(list/shuttle_areas)
	if(shuttle_areas[src])
		return MOVE_AREA
	return NONE

/// This proc is called on all moving atoms, before onShuttleMove() is called.
/area/proc/beforeShuttleMove(turf/oldT, turf/newT, area/underlying_old_area)
	return

// Called on areas to move their turf between areas
/area/proc/onShuttleMove(turf/oldT, turf/newT, area/underlying_old_area)
	if(newT == oldT) // In case of in place shuttle rotation shenanigans.
		return TRUE

	oldT.change_area(src, underlying_old_area)
	//The old turf has now been given back to the area that turf originaly belonged to

	var/area/old_dest_area = newT.loc
	parallax_movedir = old_dest_area.parallax_movedir
	newT.change_area(old_dest_area, src)

	return TRUE

// Called on areas after everything has been moved
/area/proc/afterShuttleMove(new_parallax_dir)
	parallax_movedir = new_parallax_dir
	return TRUE

/area/proc/lateShuttleMove()
	return

/************************************Turf move procs************************************/

/************************************Area move procs************************************/

/************************************Machinery move procs************************************/

/obj/machinery/door/airlock/beforeShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, rotation)
	. = ..()
	var/area/my_area = get_area(src)

	// This would be way, way easier if shuttle doors were their own type or were in some other way distinguishable from normal doors.
	var/is_spacebound_airlock = FALSE
	for(var/turf/T as anything in get_adjacent_open_turfs(src))
		if(T.loc != my_area)
			is_spacebound_airlock = TRUE
			break

	for(var/obj/machinery/door/airlock/other_airlock in orange(2, src))  //extended because some escape pods have 1 plating turf exposed to space
		other_airlock.shuttledocked = FALSE
		other_airlock.air_tight = TRUE

		// Handle non-shuttle airlocks closing too.
		if(get_area(other_airlock) != my_area)
			spawn(-1)
				other_airlock.close(FALSE, TRUE)

	// Close external airlocks.
	if(is_spacebound_airlock)
		air_tight = TRUE
		shuttledocked = FALSE
		spawn(-1)
			close(FALSE, TRUE)
			if(moving_dock.bolt_doors)
				bolt()

/obj/machinery/door/airlock/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	. = ..()
	// Unbolt airlocks at the destination.
	if(istype(old_dock, /obj/docking_port/stationary/transit) && locked && moving_dock.bolt_doors)
		for(var/obj/machinery/door/airlock/other_airlock in orange(1, src))
			if(get_area(other_airlock) != get_area(src))
				unbolt()
				break

/obj/machinery/door/airlock/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	var/current_area = get_area(src)
	for(var/obj/machinery/door/airlock/other_airlock in orange(2, src))  // does not include src, extended because some escape pods have 1 plating turf exposed to space
		if(get_area(other_airlock) != current_area)  // does not include double-wide airlocks unless actually docked
			// Cycle linking is only disabled if we are actually adjacent to another airlock
			shuttledocked = TRUE
			other_airlock.shuttledocked = TRUE

/obj/machinery/camera/hypotheticalShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/machinery/camera/beforeShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, rotation)
	. = ..()
	GLOB.cameranet.removeCamera(src)

/obj/machinery/camera/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	GLOB.cameranet.addCamera(src)

/obj/machinery/mech_bay_recharge_port/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir)
	. = ..()
	recharging_turf = get_step(loc, dir)

/obj/machinery/computer/auxiliary_base/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if(is_mining_level(z)) //Avoids double logging and landing on other Z-levels due to badminnery
		SSblackbox.record_feedback("associative", "colonies_dropped", 1, list("x" = x, "y" = y, "z" = z))

/obj/machinery/atmospherics/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()

	if(pipe_vision_img)
		pipe_vision_img.loc = loc

	var/missing_nodes = FALSE
	for(var/i in 1 to device_type)
		if(nodes[i])
			var/obj/machinery/atmospherics/node = nodes[i]
			var/connected = FALSE
			for(var/D in GLOB.cardinals)
				if(node in get_step(src, D))
					connected = TRUE
					break

			if(!connected)
				nullify_node(i)

		if(!nodes[i])
			missing_nodes = TRUE

	if(missing_nodes)
		atmos_init()
		for(var/obj/machinery/atmospherics/A in pipeline_expansion())
			A.atmos_init()
			if(A.return_pipenet())
				A.add_member(src)
		SSairmachines.add_to_rebuild_queue(src)
	else
		// atmos_init() calls update_appearance(), so we don't need to call it
		update_appearance()

/obj/machinery/navbeacon/beforeShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, rotation)
	. = ..()
	GLOB.navbeacons["[z]"] -= src
	GLOB.deliverybeacons -= src

/obj/machinery/navbeacon/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()

	if(codes["patrol"])
		if(!GLOB.navbeacons["[z]"])
			GLOB.navbeacons["[z]"] = list()
		GLOB.navbeacons["[z]"] += src //Register with the patrol list!
	if(codes["delivery"])
		GLOB.deliverybeacons += src
		GLOB.deliverybeacontags += location

/************************************Item move procs************************************/

/obj/item/storage/pod/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	// If the pod was launched, the storage will always open. The reserved_level check
	// ignores the movement of the shuttle from the transit level to
	// the station as it is loaded in.
	if (oldT && !is_reserved_level(oldT.z))
		unlocked = TRUE

/************************************Mob move procs************************************/

/mob/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(!move_on_shuttle)
		return
	. = ..()

/mob/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	if(!move_on_shuttle)
		return
	. = ..()
	if(client && movement_force)
		var/shake_force = max(movement_force["THROW"], movement_force["KNOCKDOWN"])
		if(buckled)
			shake_force *= 0.25
		shake_camera(src, shake_force, 1)

/mob/living/lateShuttleMove(turf/oldT, list/movement_force, move_dir)
	if(buckled)
		return

	. = ..()

	var/knockdown = movement_force["KNOCKDOWN"]
	if(knockdown)
		Paralyze(knockdown)


/mob/living/simple_animal/hostile/megafauna/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	. = ..()
	message_admins("Megafauna [src] [ADMIN_FLW(src)] moved via shuttle from [ADMIN_COORDJMP(oldT)] to [ADMIN_COORDJMP(loc)]")

/************************************Structure move procs************************************/

/obj/structure/grille/hypotheticalShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/structure/lattice/hypotheticalShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/structure/cable/beforeShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, rotation)
	. = ..()
	cut_cable_from_powernet(FALSE)
	var/clockwise_rotation_amount = round(rotation / 90)
	rotate_clockwise_amount(clockwise_rotation_amount)

/obj/structure/cable/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	propagate_if_no_network()

/obj/structure/shuttle/hypotheticalShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(. & MOVE_AREA)
		. |= MOVE_CONTENTS

/obj/structure/ladder/beforeShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock, rotation)
	. = ..()
	if (!(resistance_flags & INDESTRUCTIBLE))
		disconnect()

/obj/structure/ladder/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	if (!(resistance_flags & INDESTRUCTIBLE))
		LateInitialize()

/obj/structure/ladder/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if (resistance_flags & INDESTRUCTIBLE)
		// simply don't be moved
		return FALSE
	return ..()

/************************************Misc move procs************************************/

/obj/docking_port/mobile/hypotheticalShuttleMove(turf/newT, rotation, move_mode, obj/docking_port/mobile/moving_dock)
	. = ..()
	if(moving_dock == src)
		. |= MOVE_CONTENTS

// Never move the stationary docking port, otherwise things get WEIRD
/obj/docking_port/stationary/onShuttleMove()
	return FALSE

// Special movable stationary port, for your mothership shenanigans
/obj/docking_port/stationary/movable/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	if(!moving_dock.can_move_docking_ports || old_dock == src)
		return FALSE

	if(newT == oldT) // In case of in place shuttle rotation shenanigans.
		return

	if(loc != oldT) // This is for multi tile objects
		return

	abstract_move(newT)

	return TRUE

/obj/docking_port/stationary/public_mining_dock/onShuttleMove(turf/newT, turf/oldT, list/movement_force, move_dir, obj/docking_port/stationary/old_dock, obj/docking_port/mobile/moving_dock)
	id = "mining_public" //It will not move with the base, but will become enabled as a docking point.
