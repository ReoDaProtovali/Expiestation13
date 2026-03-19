/obj/item/training_radio
	name = "training radio"
	desc = "A small, handheld device used to relay instructions to test subjects."

	var/obj/item/radio/integrated_radio
	var/obj/item/

	var/unscrewed = FALSE

/obj/item/training_radio/Initialize(mapload)
	. = ..()
	integrated_radio = new /obj/item/radio/training_radio_part(src)

/obj/item/training_radio/attack_self(mob/user, modifiers)
	. = ..()



/obj/item/radio/training_radio_part
	name = "training radio communication module"
	desc = "The telecommunication parts of a training radio. Now removed from the device they came from."

	prison_radio = TRUE //You can just enable outbound communcation by putting a wire back? What cheap reuse.

