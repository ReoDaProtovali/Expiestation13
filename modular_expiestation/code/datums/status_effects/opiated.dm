/**
 * Opiod dosage effect!
 * The effect you get from an opiod dose, and it's effects from mild pain killing, to repiratory system killing.
 * (Slightly "inpsired" by drunkeness code)
 */

/datum/status_effect/opiated
	id = "opiated"
	status_type = STATUS_EFFECT_REPLACE

	//How much opium is in our system currently?
	var/opiate_dose = 0

/datum/status_effect/opiated/on_creation(mob/living/new_owner, drunk_value = 0)
	. = ..()
	set_opiate_value(drunk_value)

/datum/status_effect/opiated/on_apply()
	RegisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(clear_opiates))
	return TRUE

/datum/status_effect/opiated/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_POST_FULLY_HEAL)

/// Clears all of our current built up opiod dose on signal
/datum/status_effect/opiated/proc/clear_opiates(mob/living/source)
	SIGNAL_HANDLER

	qdel(src)

/// Sets the drunk value to set_to, deleting if the value drops to 0 or lower
/datum/status_effect/opiated/proc/set_opiate_value(set_to)
	if(!isnum(set_to))
		CRASH("[type] - invalid value passed to set_drunk_value. (Got: [set_to])")

	opiate_dose = set_to
	if(opiate_dose <= 0)
		qdel(src)
