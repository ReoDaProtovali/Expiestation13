/obj/item/organ/cyberimp/brain/healthchip
	name = "health monitor neural interface chip"
	desc = "5G signals directly to yo brainthing"

	slot = ORGAN_SLOT_BRAIN_HEALTHCHIP
	actions_types = list(/datum/action/item_action/organ_action/healthchip_menu)

	var/enabled = FALSE //Needs to be enabled by the scientists
	var/emp_timer //timer ID of the delay before the chip is enabled again, also used to determine if the chip is currently disabled due to an EMP.



/obj/item/organ/cyberimp/brain/healthchip/Initialize(mapload, mob_sprite)
	. = ..()

/obj/item/organ/cyberimp/brain/healthchip/ui_action_click(mob/user, datum/action/item_action/used_action)
	if(!enabled || emp_timer)
		return
	//Open a TGUI once one exists, oops.
	to_chat(user, span_notice("You open your health chip's UI... But one doesnt exist yet!"))


/obj/item/organ/cyberimp/brain/healthchip/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	if(!emp_timer || ((120 SECONDS / severity) < timeleft(emp_timer))) //is there an active EMP timer? If so, will the new EMP have a longer time than the active timer? (because different strengths of EMPs have different times.)
		return
	emp_timer = addtimer(CALLBACK(src, PROC_REF(post_emp_reset)), 120 SECONDS / severity, TIMER_OVERRIDE | TIMER_UNIQUE) //Reset after a delay

/obj/item/organ/cyberimp/brain/healthchip/proc/post_emp_reset()
	emp_timer = null //No more active EMP timer
