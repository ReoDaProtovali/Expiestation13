// The one we all come from?
// SAW-01
/datum/species/experiment
	name = "\improper Experiment"
	plural_form = "Experiments"
	id = SPECIES_EXPERIMENT
	name_generator_type = /datum/name_generator/sawian/experiment
	species_traits = list(MUTCOLORS, NO_UNDERWEAR)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	skinned_type = /obj/item/stack/sheet/animalhide/experiment

	digitigrade_customization = DIGITIGRADE_FORCED
	/*
	cosmetic_organs = list(
		// /obj/item/organ/headspikes = "Plain",
		// /obj/item/organ/tail/sawian/experiment = "Default"
	)
	*/

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
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix, //Normal appendix?? more likely than you might think.
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/sawian,
		ORGAN_SLOT_KIDNEYS = /obj/item/organ/kidneys/sawian,
	)

	pain_emotes = list(
		list(
			"whines in pain" = 1,
			"whimpers in pain" = 1,
		) = PAIN_AMT_LOW,

		list(
			"pain" = 1,
		) = PAIN_AMT_MEDIUM,

		list(
			"agony" = 1,
		) = PAIN_AMT_AGONIZING,
	)

/datum/species/experiment/get_scream_sound(mob/living/carbon/human/human)
	return pick('modular_expiestation/sound/voice/experiment/death1.ogg',
				'modular_expiestation/sound/voice/experiment/pain1.oog')

/datum/species/experiment/get_deathgasp_sound(mob/living/carbon/human/H)
	return 'modular_expiestation/sound/voice/squeak.wav'

/datum/species/experiment/get_random_blood_type()
	return GET_BLOOD_REF(/datum/blood/sawian)



/// Perks N Shit

/datum/species/experiment/create_pref_blood_perks()
	. = ..()
	if(.) //We have some other blood-oddity
		return
	var/list/to_add = list()

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = "Yellow Blood",
		SPECIES_PERK_DESC = "[plural_form], like all Sawians, have yellow blood. While normal for them, it's odd to most earth species that have red blood. Conversely, red blood is odd to them, and also incompatable for transfusion purposes.",
	))

	return to_add
