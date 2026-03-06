////////////
// OPIODS //
////////////

/datum/reagent/opiod
	name = "opium"
	description = "A relatively mild opiod. Provides body-wide pain relief and slows mental activity."

	color = "#fff387"

	var/opiodpwr = 40

/datum/reagent/opiod/affect_blood(mob/living/carbon/C, removed)
	/*
	if(opiodpwr)

	*/

/datum/reagent/opiod/morphine
	name = "morphine"
	description = ""

	color = "#836644"

	opiodpwr = 90

/datum/reagent/opiod/heroin
	name = "heroin"
	description = ""

	opiodpwr = 130

/datum/reagent/opiod/fentanyl //FENT!!!
	name = "fentanyl"
	description = ""

	color = "#37eaf7"

	opiodpwr = 420
