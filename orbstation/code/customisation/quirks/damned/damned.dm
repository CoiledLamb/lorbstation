/datum/quirk/damned
	name = "Damned"
	desc = "You have angered the gods! You will be set ablaze upon entering the chapel, and other \
	holy things such as holy books, holy water, and the null rod will have adverse effects against you."
	icon = FA_ICON_CLOUD_BOLT
	mob_trait = TRAIT_DAMNED
	value = -3
	gain_text = span_danger("The gods are angry with you!")
	lose_text = span_notice("The gods have forgiven you.")
	medical_record_text = "Patient seems unusually wary around holy people and holy artifacts."
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_PROCESSES
	mail_goodies = list(/obj/item/instrument/violin/golden)

/datum/quirk/damned/add_unique(client/client_source)
	if(!HAS_TRAIT(quirk_holder, TRAIT_UNNATURAL_RED_GLOWY_EYES))
		quirk_holder.AddElement(/datum/element/cult_eyes, initial_delay = 0 SECONDS)

/datum/quirk/damned/remove()
	if(HAS_TRAIT(quirk_holder, TRAIT_UNNATURAL_RED_GLOWY_EYES))
		quirk_holder.RemoveElement(/datum/element/cult_eyes)

/datum/quirk/damned/process(delta_time)
	var/mob/living/carbon/human/human_target = quirk_holder
	if(human_target.stat == DEAD || human_target.dna.species.id == SPECIES_VAMPIRE)
		// Vampires already have the burning effect except stronger, so we don't want to duplicate that here.
		return
	var/area/holder_area = get_area(human_target)
	if(istype(holder_area, /area/station/service/chapel))
		to_chat(human_target, span_warning("The gods reject your presence!"))
		human_target.adjustFireLoss(2 * delta_time)
		human_target.adjust_fire_stacks(3 * delta_time)
		human_target.ignite_mob()
		human_target.apply_status_effect(/datum/status_effect/temporary_damned_halo)

// "Holy weapon" element. Gives the attached item a chance to strike a victim with lightning if they have the "Damned" trait.

#define DEFAULT_LIGHTNING_MESSAGE span_danger("%VICTIM is struck down by a bolt of holy lightning!")

/datum/element/holy_weapon
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Chance of the target being struck by lightning if they have the "Damned" trait.
	var/lightning_chance
	/// Multiplier for the burn damage done by the lightning strike, as defined by LIGHTNING_BOLT_DAMAGE (75). Defaults to 10%, or 7.5 damage.
	var/lightning_damage_multiplier
	/// Message displayed to viewers when the lightning strike procs.
	var/lightning_message

/datum/element/holy_weapon/Attach(datum/target, lightning_chance = 50, lightning_damage_multiplier = 0.10, lightning_message = DEFAULT_LIGHTNING_MESSAGE)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.lightning_chance = lightning_chance
	src.lightning_damage_multiplier = lightning_damage_multiplier
	src.lightning_message = lightning_message
	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))

/datum/element/holy_weapon/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, list(COMSIG_ITEM_ATTACK))

/datum/element/holy_weapon/proc/on_attack(datum/target, mob/living/victim, mob/living/attacker)
	SIGNAL_HANDLER

	if(!HAS_TRAIT(victim, TRAIT_DAMNED) || !prob(lightning_chance) || victim.stat == DEAD)
		return

	lightningbolt(victim, lightning_damage_multiplier)
	var/built_lightning_message = replacetext(lightning_message, "%VICTIM", victim)
	victim.visible_message(built_lightning_message)
	victim.apply_status_effect(/datum/status_effect/temporary_damned_halo)

#undef DEFAULT_LIGHTNING_MESSAGE

/obj/item/nullrod/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/holy_weapon)

// Holy book blessing effect

/obj/item/book/bible/bless(mob/living/L, mob/living/user)
	. = ..()

	if(!ishuman(L))
		return

	var/mob/living/carbon/human/H = L
	if(HAS_TRAIT(H, TRAIT_DAMNED))
		H.visible_message(span_warning("[user] blinds [H] with the power of [deity_name]!"))
		H.adjustFireLoss(5)
		H.adjust_temp_blindness(5 SECONDS)
		H.apply_status_effect(/datum/status_effect/temporary_damned_halo)
		return FALSE

	return

// Holy water effect

/datum/reagent/water/holywater/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume)
	..() // this goes up here because otherwise the water will just extinguish you instantly
	if(HAS_TRAIT(exposed_mob, TRAIT_DAMNED))
		exposed_mob.set_wet_stacks(0)
		exposed_mob.adjust_fire_stacks(3)
		exposed_mob.ignite_mob()
		exposed_mob.apply_status_effect(/datum/status_effect/temporary_damned_halo)

/datum/reagent/water/holywater/on_mob_life(mob/living/carbon/affected_mob, delta_time, times_fired)
	if(HAS_TRAIT(affected_mob, TRAIT_DAMNED))
		affected_mob.set_confusion_if_lower(3 SECONDS)
		affected_mob.adjustFireLoss(0.25*delta_time, 0)
		affected_mob.adjustToxLoss(0.25*delta_time, 0)
		affected_mob.apply_status_effect(/datum/status_effect/temporary_damned_halo)
	return ..()

// Holy explosion effect

/datum/chemical_reaction/reagent_explosion/holyboom/on_reaction(datum/reagents/holder, datum/equilibrium/reaction, created_volume)
	if(created_volume >= 50)
		var/turf/T = get_turf(holder.my_atom)
		var/effective_size = round(created_volume/20)
		for(var/mob/living/carbon/C in get_hearers_in_view(effective_size,T))
			if(HAS_TRAIT(C, TRAIT_DAMNED) && !IS_CULTIST(C))
				to_chat(C, span_userdanger("The divine explosion sears you!"))
				C.set_wet_stacks(0)
				C.adjust_fire_stacks(5)
				C.ignite_mob()
				C.apply_status_effect(/datum/status_effect/temporary_damned_halo)
	return ..()
