/datum/storage/medicart/New()
	.=..()
	max_total_storage = 30
	max_specific_storage = WEIGHT_CLASS_NORMAL
	max_slots = 14
	set_holdable(list(
				/obj/item/hemostat,
				/obj/item/scalpel,
				/obj/item/retractor,
				/obj/item/circular_saw,
				/obj/item/surgicaldrill,
				/obj/item/cautery,
				/obj/item/bonesetter,
				/obj/item/surgical_drapes,
				/obj/item/clothing/mask/surgical,
				/obj/item/razor,
				/obj/item/blood_filter,
				/obj/item/stack/sticky_tape/surgical,
				/obj/item/stack/medical/bone_gel,
	))

/obj/item/surgery_tray
	name = "surgery tray"
	desc = "A Deforest brand medical cart. It is a folding model, meaning the wheels on the bottom can be retracted and the body used as a tray."
	icon = 'icons/obj/medicart.dmi'
	icon_state = "tray"
	w_class = WEIGHT_CLASS_BULKY
	var/tray_mode = TRUE

/obj/item/surgery_tray/deployed
	icon_state = "medicart"
	tray_mode = FALSE

/obj/item/surgery_tray/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/medicart)
	PopulateContents()
	AddComponent(/datum/component/surgical_tool_overlay)
	set_tray_mode(tray_mode)
	update_appearance(UPDATE_OVERLAYS)
	AddElement(/datum/element/noisy_movement)
	AddElement(/datum/element/drag_pickup)

/obj/item/surgery_tray/proc/PopulateContents()
	var/static/list/items_inside = list(
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/retractor = 1,
		/obj/item/circular_saw = 1,
		/obj/item/surgicaldrill = 1,
		/obj/item/cautery = 1,
		/obj/item/bonesetter = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/clothing/mask/surgical = 1,
		/obj/item/razor = 1,
		/obj/item/blood_filter = 1,
		/obj/item/stack/sticky_tape/surgical = 1,
		/obj/item/stack/medical/bone_gel = 1,
	)
	generate_items_inside(items_inside, src)

///Sets the surgery tray's deployment state. Silent if user is null.
/obj/item/surgery_tray/proc/set_tray_mode(new_mode, mob/user)
	tray_mode = new_mode
	density = !tray_mode

	if(user)
		user.visible_message(span_notice("[user] [tray_mode ? "retracts" : "extends"] [src]'s wheels."), span_notice("You [tray_mode ? "retract" : "extend"] [src]'s wheels."))

	if(tray_mode)
		interaction_flags_item |= INTERACT_ITEM_ATTACK_HAND_PICKUP
		pass_flags |= PASSTABLE
		desc = "The wheels and bottom storage of this medicart have been stowed away, leaving a smaller, but still bulky tray in it's place."
		icon_state = "tray"
	else
		interaction_flags_item &= ~INTERACT_ITEM_ATTACK_HAND_PICKUP
		pass_flags &= ~PASSTABLE
		desc = "A Deforest brand medical cart. It is a folding model, meaning the wheels on the bottom can be retracted and the body used as a tray."
		icon_state = "medicart"
	SEND_SIGNAL(src, COMSIG_SURGERY_TRAY_TOGGLE, tray_mode)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/surgery_tray/equipped(mob/user, slot, initial)
	. = ..()
	if(!tray_mode)
		set_tray_mode(TRUE, user)

/obj/item/surgery_tray/attack_self(mob/user, modifiers)
	. = ..()
	var/turf/open/placement_turf = get_turf(user)
	if(isgroundlessturf(placement_turf) || isclosedturf(placement_turf))
		to_chat(user, span_warning("You can't deploy [src] here!"))
		return
	set_tray_mode(FALSE, user)
	forceMove(placement_turf)
