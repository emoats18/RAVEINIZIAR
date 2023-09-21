//Used to manage sending droning sounds to various clients
SUBSYSTEM_DEF(droning)
	name = "Droning"
	flags = SS_NO_INIT|SS_NO_FIRE
/*
/sound
	var/transition = 0

/sound/proc/Transition(var/mob/M)
	transition = 1
	status = SOUND_UPDATE

	while(volume > 0)
		volume = max(volume - 2, 0)
		M << src
		/////////
		sleep(2.5)
		/////////

//	status = SOUND_STREAM
	transition = 0
*/
/datum/controller/subsystem/droning/proc/area_entered(area/area_entered, client/entering)
	if(!area_entered || !entering)
		return
	if(HAS_TRAIT(entering.mob, TRAIT_LEAN) && !area_entered.droning_sound)
		//just kill the previous droning sound
		kill_droning(entering)
		return
	if(HAS_TRAIT(entering.mob, TRAIT_BLOODARN) && !area_entered.droning_sound)
		//just kill the previous droning sound
		kill_droning(entering)
		return
	var/list/last_droning = list()
	last_droning |= entering.last_droning_sound
	var/list/new_droning = list()
	new_droning |= area_entered.droning_sound
	if(HAS_TRAIT(entering.mob, TRAIT_LEAN))
		new_droning = list('modular_septic/sound/insanity/lean.ogg', 100)
	if(HAS_TRAIT(entering.mob, TRAIT_BLOODARN))
		new_droning = list('modular_pod/sound/mus/radioakt.ogg', 100)
	//Same ambience, don't bother
	if(last_droning ~= new_droning)
		return
	play_area_sound(area_entered, entering)

/datum/controller/subsystem/droning/proc/play_area_sound(area/area_player, client/listener)
	if(!area_player || !listener)
		return
	if(LAZYLEN(area_player.droning_sound))

		if((istype(area_player, /area/maintenance/polovich/forest)) || (istype(area_player, /area/medical/spawned)))
//		if(SSoutdoor_effects.current_step_datum == /datum/time_of_day/midnight || SSoutdoor_effects.current_step_datum == /datum/time_of_day/dusk || SSoutdoor_effects.current_step_datum == /datum/time_of_day/dawn)
//		if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/midnight) || (SSoutdoor_effects.current_step_datum, /datum/time_of_day/dusk) || (SSoutdoor_effects.current_step_datum, /datum/time_of_day/dawn))
/*
			if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/midnight))
				area_player.droning_sound = DRONING_PURENIGHT
			else if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/night))
				area_player.droning_sound = DRONING_PURENIGHT
			else if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/dusk))
				area_player.droning_sound = DRONING_PURENIGHT
			else if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/dawn))
				area_player.droning_sound = DRONING_PURENIGHT
			else if(istype(SSoutdoor_effects.current_step_datum, /datum/time_of_day/dawndawn))
				area_player.droning_sound = DRONING_PURENIGHT
			else
				area_player.droning_sound = DRONING_FOREST
*/

			if(isnight(SSoutdoor_effects.current_step_datum))
				area_player.droning_sound = DRONING_PURENIGHT
			else
				area_player.droning_sound = DRONING_FOREST

		if(istype(area_player, /area/maintenance/polovich/village))
			if(isnight(SSoutdoor_effects.current_step_datum))
				area_player.droning_sound = DRONING_PURENIGHT_AKT
			else
				area_player.droning_sound = DRONING_AKT

		//kill the previous droning sound
		kill_droning(listener)
		var/sound/droning = sound(pick(area_player.droning_sound), area_player.droning_repeat, area_player.droning_wait, area_player.droning_channel, area_player.droning_volume)
		if(HAS_TRAIT(listener.mob, TRAIT_LEAN))
			droning.file = 'modular_septic/sound/insanity/lean.ogg'
		if(HAS_TRAIT(listener.mob, TRAIT_BLOODARN))
			droning.file = 'modular_pod/sound/mus/radioakt.ogg'
		SEND_SOUND(listener, droning)
		listener.droning_sound = droning
		listener.last_droning_sound = area_player.droning_sound

/datum/controller/subsystem/droning/proc/play_combat_music(music = null, client/dreamer)
	if(!music || !dreamer)
		return
	if(HAS_TRAIT(dreamer.mob, TRAIT_LEAN))
		return
	if(HAS_TRAIT(dreamer.mob, TRAIT_BLOODARN))
		return
	//kill the previous droning sound
	kill_droning(dreamer)
	var/sound/combat_music = sound(pick(music), repeat = TRUE, wait = 0, channel = CHANNEL_BUZZ, volume = 65)
	SEND_SOUND(dreamer, combat_music)
	dreamer.droning_sound = combat_music
	dreamer.last_droning_sound = combat_music.file

/datum/controller/subsystem/droning/proc/kill_droning(client/victim)
	if(!victim?.droning_sound)
		return
	var/sound/sound_killer = sound()
	sound_killer.channel = victim.droning_sound.channel
	SEND_SOUND(victim, sound_killer)
	victim.droning_sound = null
	victim.last_droning_sound = null

/*
/datum/controller/subsystem/droning/proc/transition(client/victim)
	if(!victim?.droning_sound)
		return
	var/sound/sound_trans = sound()
	sound_trans.channel = victim.droning_sound.channel
//	SEND_SOUND(victim, sound_killer)
//	victim.droning_sound = null
//	victim.last_droning_sound = null

	while(sound_trans.volume > 0)
		sound_trans.volume = max(sound_trans.volume - 2, 0)
		SEND_SOUND(victim, sound_trans)
		sleep(2.5)
*/
/datum/controller/subsystem/droning/proc/stop_droning(client/victim)
	if(!victim?.droning_sound)
		return
	var/sound/sound_stopper = sound()
	sound_stopper.channel = victim.droning_sound.channel
	victim.droning_sound.volume = 0
	victim.droning_sound.status = SOUND_UPDATE
