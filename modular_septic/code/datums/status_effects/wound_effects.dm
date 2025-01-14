// The shattered remnants of your broken limbs fill you with determination!
/atom/movable/screen/alert/status_effect/determined
	//This doesn't actually get used tho
	name = "Determined"
	desc = "The serious wounds you've sustained have put your body into fight-or-flight mode! Now's the time to look for an exit!"
	icon_state = "regenerative_core"

/datum/status_effect/determined
	id = "determined"

/datum/status_effect/determined/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod *= WOUND_DETERMINATION_BLEED_MOD

/datum/status_effect/determined/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod /= WOUND_DETERMINATION_BLEED_MOD
	return ..()

/datum/status_effect/limp
	id = "limp"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 10
	alert_type = /atom/movable/screen/alert/status_effect/limp
	var/msg_stage = 0//so you dont get the most intense messages immediately
	/// The left leg of the limping person
	var/obj/item/bodypart/l_leg/left_leg
	/// The right leg of the limping person
	var/obj/item/bodypart/r_leg/right_leg
	/// The left leg of the limping person
	var/obj/item/bodypart/l_foot/left_foot
	/// The right leg of the limping person
	var/obj/item/bodypart/r_foot/right_foot
	/// Which leg/foot we're limping with next
	var/obj/item/bodypart/next_leg
	/// How many deciseconds we limp for on the left leg/foot
	var/slowdown_left = 0
	/// How many deciseconds we limp for on the right leg/foot
	var/slowdown_right = 0

/datum/status_effect/limp/on_apply()
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/C = owner
	left_leg = LAZYACCESS(C.leg_bodyparts, 1)
	right_leg = LAZYACCESS(C.leg_bodyparts, 2)
	left_foot = LAZYACCESS(C.leg_bodyparts, 3)
	right_foot = LAZYACCESS(C.leg_bodyparts, 4)
	update_limp()
	RegisterSignal(C, COMSIG_MOVABLE_MOVED, PROC_REF(check_step))
	RegisterSignal(C, list(COMSIG_CARBON_GAIN_WOUND, COMSIG_CARBON_LOSE_WOUND, COMSIG_CARBON_ATTACH_LIMB, COMSIG_CARBON_REMOVE_LIMB), PROC_REF(update_limp))
	return TRUE

/datum/status_effect/limp/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_CARBON_GAIN_WOUND, COMSIG_CARBON_LOSE_WOUND, COMSIG_CARBON_ATTACH_LIMB, COMSIG_CARBON_REMOVE_LIMB))

/atom/movable/screen/alert/status_effect/limp
	name = "Limping"
	desc = "One or more of your legs has been wounded, slowing down steps with that leg! Get it fixed, or at least in a sling of gauze!"

/datum/status_effect/limp/proc/check_step(mob/whocares, OldLoc, Dir, forced)
	SIGNAL_HANDLER
	if(!owner.client || owner.body_position == LYING_DOWN || !owner.has_gravity() || (owner.movement_type & FLYING) || forced || owner.buckled)
		return

	// less limping while we have determination still
	var/determined_mod = owner.has_status_effect(STATUS_EFFECT_DETERMINED) ? 0.5 : 1
	if(next_leg == left_leg)
		owner.client.move_delay += slowdown_left * determined_mod
		next_leg = right_leg
	else
		owner.client.move_delay += slowdown_right * determined_mod
		next_leg = left_leg

/datum/status_effect/limp/proc/update_limp()
	SIGNAL_HANDLER
	var/mob/living/carbon/C = owner
	left_leg = LAZYACCESS(C.leg_bodyparts, 1)
	right_leg = LAZYACCESS(C.leg_bodyparts, 2)
	left_foot = LAZYACCESS(C.leg_bodyparts, 3)
	right_foot = LAZYACCESS(C.leg_bodyparts, 4)

	if(!left_leg && !right_leg && !left_foot && !right_foot)
		C.remove_status_effect(src)
		return

	slowdown_left = 0
	slowdown_right = 0

	if(left_leg)
		for(var/thing in left_leg.wounds)
			var/datum/wound/W = thing
			slowdown_left += W.limp_slowdown

	if(left_foot)
		for(var/thing in left_foot.wounds)
			var/datum/wound/W = thing
			slowdown_left += W.limp_slowdown

	if(right_leg)
		for(var/thing in right_leg.wounds)
			var/datum/wound/W = thing
			slowdown_right += W.limp_slowdown

	if(right_foot)
		for(var/thing in right_foot.wounds)
			var/datum/wound/W = thing
			slowdown_right += W.limp_slowdown

	// this handles losing your leg with the limp and the other one being in good shape as well
	if(!slowdown_left && !slowdown_right)
		C.remove_status_effect(src)
		return

/////////////////////////
//////// WOUNDS /////////
/////////////////////////
// wound alert
/atom/movable/screen/alert/status_effect/wound
	name = "Wounded"
	desc = "Your body has sustained serious damage, click here to inspect yourself."

/atom/movable/screen/alert/status_effect/wound/Click()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/carbon_owner = owner
	carbon_owner.check_self_for_injuries()

// wound status effect base
/datum/status_effect/wound
	id = "wound"
	status_type = STATUS_EFFECT_MULTIPLE
	var/obj/item/bodypart/linked_limb
	var/datum/wound/linked_wound
	alert_type = NONE

/datum/status_effect/wound/on_creation(mob/living/new_owner, incoming_wound)
	. = ..()
	linked_wound = incoming_wound
	linked_limb = linked_wound.limb

/datum/status_effect/wound/on_remove()
	linked_wound = null
	linked_limb = null
	UnregisterSignal(owner, COMSIG_CARBON_LOSE_WOUND)

/datum/status_effect/wound/on_apply()
	if(!iscarbon(owner))
		return FALSE
	RegisterSignal(owner, COMSIG_CARBON_LOSE_WOUND, PROC_REF(check_remove))
	return TRUE

/// check if the wound getting removed is the wound we're tied to
/datum/status_effect/wound/proc/check_remove(mob/living/L, datum/wound/W)
	SIGNAL_HANDLER
	if(W == linked_wound)
		qdel(src)

// bones
/datum/status_effect/wound/blunt

/datum/status_effect/wound/blunt/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_SWAP_HANDS, PROC_REF(on_swap_hands))
	on_swap_hands()

/datum/status_effect/wound/blunt/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_SWAP_HANDS)
	var/mob/living/carbon/wound_owner = owner
	wound_owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/blunt_wound)

/datum/status_effect/wound/blunt/proc/on_swap_hands()
	SIGNAL_HANDLER
	var/mob/living/carbon/wound_owner = owner
	if(wound_owner.get_active_hand() == linked_limb)
		wound_owner.add_actionspeed_modifier(/datum/actionspeed_modifier/blunt_wound, (linked_wound.interaction_efficiency_penalty - 1))
	else
		wound_owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/blunt_wound)

/datum/status_effect/wound/blunt/nextmove_modifier()
	var/mob/living/carbon/C = owner
	if(C.get_active_hand() == linked_limb)
		return linked_wound.interaction_efficiency_penalty
	return TRUE

// blunt
/datum/status_effect/wound/blunt/moderate
	id = "disjoint"

/datum/status_effect/wound/blunt/severe
	id = "hairline"

/datum/status_effect/wound/blunt/critical
	id = "compound"
