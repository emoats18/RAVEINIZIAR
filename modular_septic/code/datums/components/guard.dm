/datum/component/guard
	dupe_mode = COMPONENT_DUPE_UNIQUE

	var/turf/target
	var/obj/item/weapon
	var/mutable_appearance/target_overlay

/datum/component/guard/Destroy(force, silent)
	remove_target_overlay()
	STOP_PROCESSING(SSobj, src)
	if(weapon)
		weapon.guard_ready = FALSE
	return ..()

/datum/component/guard/Initialize(turf/target, obj/item/weapon)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/guarder = parent
	src.target = target
	src.weapon = weapon

	weapon.guard_ready = TRUE
	RegisterSignal(weapon, list(COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED), PROC_REF(cancel))

	guarder.visible_message(span_danger("<b>[guarder]</b> preparing to guard!"), \
		span_danger("I'm preparing to guard!"), ignored_mobs = target)
	apply_target_overlay()

//	guarder.apply_status_effect(STATUS_EFFECT_HOLDUP, guarder)

	var/reachh = weapon.reach
	if(get_dist(guarder, target) > reachh)
		cancel()
	if(get_dist(guarder, weapon) > 0)
		cancel()
	if(!weapon.guard_ready)
		cancel()
	if(!guarder.is_holding(weapon))
		cancel()

	START_PROCESSING(SSobj, src)

/datum/component/guard/process(delta_time = SSGUARD_DT)
	var/mob/living/carbon/human/guarder = parent
	if(guarder.combat_style != CS_GUARD)
		cancel()
	if(locate(/mob/living) in target)
		var/mob/living/enemy = locate(/mob/living) in target
		hitchungus(enemy)

/datum/component/guard/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(check_deescalate))
	RegisterSignal(parent, COMSIG_MOB_SWAP_HANDS, PROC_REF(cancel))
//	RegisterSignal(parent, COMSIG_ATOM_ENTERED, PROC_REF(hitchungus))
	RegisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP), PROC_REF(check_bump))

/datum/component/guard/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(parent, COMSIG_MOB_SWAP_HANDS)
//	UnregisterSignal(parent, COMSIG_ATOM_ENTERED)
	UnregisterSignal(parent, list(COMSIG_LIVING_START_PULL, COMSIG_MOVABLE_BUMP))

/datum/component/guard/proc/check_bump(atom/source, atom/bumper)
	SIGNAL_HANDLER

	var/mob/living/shooter = parent
	if(shooter.combat_mode)
		return
	shooter.visible_message(span_danger("<b>[shooter]</b> bumps at <b>[bumper]</b> and fails guard!"), \
		span_danger("I bump at <b>[bumper]</b> and fail my guard!"), ignored_mobs = bumper)
	to_chat(bumper, span_userdanger("<b>[shooter]</b> bumps at me and fails his guard!"))
	cancel()

/datum/component/guard/proc/check_deescalate()
	SIGNAL_HANDLER

//	if(get_dist(parent, target) > 0)
	cancel()
	return

/datum/component/guard/proc/cancel()
	SIGNAL_HANDLER

	var/mob/living/guarder = parent
	guarder.visible_message(span_danger("<b>[guarder]</b> cancels guarding!"), \
		span_danger("I cancel guarding."), ignored_mobs = target)
	weapon.guard_ready = FALSE

	qdel(src)
	remove_target_overlay()
	STOP_PROCESSING(SSobj, src)

/datum/component/guard/proc/hitchungus(atom/movable/arrived)
	SIGNAL_HANDLER

	if(!isliving(arrived))
		return
	var/mob/living/carbon/human/guarder = parent
	var/mob/living/walker = arrived
	if(istype(walker))
		SET_HARM_INTENT(guarder)
		guarder.ClickOn(walker)
		cancel()

/datum/component/guard/proc/apply_target_overlay()
	SIGNAL_HANDLER

	if(target_overlay)
		target.cut_overlay(target_overlay)
	target_overlay = mutable_appearance('icons/effects/landmarks_static.dmi', "combat", FLOAT_LAYER, POLLUTION_PLANE, 100)
	target.add_overlay(target_overlay)
//	RegisterSignal(target_overlay, COMSIG_ATOM_ENTERED, PROC_REF(hitchungus))

/datum/component/guard/proc/remove_target_overlay()
	SIGNAL_HANDLER

	if(!target_overlay)
		return
	target.cut_overlay(target_overlay)
	target_overlay = null
//	UnregisterSignal(target_overlay, COMSIG_ATOM_ENTERED)
