/mob/living/death(gibbed)
	. = ..()
	if(!QDELETED(src))
		update_shock()
	if(.)
		if(client)
			if(deathsound_local)
				SEND_SOUND(client, deathsound_local)
//			SSdroning.kill_loop(client)
//			SSdroning.kill_droning(client)
	close_peeper(src)
	if(HAS_TRAIT(src, TRAIT_FRAGGOT))
		for(var/mob/living/carbon/human/M in range(src))
			if(M != src && (src in view(M)))
//				to_chat(M, span_bobux("Я видел смерть фатала! +10 Каотиков!"))
				SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "[src.real_name]", /datum/mood_event/fraggot/killed)
				if(M.client?.prefs)
					M.client.prefs.adjust_bobux(150, "<span class='bobux'>I saw the death of a Fatal! +150 Kaotiks!</span>")
					M.flash_kaosgain()
/*
	if(iswillet(src))
		if(has_died)
			return
		for(var/mob/living/carbon/human/M in range(7, src))
			if(M != src && (src in view(M)))
				if(!iswillet(M))
					M.client?.prefs?.adjust_bobux(10, "<span class='bobux'>I have seen a death of weak willet! +10 kaotiks!</span>")
*/

/mob/living/revive(full_heal, admin_revive, excess_healing)
	. = ..()
	update_shock()
