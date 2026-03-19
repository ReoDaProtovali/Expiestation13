

/datum/status_effect/mindwiped
	id = "mindwiped"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/alert/status_effect/mindwiped

/datum/status_effect/mindwiped/on_apply()
	if(owner.status_flags & GODMODE) //Messes with too many parts of the wipe-process. Their brain is probably immune to such effects if they're completely impervious anyhow.
		return FALSE
	RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(clear_mindwipe))

	to_chat(owner, span_userdanger("You feel a deep sense of dread rapidly building..."))

	owner.playsound_local(owner, 'modular_expiestation/sound/effects/mindwipe.wav')
	wiping_process(1) //Start the wiping process.
	return TRUE

/datum/status_effect/mindwiped/on_remove() //Successful rehabilitation?
	owner.remove_client_colour(/datum/client_colour/mindwiped)
	return TRUE

//Removes our hollow-ness (self delete) on signal
/datum/status_effect/mindwiped/proc/clear_mindwipe()
	SIGNAL_HANDLER

	qdel(src)

/datum/status_effect/mindwiped/proc/wiping_process(stage)
	if(QDELETED(src)) //We're gone, staph dis.
		return
	if(owner.stat == DEAD) //If we die in the wiping process, just instantly complete it.
		complete_wipe()
		return
	if(stage >= 10) // 10 half-second stages. wiping completes 5 seconds after it starts.
		complete_wipe()
		return

	//Mindwiping is incredibly painful! Atleast it typically comes bundled with morphine. And only lasts a few seconds at worst.
	if(iscarbon(owner))
		owner.apply_pain(5 * stage, ignore_cd = TRUE)

	if(stage >= 6) //Last two seconds keep you down
		owner.incapacitate(2 SECONDS)

	//I cant help but feel like this isnt the right way to do this. -Reo
	addtimer(CALLBACK(src, PROC_REF(wiping_process), stage + 1), 0.5 SECONDS) //Run the next stage in half a second.

/datum/status_effect/mindwiped/proc/complete_wipe()
	owner.add_client_colour(/datum/client_colour/mindwiped)
	owner.Sleeping(60 SECONDS)
	owner.adjustPain(-INFINITY) //No more pain.

/datum/status_effect/mindwiped/get_examine_text()
	//dead people arnt exactly expressive anyhow.
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_FAKEDEATH))
		return null

	// Having your face covered conceals your (lack of) emotions
	if(iscarbon(owner))
		var/mob/living/carbon/carbon_owner = owner
		if(carbon_owner.wear_mask?.flags_inv & HIDEFACE)
			return null
		if(carbon_owner.head?.flags_inv & HIDEFACE)
			return null

	return span_deadsay("[owner.p_they(TRUE)] have a blank, emotionless stare.")

/atom/movable/screen/alert/status_effect/mindwiped //Hollow hud alert
	name = "Hollow"
	desc = ""
	icon = 'expiestation/icons/hud/screen_alert.dmi'
	icon_state = "hollow"
