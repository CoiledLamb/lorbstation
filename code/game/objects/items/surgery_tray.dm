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
	desc = "The wheels and bottom storage of this medicart have been stowed away, leaving a smaller, but still bulky tray in it's place."
	icon = 'icons/obj/medicart.dmi'
	icon_state = "tray"
	w_class = WEIGHT_CLASS_BULKY

/obj/item/surgery_tray/Initialize(mapload)
	.=..()
	create_storage(storage_type = /datum/storage/medicart)
	PopulateContents()
	AddComponent(/datum/component/surgical_tool_overlay)
	update_appearance()
	AddElement(/datum/element/noisy_movement)

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
