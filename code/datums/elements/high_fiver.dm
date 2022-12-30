/**
 * # High Fiver Element
 *
 * Attach to an item to make it offer a "high five" when offered to people
 */
/datum/element/high_fiver

/datum/element/high_fiver/Attach(datum/target)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	RegisterSignal(target, COMSIG_ITEM_OFFERING, PROC_REF(on_offer))
	RegisterSignal(target, COMSIG_ITEM_OFFER_TAKEN, PROC_REF(on_offer_taken))

/datum/element/high_fiver/Detach(datum/source, ...)
	. = ..()
	UnregisterSignal(source, list(COMSIG_ITEM_OFFERING, COMSIG_ITEM_OFFER_TAKEN))

/// Signal proc for [COMSIG_ITEM_OFFERING] to set up the high-five on offer
/datum/element/high_fiver/proc/on_offer(obj/item/source, mob/living/carbon/offerer)
	SIGNAL_HANDLER

	if(locate(/mob/living/carbon) in orange(1, offerer))
		offerer.visible_message(
			span_notice("[offerer] raises [offerer.p_their()] arm, looking for a high-five!"),
			span_notice("You post up, looking for a high-five!"),
			vision_distance = 2,
		)
		offerer.apply_status_effect(/datum/status_effect/offering, source, /atom/movable/screen/alert/give/highfive)

	else
		offerer.visible_message(
			span_danger("[offerer] raises [offerer.p_their()] arm, looking around for a high-five, but there's no one around!"),
			span_warning("You post up, looking for a high-five, but find no one to accept it..."),
			vision_distance = 4,
		)

	return COMPONENT_OFFER_INTERRUPT

/// Signal proc for [COMSIG_ITEM_OFFER_TAKEN] to continue through with the high-five on take
/datum/element/high_fiver/proc/on_offer_taken(obj/item/source, mob/living/carbon/offerer, mob/living/carbon/taker)
	SIGNAL_HANDLER

	var/open_hands_taker = 0
	var/slappers_giver = 0
	// see how many hands the taker has open for high'ing
	for(var/hand in taker.held_items)
		if(isnull(hand))
			open_hands_taker++

	// see how many hands the offerer is using for high'ing
	for(var/obj/item/slap_check in offerer.held_items)
		if(slap_check.item_flags & HAND_ITEM)
			slappers_giver++

	var/high_ten = (slappers_giver >= 2)
	var/descriptor = "high-[high_ten ? "ten" : "five"]"

	if(open_hands_taker <= 0)
		to_chat(taker, span_warning("You can't [descriptor] [offerer] with no open hands!"))
		taker.add_mood_event(descriptor, /datum/mood_event/high_five_full_hand) // not so successful now!
		return COMPONENT_OFFER_INTERRUPT

	playsound(offerer, 'sound/weapons/slap.ogg', min(50 * slappers_giver, 300), TRUE, 1)
	offerer.mind.add_memory(MEMORY_HIGH_FIVE, list(DETAIL_DEUTERAGONIST = taker, DETAIL_HIGHFIVE_TYPE = descriptor), story_value = STORY_VALUE_OKAY)
	taker.mind.add_memory(MEMORY_HIGH_FIVE, list(DETAIL_DEUTERAGONIST = offerer, DETAIL_HIGHFIVE_TYPE = descriptor), story_value = STORY_VALUE_OKAY)

	if(high_ten)
		to_chat(taker, span_nicegreen("You give high-tenning [offerer] your all!"))
		offerer.visible_message(
			span_notice("[taker] enthusiastically high-tens [offerer]!"),
			span_nicegreen("Wow! You're high-tenned [taker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			ignored_mobs = taker,
		)

		offerer.add_mood_event(descriptor, /datum/mood_event/high_ten)
		taker.add_mood_event(descriptor, /datum/mood_event/high_ten)
	else
		to_chat(taker, span_nicegreen("You high-five [offerer]!"))
		offerer.visible_message(
			span_notice("[taker] high-fives [offerer]!"),
			span_nicegreen("All right! You're high-fived by [taker]!"),
			span_hear("You hear a sickening sound of flesh hitting flesh!"),
			ignored_mobs = taker,
		)

		offerer.add_mood_event(descriptor, /datum/mood_event/high_five)
		taker.add_mood_event(descriptor, /datum/mood_event/high_five)

	return COMPONENT_OFFER_INTERRUPT
