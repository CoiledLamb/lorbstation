/obj/structure/newspaper_rack
	name = "newspaper rack"
	desc = "A wooden display for showing the latest newspapers and magazines."
	icon_state = "newsrack"
	base_icon_state = "newsrack"
	pass_flags_self = PASSTABLE

/obj/structure/newspaper_rack/preloaded

/obj/structure/newspaper_rack/Initialize(mapload)
	. = ..()
	create_storage(max_slots = 10, max_total_storage = 20, canhold = list(/obj/item/folder, /obj/item/newspaper, /obj/item/paper,))

/obj/structure/newspaper_rack/preloaded/Initialize(mapload)
	. = ..()
	for(var/items in 1 to 10)
		new /obj/item/newspaper(src)
	update_icon_state()

/obj/structure/newspaper_rack/update_icon_state()
	. = ..()
	switch(length(contents))
		if(10)
			icon_state = "[base_icon_state]_f"
		if(6 to 9)
			icon_state = "[base_icon_state]_almostfull"
		if(1 to 5)
			icon_state = "[base_icon_state]_almostempty"
		if(0)
			icon_state = base_icon_state

/obj/structure/newspaper_rack/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	tool.play_tool_sound(src)
	to_chat(user, span_notice("You begin taking apart [src]."))
	if(!tool.use_tool(src, user, 1 SECONDS))
		return
	deconstruct(TRUE)
	to_chat(user, span_notice("[src] has been taken apart."))

/obj/structure/newspaper_rack/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		dump_contents()
		new /obj/item/stack/rods(drop_location(), 2)
		new /obj/item/stack/sheet/mineral/wood(drop_location())
	return ..()
