//Generic Sawian name generator
/datum/name_generator/sawian
	var/species_identifier = ""

/datum/name_generator/sawian/build_name()
	var/creature_id = rand(10000, 99999)

	if(species_identifier)
		return "[species_identifier] - [creature_id]"
	else
		return "SAW-?? - [creature_id]"

/datum/name_generator/sawian/experiment
	species_identifier = "SAW-01"

/datum/name_generator/sawian/orange
	species_identifier = "SAW-02"

/datum/name_generator/sawian/milky
	species_identifier = "SAW-03"

/datum/name_generator/sawian/leapy
	species_identifier = "SAW-04"

/datum/name_generator/sawian/chompy
	species_identifier = "SAW-05"

/datum/name_generator/sawian/roza
	species_identifier = "SAW-06"

