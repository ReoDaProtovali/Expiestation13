// These guys date back to bloodsaw!
// SAW-02
/datum/species/orange //I swear "orange" is going to cause issues with the inbuilt proc "Orange" which is O-Range.
	name = "\improper Orange"
	plural_form = "Oranges"
	id = SPECIES_ORANGE
	name_generator_type = /datum/name_generator/orange
	species_traits = list(MUTCOLORS, NO_UNDERWEAR)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	skinned_type = /obj/item/stack/sheet/animalhide/orange

	digitigrade_customization = DIGITIGRADE_FORCED
