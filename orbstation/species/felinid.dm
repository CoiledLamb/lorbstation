/datum/species/human/felinid
	disliked_food = GROSS | CLOTH | CUCUMBER
	liked_food = SEAFOOD | ORANGES | BUGS | GORE

/datum/species/human/felinid/get_scream_sound(mob/living/carbon/human/human)
	return pick(
		'orbstation/sound/voice/felinid/scream1.ogg',
		'orbstation/sound/voice/felinid/scream2.ogg',
	)

/datum/sprite_accessory/tails/human/cat
	name = "Long Cat"

/datum/sprite_accessory/tails/human/cat/short
	name = "Short Cat"
	icon = 'orbstation/icons/mob/species/felind/bodyparts.dmi'
	icon_state = "cat_short"
