/obj/item/grab/proc/strangle()
	//Wtf?
	if(!grasped_part)
		return FALSE
	//You can't strangle yourself!
	if(owner == victim)
		return FALSE
	for(var/obj/item/grab/other_grab in owner.held_items)
		if(other_grab == src)
			continue
		//You can't double strangle, sorry!
		else if(other_grab.active && (other_grab.grab_mode == GM_STRANGLE))
			to_chat(owner, span_danger("Я уже душу [victim]!"))
			return FALSE
		//Due to shitcode reasons, i cannot support strangling and taking down simultaneously
		else if(other_grab.active && (other_grab.grab_mode == GM_TAKEDOWN))
			to_chat(owner, span_danger("Я слишком сосредоточен на прижатии!"))
			return FALSE
	active = !active
	if(!active)
		owner.setGrabState(GRAB_AGGRESSIVE)
		owner.set_pull_offsets(victim, owner.grab_state)
		victim.sound_hint()
		victim.visible_message(span_danger("<b>[owner]</b> перестаёт душить <b>[victim]</b>!"), \
						span_userdanger("<b>[owner]</b> перестаёт душить меня!"), \
						vision_distance = COMBAT_MESSAGE_RANGE, \
						ignored_mobs = owner)
	else
		to_chat(owner, span_danger("Я перестаю душить <b>[victim]</b>!"))
		owner.setGrabState(GRAB_KILL)
		owner.set_pull_offsets(victim, owner.grab_state)
		victim.visible_message(span_danger("<b>[owner]</b> начинает душить <b>[victim]</b>!"), \
						span_userdanger("<b>[owner]</b> начинает душить меня!"), \
						vision_distance = COMBAT_MESSAGE_RANGE, \
						ignored_mobs = owner)
		to_chat(owner, span_userdanger("Я начинаю душить <b>[victim]</b>!"))
		victim.adjustOxyLoss(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH))
		actions_done++
	grab_hud?.update_appearance()
	owner.changeNext_move(CLICK_CD_STRANGLE)
	owner.sound_hint()
	owner.adjustFatigueLoss(5)
	playsound(victim, 'modular_septic/sound/attack/twist.ogg', 75, FALSE)
	return TRUE

/obj/item/grab/proc/takedown()
	//Wtf?
	if(!grasped_part)
		return FALSE
	//You can't takedown yourself!
	if(owner == victim)
		return FALSE
	for(var/obj/item/grab/other_grab in owner.held_items)
		if(other_grab == src)
			continue
		//Only one hand can be the master of puppets!
		else if(other_grab.active  && (other_grab.grab_mode == GM_TAKEDOWN) )
			to_chat(owner, span_danger("Я уже прижимаю [victim]!"))
			return FALSE
		//Due to shitcode reasons, i cannot support strangling and taking down simultaneously
		else if(other_grab.active && (other_grab.grab_mode == GM_STRANGLE))
			to_chat(owner, span_danger("Я слишком сосредоточен на удушьи!"))
			return FALSE
	if(active)
		active = FALSE
		owner.setGrabState(GRAB_AGGRESSIVE)
		owner.set_pull_offsets(victim, owner.grab_state)
		victim.visible_message(span_danger("<b>[owner]</b> перестаёт прижимать <b>[victim]</b>!"), \
						span_userdanger("<b>[owner]</b> перестаёт прижимать меня!"), \
						vision_distance = COMBAT_MESSAGE_RANGE, \
						ignored_mobs = owner)
		to_chat(owner, span_userdanger("Я перестаю прижимать <b>[victim]</b>!"))
	else
		var/valid_takedown = (victim.body_position == LYING_DOWN)
		for(var/obj/item/grab/other_grab in owner.held_items)
			if(other_grab == src)
				continue
			if((other_grab.grab_mode in list(GM_TEAROFF, GM_WRENCH)) && other_grab.actions_done)
				valid_takedown = TRUE
		//We need to do a lil' wrenching first! (Or the guy must be lying down)
		if(!valid_takedown)
			to_chat(owner, span_danger("Мне нужно подчинить больше!"))
			return FALSE
		active = TRUE
		owner.setGrabState(GRAB_NECK) //don't take GRAB_NECK literally
		owner.set_pull_offsets(victim, owner.grab_state)
		victim.visible_message(span_danger("<b>[owner]</b> начинает прижимать <b>[victim]</b>!"), \
						span_userdanger("<b>[owner]</b> начинает прижимать меня!"), \
						vision_distance = COMBAT_MESSAGE_RANGE, \
						ignored_mobs = owner)
		to_chat(owner, span_userdanger("Я начинаю прижимать <b>[victim]</b>!"))
		victim.CombatKnockdown((GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)/2) SECONDS)
		victim.sound_hint()
		actions_done++
	grab_hud?.update_appearance()
	owner.changeNext_move(CLICK_CD_TAKEDOWN)
	owner.adjustFatigueLoss(5)
	playsound(victim, 'modular_septic/sound/attack/twist.ogg', 75, FALSE)
	return TRUE

/obj/item/grab/proc/wrench_limb()
	//God damn fucking simple mobs
	if(!grasped_part)
		return FALSE
	if(IS_HELP_INTENT(owner, null) && grasped_part.is_dislocated())
		if(DOING_INTERACTION_WITH_TARGET(owner, victim))
			return FALSE
		return relocate_limb()
	var/mob/living/carbon/carbon_victim = victim
	var/nonlethal = (!owner.combat_mode && (actions_done <= 0))
	var/epic_success = DICE_FAILURE
	var/modifier = 0
	if(victim.combat_mode && (GET_MOB_ATTRIBUTE_VALUE(victim, STAT_STRENGTH) > GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)))
		modifier -= 2
	epic_success = owner.diceroll(GET_MOB_SKILL_VALUE(owner, SKILL_WRESTLING)+modifier, context = DICE_CONTEXT_PHYSICAL)
	if(owner == victim)
		epic_success = max(epic_success, DICE_SUCCESS)
	if(epic_success >= DICE_SUCCESS)
		var/wrench_verb = "выкручивает"
		var/wrench_verb_dayn = "выкручиваю"
		if(nonlethal)
			wrench_verb = "крутит"
			wrench_verb_dayn = "кручу"
			owner.changeNext_move(CLICK_CD_WRENCH)
		var/damageee = GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)
		var/deal_wound_bonus = 5
		if(epic_success >= DICE_CRIT_SUCCESS)
			deal_wound_bonus += 5
		if(!nonlethal)
			owner.changeNext_move(CLICK_CD_STRANGLE)
			var/diceroll = owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)+2, context = DICE_CONTEXT_PHYSICAL)
			if(diceroll >= DICE_SUCCESS)
				if(!grasped_part.no_bone())
					if(!grasped_part.is_fractured())
						grasped_part.force_wound_upwards(/datum/wound/blunt/severe)
			if(diceroll <= DICE_FAILURE)
				victim.apply_damage(damageee, BRUTE, grasped_part, wound_bonus = deal_wound_bonus, sharpness = NONE)
//				grasped_part.receive_damage(brute = damage, wound_bonus = deal_wound_bonus, sharpness = NONE)
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> [wrench_verb] <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("<b>[owner]</b> [wrench_verb] [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я [wrench_verb_dayn] <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> [wrench_verb] [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("Я [wrench_verb_dayn] [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
		playsound(victim, 'modular_septic/sound/attack/twist.ogg', 75, FALSE)
		SEND_SIGNAL(carbon_victim, COMSIG_CARBON_CLEAR_WOUND_MESSAGE)
		actions_done++
	else
		var/wrench_verb_singular = "выкрутить"
		var/damagee = (GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)/2)
		victim.apply_damage(damagee, BRUTE, grasped_part, wound_bonus = 1, sharpness = NONE)
		if(nonlethal)
			wrench_verb_singular = "крутить"
			owner.changeNext_move(CLICK_CD_WRENCH)
		else
			owner.changeNext_move(CLICK_CD_STRANGLE)
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> пытается [wrench_verb_singular] <b>[victim]</b> [grasped_part.name]!"), \
							span_userdanger("<b>[owner]</b> пытается [wrench_verb_singular] [grasped_part.name]!"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я пытаюсь [wrench_verb_singular] <b>[victim]</b> [grasped_part.name]!"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> пытается [wrench_verb_singular] [grasped_part.name]!"), \
							span_userdanger("Я пытаюсь [wrench_verb_singular] [grasped_part.name]!"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
	if(victim != owner)
		victim.sound_hint()
	owner.adjustFatigueLoss(5)
	return TRUE

/obj/item/grab/proc/relocate_limb()
	var/mob/living/carbon/carbon_victim = victim
	if(owner != victim)
		victim.visible_message(span_danger("<b>[owner]</b> пытается вправить <b>[victim]</b> [grasped_part.name]!"), \
						span_userdanger("<b>[owner]</b> пытается вправить [grasped_part.name]!"), \
						vision_distance = COMBAT_MESSAGE_RANGE, \
						ignored_mobs = owner)
		to_chat(owner, span_userdanger("Я пытаюсь вправить <b>[victim]</b> [grasped_part.name]!"))
	else
		victim.visible_message(span_danger("<b>[owner]</b> пытается вправить [grasped_part.name]!"), \
						span_userdanger("Я пытаюсь вправить [grasped_part.name]!"), \
						vision_distance = COMBAT_MESSAGE_RANGE)
	var/time = 12 SECONDS //Worst case scenario
	time -= (GET_MOB_SKILL_VALUE(owner, SKILL_MEDICINE) * 0.75 SECONDS)
	if(!do_mob(owner, carbon_victim, time))
		to_chat(owner, span_userdanger("Я должен стоять смирно!"))
		return
	var/epic_success = DICE_FAILURE
	if(grasped_part.status == BODYPART_ORGANIC)
		epic_success = owner.diceroll(GET_MOB_SKILL_VALUE(owner, SKILL_MEDICINE), context = DICE_CONTEXT_PHYSICAL)
	else
		epic_success = owner.diceroll(GET_MOB_SKILL_VALUE(owner, SKILL_ELECTRONICS), context = DICE_CONTEXT_PHYSICAL)
	if(epic_success >= DICE_FAILURE)
		var/damage = GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)/2
		victim.apply_damage(damage, BRUTE, grasped_part, sharpness = NONE)
//		grasped_part.receive_damage(brute = damage, sharpness = NONE)
		for(var/obj/item/organ/bone/bone as anything in grasped_part.getorganslotlist(ORGAN_SLOT_BONE))
			if(bone.bone_flags & BONE_JOINTED)
				bone.relocate()
		victim.agony_scream()
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> вправляет <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("<b>[owner]</b> вправляет [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я вправляю <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> вправляет [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("Я вправляю [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
		SEND_SIGNAL(carbon_victim, COMSIG_CARBON_CLEAR_WOUND_MESSAGE)
	else
		var/damage = GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)
		var/deal_wound_bonus = 5
		if(epic_success <= DICE_CRIT_FAILURE)
			deal_wound_bonus += 5
		victim.apply_damage(damage, BRUTE, grasped_part, wound_bonus = deal_wound_bonus, sharpness = NONE)
//		grasped_part.receive_damage(brute = damage, wound_bonus = deal_wound_bonus, sharpness = NONE)
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> болезненно крутит <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("<b>[owner]</b> болезненно крутит [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я болезненно кручу <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> болезненно крутит [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("Я болезненно кручу [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
		SEND_SIGNAL(carbon_victim, COMSIG_CARBON_CLEAR_WOUND_MESSAGE)
	if(owner != victim)
		victim.sound_hint()
	owner.sound_hint()
	owner.changeNext_move(CLICK_CD_WRENCH)
	owner.adjustFatigueLoss(5)
	playsound(victim, 'modular_septic/sound/attack/twist.ogg', 75, FALSE)
	return TRUE

/obj/item/grab/proc/tear_off_limb()
	//God damn fucking simple mobs
	if(!grasped_part)
		return FALSE
	for(var/obj/item/organ/bone/bone in grasped_part)
		if(!(bone.damage >= bone.medium_threshold))
			return FALSE
	var/epic_success = owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH), context = DICE_CONTEXT_PHYSICAL)
	if(epic_success >= DICE_SUCCESS)
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> вырывает <b>[victim]</b> [grasped_part.name]!"), \
							span_userdanger("<b>[owner]</b> вырывает [grasped_part.name]!"), \
							span_hear("Я слышу ужасный звук плоти."), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я вырываю <b>[victim]</b> [grasped_part.name]!"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> вырывает [grasped_part.name]!"), \
							span_userdanger("Я вырываю [grasped_part.name]!"), \
							span_hear("Я слышу ужасный звук плоти."), \
							vision_distance = COMBAT_MESSAGE_RANGE)
		var/mob/living/victim_will_get_nulled = victim
		var/mob/living/carbon/owner_will_get_nulled = owner
		var/obj/item/bodypart/part_will_get_nulled = grasped_part
		grasped_part.drop_limb(FALSE, TRUE, FALSE, FALSE, WOUND_SLASH)
		//If nothing went bad, we should be qdeleted by now
		owner_will_get_nulled.adjustFatigueLoss(5)
		owner_will_get_nulled.changeNext_move(CLICK_CD_WRENCH)
		playsound(victim_will_get_nulled, 'modular_septic/sound/gore/tear.ogg', 100, FALSE)
		if(QDELETED(part_will_get_nulled))
			return TRUE
		owner_will_get_nulled.put_in_hands(part_will_get_nulled)
		return TRUE
	return wrench_limb()

/obj/item/grab/proc/tear_off_gut()
	//God damn fucking simple mobs
	if(!grasped_part)
		return FALSE
	var/datum/component/rope/gut_rope
	var/obj/item/organ/roped_organ
	for(var/datum/component/rope/possible_rope as anything in victim.GetComponents(/datum/component/rope))
		roped_organ = possible_rope.roped
		if(istype(roped_organ) && (ORGAN_SLOT_INTESTINES in roped_organ.organ_efficiency))
			gut_rope = possible_rope
			break
	//No guts?
	if(!gut_rope)
		update_grab_mode()
		return FALSE
	if(owner != victim)
		victim.visible_message(span_danger("<b>[owner]</b> вырывает <b>[victim]</b> [roped_organ.name]!"), \
						span_userdanger("<b>[owner]</b> вырывает [roped_organ.name]!"), \
						span_hear("Я слышу ужасный звук плоти."), \
						vision_distance = COMBAT_MESSAGE_RANGE, \
						ignored_mobs = owner)
		to_chat(owner, span_userdanger("Я вырываю <b>[victim]</b> [roped_organ.name]!"))
	else
		victim.visible_message(span_danger("<b>[owner]</b> вырывает [roped_organ.name]!"), \
						span_userdanger("Я вырываю [roped_organ.name]!"), \
						span_hear("Я слышу ужасный звук плоти."), \
						vision_distance = COMBAT_MESSAGE_RANGE)
	var/mob/living/carbon/carbon_victim = victim
	owner.adjustFatigueLoss(5)
	owner.changeNext_move(CLICK_CD_WRENCH)
	playsound(victim, 'modular_pod/sound/eff/outshit.ogg', 80, FALSE)
	qdel(gut_rope)
	carbon_victim.gut_cut()
	update_grab_mode()
	return TRUE

/obj/item/grab/proc/bite_limb()
	//God damn fucking simple mobs
	if(!grasped_part)
		return FALSE
	var/mob/living/carbon/carbon_victim = victim
	var/epic_success = DICE_FAILURE
	var/modifier = 0
	if(victim.combat_mode && (GET_MOB_ATTRIBUTE_VALUE(victim, STAT_STRENGTH) > GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)))
		modifier -= 2
	epic_success = owner.diceroll(GET_MOB_SKILL_VALUE(owner, SKILL_WRESTLING)+modifier, context = DICE_CONTEXT_PHYSICAL)
	if(owner == victim)
		epic_success = max(epic_success, DICE_SUCCESS)
	if(epic_success >= DICE_SUCCESS)
		var/damage = GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)
		var/deal_wound_bonus = 5
		if(epic_success >= DICE_CRIT_SUCCESS)
			deal_wound_bonus += 5
		victim.apply_damage(damage, BRUTE, grasped_part, wound_bonus = deal_wound_bonus, sharpness = owner.dna.species.bite_sharpness)
//		grasped_part.receive_damage(brute = damage, wound_bonus = deal_wound_bonus, sharpness = owner.dna.species.bite_sharpness)
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> кусает <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("<b>[owner]</b> кусает [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я кусаю <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> кусает [grasped_part.name]![carbon_victim.wound_message]"), \
							span_userdanger("Я кусаю [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
		SEND_SIGNAL(carbon_victim, COMSIG_CARBON_CLEAR_WOUND_MESSAGE)
		actions_done++
	else
		if(owner != victim)
			victim.visible_message(span_danger("<b>[owner]</b> пытается укусить <b>[victim]</b> [grasped_part.name]!"), \
							span_userdanger("<b>[owner]</b> пытается укусить [grasped_part.name]!"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_userdanger("Я пытаюсь укусить <b>[victim]</b> [grasped_part.name]!"))
		else
			victim.visible_message(span_danger("<b>[owner]</b> пытается укусить [grasped_part.name]!"), \
							span_userdanger("Я пытаюсь укусить [grasped_part.name]!"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
	owner.changeNext_move(CLICK_CD_BITE)
	owner.adjustFatigueLoss(5)
	playsound(victim, owner.dna.species.bite_sound, 75, FALSE)
	return TRUE

/obj/item/grab/proc/twist_embedded()
	//Wtf?
	if(!grasped_part || !LAZYACCESS(grasped_part.embedded_objects, 1))
		return FALSE
	var/mob/living/carbon/carbon_victim = victim
	var/epic_success = DICE_FAILURE
	var/modifier = 0
	if(victim.combat_mode && (GET_MOB_ATTRIBUTE_VALUE(victim, STAT_ENDURANCE) > GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)))
		modifier -= 2
	epic_success = owner.diceroll(GET_MOB_SKILL_VALUE(owner, SKILL_WRESTLING)+modifier, context = DICE_CONTEXT_PHYSICAL)
	if(owner == victim)
		epic_success = max(epic_success, DICE_SUCCESS)
	if(epic_success >= DICE_SUCCESS)
		var/damagea = GET_MOB_ATTRIBUTE_VALUE(owner, STAT_STRENGTH)
		var/deal_wound_bonus = 5
		if(epic_success >= DICE_SUCCESS)
			deal_wound_bonus += 5
		victim.apply_damage(damagea, BRUTE, grasped_part, wound_bonus = deal_wound_bonus, sharpness = SHARP_POINTY)
//		grasped_part.receive_damage(brute = damage, wound_bonus = deal_wound_bonus, sharpness = SHARP_POINTY)
		if(owner != victim)
			victim.visible_message(span_pinkdang("[owner] крутит [grasped_part.embedded_objects[1]] в [victim] [grasped_part.name]![carbon_victim.wound_message]"), \
							span_pinkdang("[owner] крутит [grasped_part.embedded_objects[1]] в [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_pinkdang("Я кручу [grasped_part.embedded_objects[1]] в <b>[victim]</b> [grasped_part.name]![carbon_victim.wound_message]"))
		else
			victim.visible_message(span_pinkdang("[owner] крутит [grasped_part.embedded_objects[1]] в [grasped_part.name]![carbon_victim.wound_message]"), \
							span_pinkdang("Я кручу [grasped_part.embedded_objects[1]] в [grasped_part.name]![carbon_victim.wound_message]"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
		SEND_SIGNAL(carbon_victim, COMSIG_CARBON_CLEAR_WOUND_MESSAGE)
		actions_done++
	else
		victim.apply_damage(3, BRUTE, grasped_part, wound_bonus = 2, sharpness = SHARP_POINTY)
//		grasped_part.receive_damage(brute = 3, wound_bonus = 2, sharpness = SHARP_POINTY)
		if(owner != victim)
			victim.visible_message(span_pinkdang("[owner] пытается крутить [grasped_part.embedded_objects[1]] в [victim] [grasped_part.name]!"), \
							span_pinkdang("[owner] пытается крутить [grasped_part.embedded_objects[1]] в [grasped_part.name]!"), \
							vision_distance = COMBAT_MESSAGE_RANGE, \
							ignored_mobs = owner)
			to_chat(owner, span_pinkdang("Я пытаюсь крутить [grasped_part.embedded_objects[1]] в [victim] [grasped_part.name]!"))
		else
			victim.visible_message(span_pinkdang("[owner] пытается крутить [grasped_part.embedded_objects[1]] в [grasped_part.name]!"), \
							span_pinkdang("Я пытаюсь крутить [grasped_part.embedded_objects[1]] в [grasped_part.name]!"), \
							vision_distance = COMBAT_MESSAGE_RANGE)
	grasped_part.add_pain(15)
	owner.changeNext_move(CLICK_CD_CLING)
	owner.adjustFatigueLoss(10)
	playsound(victim, 'modular_septic/sound/gore/twisting.ogg', 80, FALSE)
	return TRUE

/obj/item/grab/proc/pull_embedded()
	//Wtf?
	if(!grasped_part || !LAZYACCESS(grasped_part.embedded_objects, 1))
		return FALSE
	SEND_SIGNAL(victim, COMSIG_CARBON_EMBED_RIP, grasped_part.embedded_objects[1], grasped_part, owner)
//	qdel(active_grab)
	return TRUE
