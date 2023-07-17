#define TIER_ALIEN 2
#define TIER_ADVANCED 1
#define TIER_NORMAL 0

/datum/component/surgical_tool_overlay

/datum/component/surgical_tool_overlay/Initialize()
	.=..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/surgical_tool_overlay/RegisterWithParent()
	.=..()
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS, PROC_REF(update_overlays))

/// Check contents for the overlays
/datum/component/surgical_tool_overlay/proc/update_overlays(atom/my_bag, list/overlays)
	SIGNAL_HANDLER

	var/scalpel_overlay
	var/cautery_overlay
	var/hemostat_overlay
	var/retractor_overlay
	var/drill_overlay
	var/saw_overlay
	var/has_bonesetter = FALSE
	var/has_drapes = FALSE
	var/has_filter = FALSE
	var/has_razor = FALSE
	var/has_tape = FALSE
	var/has_gel = FALSE

	for (var/obj/item/tool in my_bag.contents)
		if (istype(tool, /obj/item/surgical_drapes))
			has_drapes = TRUE
			continue
		if (istype(tool, /obj/item/bonesetter))
			has_bonesetter = TRUE
			continue
		if (istype(tool, /obj/item/blood_filter))
			has_filter = TRUE
			continue
		if (istype(tool, /obj/item/razor))
			has_razor = TRUE
			continue

		if (istype(tool, /obj/item/scalpel))
			if (scalpel_overlay == TIER_ALIEN)
				continue
			if (istype(tool, /obj/item/scalpel/alien))
				scalpel_overlay = TIER_ALIEN
				continue
			if (scalpel_overlay == TIER_ADVANCED)
				continue
			if (istype(tool, /obj/item/scalpel/advanced))
				scalpel_overlay = TIER_ADVANCED
				continue
			scalpel_overlay = TIER_NORMAL
			continue

		if (istype(tool, /obj/item/cautery))
			if (cautery_overlay == TIER_ALIEN)
				continue
			if (istype(tool, /obj/item/cautery/alien))
				cautery_overlay = TIER_ALIEN
				continue
			if (cautery_overlay == TIER_ADVANCED)
				continue
			if (istype(tool, /obj/item/cautery/advanced))
				cautery_overlay = TIER_ADVANCED
				continue
			cautery_overlay = TIER_NORMAL
			continue

		if (istype(tool, /obj/item/hemostat))
			if (hemostat_overlay == TIER_ALIEN)
				continue
			if (istype(tool, /obj/item/hemostat/alien))
				hemostat_overlay = TIER_ALIEN
				continue
			hemostat_overlay = TIER_NORMAL
			continue

		if (istype(tool, /obj/item/retractor))
			if (retractor_overlay == TIER_ALIEN)
				continue
			if (istype(tool, /obj/item/retractor/alien))
				retractor_overlay = TIER_ALIEN
				continue
			if (retractor_overlay == TIER_ADVANCED)
				continue
			if (istype(tool, /obj/item/retractor/advanced))
				retractor_overlay = TIER_ADVANCED
				continue
			retractor_overlay = TIER_NORMAL
			continue

		if (istype(tool, /obj/item/surgicaldrill))
			if (drill_overlay == TIER_ALIEN)
				continue
			if (istype(tool, /obj/item/surgicaldrill/alien))
				drill_overlay = TIER_ALIEN
				continue
			drill_overlay = TIER_NORMAL
			continue

		if (istype(tool, /obj/item/circular_saw))
			if (saw_overlay == TIER_ALIEN)
				continue
			if (istype(tool, /obj/item/circular_saw/alien))
				saw_overlay = TIER_ALIEN
				continue
			saw_overlay = TIER_NORMAL
			continue

	for (var/obj/item/stack in my_bag.contents)
		if(istype(stack, /obj/item/stack/medical/bone_gel))
			has_gel = TRUE
			continue
		if(istype(stack, /obj/item/stack/sticky_tape/surgical))
			has_tape = TRUE
			continue

	if (has_bonesetter)
		overlays |= "bonesetter"
	if (has_drapes)
		overlays |= "drapes"
	if (has_filter)
		overlays |= "filter"
	if (has_razor)
		overlays |= "razor"
	if (has_tape)
		overlays |= "tape"
	if (has_gel)
		overlays |= "gel"
	switch(scalpel_overlay)
		if(TIER_ALIEN)
			overlays += "scalpel_alien"
		if(TIER_ADVANCED)
			overlays += "scalpel_advanced"
		if(TIER_NORMAL)
			overlays += "scalpel_normal"
	switch(cautery_overlay)
		if(TIER_ALIEN)
			overlays += "cautery_alien"
		if(TIER_ADVANCED)
			overlays += "cautery_advanced"
		if(TIER_NORMAL)
			overlays += "cautery_normal"
	switch(hemostat_overlay)
		if(TIER_ALIEN)
			overlays += "hemostat_alien"
		if(TIER_NORMAL)
			overlays += "hemostat_normal"
	switch(retractor_overlay)
		if(TIER_ALIEN)
			overlays += "retractor_alien"
		if(TIER_ADVANCED)
			overlays += "retractor_advanced"
		if(TIER_NORMAL)
			overlays += "retractor_normal"
	switch(drill_overlay)
		if(TIER_ALIEN)
			overlays += "drill_alien"
		if(TIER_NORMAL)
			overlays += "drill_normal"
	switch(saw_overlay)
		if(TIER_ALIEN)
			overlays += "saw_alien"
		if(TIER_NORMAL)
			overlays += "saw_normal"

/datum/component/surgical_tool_overlay/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_UPDATE_OVERLAYS)
	return ..()

#undef TIER_ALIEN
#undef TIER_ADVANCED
#undef TIER_NORMAL
