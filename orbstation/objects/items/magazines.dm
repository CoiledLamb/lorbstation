/**
 * Small books that give a mood bonus to the reader, slightly higher than normal books.
 * 
 * They're not granters in the traditional sense (no knowledge or spells learned here, although they do give a moodlet) 
 * but the stuff set up by the granter superclass is useful here -- progress bars, effect performed when you finish, no real content, etc.
 */
/obj/item/book/granter/magazine
	name = "\improper magazine"
	starting_title = "\improper magazine" // initial name of this magazine -- mostly used for reread prevention.
	icon = 'orbstation/icons/obj/magazine.dmi'
	icon_state ="magazine"
	worn_icon_state = "magazine"
	desc = "A glossy magazine, full of advertisements, gossip, pictures, and maybe a few articles crammed between all that."
	attack_verb_continuous = list("slaps", "whacks", "thwaps")
	attack_verb_simple = list("slap", "whack", "thwap")
	
	unique = TRUE

	uses = INFINITY // we dont care how many times the magazine is read, just whether this specific person has done so.
	pages_to_mastery = 1

	drop_sound = 'sound/items/handling/paper_drop.ogg'
	pickup_sound = 'sound/items/handling/paper_pickup.ogg'

	var/mood_boost = 2

	var/list/emote_pool = list() // random emotes (as strings) to trigger while reading. 
	// see also the list "remarks" from the superclass (a list of phrases to show the reader)
	var/emote_chance = 100 // chance to emote every time you turn a page. note that this is in PERCENT, not 0-1.

/// Called when the user starts to read the magazine.
/obj/item/book/granter/magazine/on_reading_start(mob/living/user)
	user.visible_message(span_notice("[user] starts flipping through \the [name]."), span_notice("You start flipping through \the [name]."))

/// Called when the user completes the magazine.
/obj/item/book/granter/magazine/on_reading_finished(mob/living/user)
	to_chat(user, span_notice("You finish reading \the [name]!"))

	// copied from book/on_read()
	LAZYINITLIST(user.mind?.book_titles_read)
	var/has_not_read_book = isnull(user.mind?.book_titles_read[starting_title])

	// any new magazines give bonus mood
	if(has_not_read_book)
		// TODO: if a user reads two magazines in short succession, they will only recieve mood boost from one
		// but be locked out of both.
		// fix this.
		user.add_mood_event(starting_title, /datum/mood_event/magazine, src)
		user.mind?.book_titles_read[starting_title] = TRUE
		return TRUE
	
	return FALSE

/obj/item/book/granter/magazine/turn_page(mob/living/user)
	. = ..() // super plays page turn sound, checks if interruption occurs, and displays remarks to user
	if (. && length(emote_pool) && prob(emote_chance))
		user.emote(pick(emote_pool))

/// Display a message if they've already read it.
/obj/item/book/granter/magazine/recoil(mob/living/user)
	to_chat(user, span_warning("You think you've read enough of \the [name] for now."))

///////////////////////////////////////// Mood Boost /////////////////////////////////////////


/datum/mood_event/magazine
	description = "That magazine was really interesting."
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/magazine/add_effects(obj/item/book/granter/magazine/target_mag)
	description = "\The [target_mag.name] was really interesting."
	mood_change = target_mag.mood_boost


///////////////////////////////////////// Kinds of magazine /////////////////////////////////////////


/obj/item/book/granter/magazine/mothboy
	name = "Mothboys Monthly"
	starting_title = "Mothboys Monthly"
	icon_state = "mothboys"
	desc = "A saucy rag full of exposed exoskeletons, fluffy tails, and bashful antennae."
	emote_pool = list("blush")

/obj/item/book/granter/magazine/gal_geo
	name = "Galactic Geographic"
	starting_title = "Galactic Geographic"
	icon_state = "gal_geo"
	desc = "An informative publication on the flora, fauna, and peoples of the galaxy. Features large and beautiful pictures by expert photographers."

/obj/item/book/granter/magazine/pop_sci
	name = "Popular R&D"
	starting_title = "Popular R&D"
	icon_state = "pop_sci"
	desc = "A magazine focused on recent discoveries in science and engineering, written for the layman. \
			Apparently flying cars are only 20 years away, \"for real this time\"."

/obj/item/book/granter/magazine/cooking
	name = "Nanny Trasen's Kitchen"
	starting_title = "Nanny Trasen's Kitchen"
	icon_state = "cooking"
	desc = "A magazine focused on the wonders of baking."
	var/possible_spawns = list(
			/obj/item/reagent_containers/condiment/sugar, 
			/obj/item/reagent_containers/condiment/flour,
			/obj/item/reagent_containers/condiment/milk,
			/obj/item/food/cookie,
			/obj/item/food/cake/birthday,
			/obj/item/food/cake/chocolate,
			/obj/item/food/pie/cream,
		)

/obj/item/book/granter/magazine/cooking/on_reading_finished(mob/living/user)
	var/is_new_to_reader = ..()

	if (is_new_to_reader)
		var/reward_type = pick(possible_spawns)
		var/obj/item/reward_instance = new reward_type(get_turf(src))
		to_chat(user, span_notice("Huh? A [reward_instance.name] fell out! How did that get in there?"))
