//The one we all come from?

/datum/species/experiment
	name = "\improper Experiment"
	plural_form = "Experiments"
	id = "experiment" //SPECIES_EXPERIMENT
	//name_generator_type =
	species_traits = list(MUTCOLORS, EYECOLOR, NO_UNDERWEAR, HAIRCOLOR, FACEHAIRCOLOR)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	skinned_type = /obj/item/stack/sheet/animalhide/experiment


	cosmetic_organs = list(
		// /obj/item/organ/headspikes = "Plain",
		/obj/item/organ/tail/sawian/experiment = "Default"
	)

	bodypart_overrides = list(
		BODY_ZONE_HEAD = /obj/item/bodypart/head/sawian/experiment,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/sawian/experiment,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/sawian/experiment,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/sawian/experiment,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/sawian/experiment,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/sawian/experiment,
	)
	/*
	robotic_bodyparts = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/robot/surplus/experiment,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/robot/surplus/experiment,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/robot/surplus/experiment,
		BODY_ZONE_R_LEG= /obj/item/bodypart/leg/right/robot/surplus/experiment,
	)
	*/
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/sawian,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/sawian,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/sawian,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/sawian/experiment,
		ORGAN_SLOT_EARS =  /obj/item/organ/ears/sawian,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/sawian/experiment,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/sawian,
		//ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix/sawian,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/sawian,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys/sawian,
	)

/datum/species/experiment/get_scream_sound(mob/living/carbon/human/human)
	return 'modular_expiestation/sound/voice/experiment/death1.ogg'

/datum/species/experiment/get_random_blood_type()
	return GET_BLOOD_REF(/datum/blood/sawian)
