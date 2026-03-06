

/datum/status_effect/mindwiped
	id = "mindwiped"
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/mindwiped/on_apply()
	. = ..()

	owner.add_client_colour(/datum/client_colour/monochrome/mindwipe)

/datum/status_effect/mindwiped/on_remove() //Successful rehabilitation?
	. = ..()
	owner.remove_client_colour(/datum/client_colour/monochrome/mindwipe)
