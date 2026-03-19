/////////////////////////
/// Medicine Reagents ///
/////////////////////////

/datum/reagent/medicine/braingrow
	name = "Braingrow"
	description = "Braingrow is a powerful medicine that stimulates the rapid regeneration of damaged and missing brain matter, used to treat extensive brain damage. Permit some time for the brain to adjust before taking another dose."

	overdose_threshold = 20

/datum/reagent/medicine/braingrow/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.5 * removed) // ~10 for 20 units. Matches Cas:U


/datum/reagent/medicine/braingrow/overdose_process(mob/living/carbon/C)
	C.apply_status_effect(/datum/status_effect/mindwiped)


// Bloodsaw chems I found while snooping the assets!!!
// I dont think these were ever even used in that game.
/datum/reagent/medicine/heartgrow
	name = "Heartgrow"

	overdose_threshold = 20

/datum/reagent/medicine/heartgrow/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_HEART, -0.5 * removed) // ~10, using braingrow as a reference

/datum/reagent/medicine/lunggrow
	name = "Lunggrow"

	overdose_threshold = 20

/datum/reagent/medicine/lunggrow/affect_blood(mob/living/carbon/C, removed)
	C.adjustOrganLoss(ORGAN_SLOT_LUNGS, -0.5 * removed)
