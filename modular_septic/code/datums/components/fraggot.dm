//#define FRAGGOTS "[global.config.directory]/fraggots.txt"

/datum/component/fraggot
	/// Annoying fullscreen overlay
//	var/atom/movable/screen/fullscreen/niqqer/niqqerlay

/datum/component/fraggot/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	if(iswillet(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/fraggot/RegisterWithParent()
	var/mob/living/carbon/human/our_fraggot = parent
//	our_fraggot.attributes?.add_diceroll_modifier(/datum/diceroll_modifier/fraggot)

//	for(var/mob/living/carbon/human/human in (GLOB.mob_living_list - our_fraggot))
//		SEND_SIGNAL(human, COMSIG_ADD_MOOD_EVENT, "[our_fraggot.real_name]", /datum/mood_event/fraggot, our_fraggot)

//	for(var/mob/living/carbon/human/human in (GLOB.mob_living_list))
	SEND_SOUND(world, sound('modular_pod/sound/eff/kill_her_now_kill_her_now.ogg', volume = 60))
	to_chat(world, "<span class='warning'><span class='big bold'>[emoji_parse(":fatal:")][our_fraggot.real_name] [our_fraggot.truerole] FATAL! KILL THIS CREATURE![emoji_parse(":chaos:")]</span></span>")
//	RegisterSignal(our_fraggot, COMSIG_PARENT_EXAMINE, .proc/fraggot_examine)
	RegisterSignal(our_fraggot, COMSIG_LIVING_DEATH, PROC_REF(fraggot_died))
//	RegisterSignal(our_fraggot, COMSIG_PARENT_PREQDELETED, PROC_REF(fraggot_deleted))
	ADD_TRAIT(our_fraggot, TRAIT_FRAGGOT, "fraggot")
//	our_fraggot.client?.prefs?.adjust_bobux(-10)
	our_fraggot.client?.prefs?.adjust_bobux(-10, "<span class='bobux'>Fuck, I'm FATAL! -10 Kaotiks!</span>")
	START_PROCESSING(SSfraggots, src)
//	niqqerlay = our_fraggot.overlay_fullscreen("niqqer", /atom/movable/screen/fullscreen/niqqer)

/datum/component/fraggot/UnregisterFromParent()
	var/mob/living/carbon/human/our_fraggot = parent
	STOP_PROCESSING(SSfraggots, src)
	UnregisterSignal(our_fraggot, COMSIG_LIVING_DEATH)
//	UnregisterSignal(our_fraggot, COMSIG_PARENT_PREQDELETED)
//	UnregisterSignal(our_fraggot, COMSIG_PARENT_EXAMINE)
	REMOVE_TRAIT(our_fraggot, TRAIT_FRAGGOT, "fraggot")
//	for(var/mob/living/carbon/human/human in (GLOB.mob_living_list - our_fraggot))
//		SEND_SIGNAL(human, COMSIG_CLEAR_MOOD_EVENT, "[our_fraggot.real_name]")
//	our_fraggot.clear_fullscreen("niqqer")
//	niqqerlay = null

/datum/component/fraggot/proc/fraggot_died(mob/living/carbon/human/our_fraggot)
	SIGNAL_HANDLER

	if(!QDELETED(our_fraggot))
//		our_fraggot.gib()
		to_chat(world, "<span class='warning'><span class='big bold'>[emoji_parse(":fatal:")]FATAL [our_fraggot.real_name] [our_fraggot.truerole] DIED![emoji_parse(":chaos:")]</span></span>")
		SEND_SOUND(world, sound('modular_pod/sound/eff/fataldeath.ogg'))
//		for(var/mob/living/carbon/human/human in (GLOB.mob_living_list - our_fraggot))
//			SEND_SIGNAL(human, COMSIG_CLEAR_MOOD_EVENT, "[our_fraggot.real_name]")
		our_fraggot.gib()
/*
/datum/component/fraggot/proc/fraggot_deleted(mob/living/carbon/human/our_fraggot)
	to_chat(world, "<span class='warning'><span class='big bold'>[emoji_parse(":fatal:")]ФАТАЛ [our_fraggot.real_name] [our_fraggot.truerole] УМЕР![emoji_parse(":chaos:")]</span></span>")
	SEND_SOUND(world, sound('modular_pod/sound/eff/fataldeath.ogg'))
	for(var/mob/living/carbon/human/human in (GLOB.mob_living_list - our_fraggot))
		SEND_SIGNAL(human, COMSIG_CLEAR_MOOD_EVENT, "[our_fraggot.real_name]")

/datum/component/fraggot/proc/fraggot_examine(mob/living/our_fraggot, mob/user, list/examine_text)
	examine_text += span_flashingdanger("[uppertext(our_fraggot.name)] IS A FATAL! [uppertext(our_fraggot.p_they())] MUST BE KILLED!")
	if(user.client)
		SEND_SOUND(user.client, sound('modular_septic/sound/effects/yomai.ogg', FALSE, CHANNEL_LOBBYMUSIC, 100))
*/
/datum/component/fraggot/process(delta_time)
	var/mob/living/carbon/human/our_fraggot = parent
	if(our_fraggot.client)
		var/static/list/fraggot_lines = list(
			"БИГ ЧАНГУС ОЛОЛОЛ!!!", \
			"УГАНДА НАКЛС АХХАХА!", \
			"РЕДДЩИТ!!!!!!", \
			"ЛГБТ!!!", \
			"ГЕЙМИНГ!!!!", \
			"ЛАЙФВЕБ!!!!", \
			"ФАТАЛ!!!", \
			"КАОТИКИ!!!", \
			"СС14!!!", \
			"СС14 ЛОЛ!!!", \
			"АААААААААА БЛЯЯЯЯЯЯЯТЬ!!!!!", \
			"ВКОНТАКТЕ! ВКОНТАКТЕ БЛЯТЬ!!!", \
			"ПИДОРАСЫ!!!!", \
			"СУКИИИИ!!!!", \
			"ПАРОДИЯ НА ЛАЙФВЕБ!!!!", \
			"УЁБКИ СУКА!!!!!", \
		)
		var/message = pick(fraggot_lines)
		if(DT_PROB(8, delta_time))
			to_chat(our_fraggot, span_horny(span_big(message)))
		var/static/list/fraggot_sounds = list(
			'modular_septic/sound/memeshit/pigdeath.ogg',
			'modular_septic/sound/memeshit/naggers.ogg',
			'modular_septic/sound/memeshit/nigger.ogg',
			'modular_septic/sound/memeshit/niggers.ogg',
			'modular_septic/sound/memeshit/nigger_alarm.ogg',
			'modular_septic/sound/memeshit/augh.ogg',
			'modular_septic/sound/memeshit/loudnigra.ogg',
			'modular_septic/sound/memeshit/socialcreditsdeducted.ogg',
			'modular_septic/sound/memeshit/youstupid.ogg',
		)
		if(DT_PROB(8, delta_time))
			our_fraggot.playsound_local(get_turf(our_fraggot), pick(fraggot_sounds), 30)
//			var/sound/annoying = sound(pick(fraggot_sounds), FALSE, 0, CHANNEL_LOBBYMUSIC, 100)
//			SEND_SOUND(our_fraggot.client, annoying)
//		if(DT_PROB(0.25, delta_time))
//			our_fraggot.client.bruh_moment()
	if(DT_PROB(1, delta_time))
		our_fraggot.agony_scream()
	else if(DT_PROB(1, delta_time))
		our_fraggot.death_scream()
	if(ishuman(our_fraggot))
		var/mob/living/carbon/human/human_fraggot = our_fraggot
		if(DT_PROB(5, delta_time))
			human_fraggot.piss(FALSE)
		if(DT_PROB(5, delta_time))
			human_fraggot.shit(FALSE)
		human_fraggot.adjust_lust(250 * delta_time)
