/datum/action/item_action/organ_action/healthchip_menu
	name = "Open Heath Diagnostics UI"

/datum/action/item_action/organ_action/healthchip_menu/IsAvailable(feedback)
	var/obj/item/organ/cyberimp/brain/healthchip/linked_chip = target
	if(!linked_chip || !linked_chip.enabled)
		return FALSE
	return ..()

