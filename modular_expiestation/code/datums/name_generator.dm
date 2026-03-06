//Generic Sawian name generator
/datum/name_generator/sawian
	var/species_identifier = ""

/datum/name_generator/sawian/build_name()
	var/creature_id = rand(10000, 99999)

	if(species_identifier)
		return "[species_identifier] - [creature_id]"
	else
		return "CRTR - [creature_id]"

/datum/name_generator/sawian/experiment
	species_identifier = "EXP"

/datum/name_generator/sawian/milky
	species_identifier = "MLK"

/datum/name_generator/sawian/orange
	species_identifier = "ORNG"

