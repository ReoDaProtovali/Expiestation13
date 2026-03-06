

/datum/reagent/mindwipe
	name = "mindwipe"
	description = "A specially synthesized drug which completely wipes the brain of most of its memories and past traumas, \
				leaving only a blank emotionless vessel with basic knowledge and survival instincts. Commonly used as a last resort \
				on subjects that are too far gone to function or are at risk of suicide. The effect is permanent without extensive \
				rehabilitation. Used as a last resort."
	color = ""
	taste_description = "everything fading away"
	taste_mult = 100 //Considering how severely this affects you. You need to taste this

/datum/reagent/mindwipe/affect_blood(mob/living/carbon/C, removed)
	. = ..()
	
