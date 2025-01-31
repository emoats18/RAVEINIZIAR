//Proc for switching between jump, kick and bite
/mob/living/proc/toggle_special_attack(new_attack, silent = FALSE)
	if(!ishuman(src))
		if(!silent)
			to_chat(src, div_infobox(span_warning("I can't do a such things.")))
		return

	if(!new_attack || new_attack == special_attack)
		special_attack = SPECIAL_ATK_NONE
		if(!silent)
			var/message = "<span class='infoplain'><div class='infobox'>"
			message += span_largeinfo("Nothing")
			message += "\n<br><hr class='infohr'>\n"
			message += span_info("Now it's ok.\n(MMB will not perform special actions)")
			message += "</div></span>"
			to_chat(src, message)
	else
		special_attack = new_attack
		if(!silent)
			var/message = "<span class='infoplain'><div class='infobox'>"
			switch(new_attack)
				if(SPECIAL_ATK_KICK)
					message += span_largeinfo("Kick")
					message += "\n<br><hr class='infohr'>\n"
					message += span_info("Now I can kick.\n(MMB for kick)")
				if(SPECIAL_ATK_BITE)
					message += span_largeinfo("Bite")
					message += "\n<br><hr class='infohr'>\n"
					message += span_info("Now I can bite.\n(MMB for bite)")
				if(SPECIAL_ATK_JUMP)
					message += span_largeinfo("Jump")
					message += "\n<br><hr class='infohr'>\n"
					message += span_info("Now I can jump.\n(MMB for jump)")
				if(SPECIAL_ATK_STEAL)
					message += span_largeinfo("Steal")
					message += "\n<br><hr class='infohr'>\n"
					message += span_info("Now I can steal.\n(MMB for steal)")
			message += "</div></span>"
			to_chat(src, message)
