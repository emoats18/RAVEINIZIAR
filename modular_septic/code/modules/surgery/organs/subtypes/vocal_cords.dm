/obj/item/organ/vocal_cords //organs that are activated through speech with the :x/MODE_KEY_VOCALCORDS channel
	name = "Vocal Cords"
	icon_state = "appendix"
	zone = BODY_ZONE_PRECISE_MOUTH
	organ_efficiency = list(ORGAN_SLOT_VOICE = 100)
	gender = PLURAL
	min_decay_factor = 0
	max_decay_factor = 0
	healing_factor = 0
	w_class = WEIGHT_CLASS_SMALL

	// a small price to pay for the powers these give
	organ_volume = 1
	max_blood_storage = 10
	current_blood = 10
	blood_req = 2
	oxygen_req = 2.5
	nutriment_req = 2.5

	var/list/spans = null

/obj/item/organ/vocal_cords/proc/can_speak_with() //if there is any limitation to speaking with these cords
	return TRUE

/obj/item/organ/vocal_cords/proc/speak_with(message) //do what the organ does
	return

/obj/item/organ/vocal_cords/proc/handle_speech(message) //actually say the message
	owner.say(message, spans = spans, sanitize = FALSE)

/obj/item/organ/adamantine_resonator
	name = "adamantine resonator"
	desc = "Fragments of adamantine exist in all golems, stemming from their origins as purely magical constructs. These are used to \"hear\" messages from their leaders."
	zone = BODY_ZONE_HEAD
	organ_efficiency = list(ORGAN_SLOT_ADAMANTINE_RESONATOR = 100)
	icon_state = "adamantine_resonator"

/obj/item/organ/vocal_cords/adamantine
	name = "adamantine vocal cords"
	desc = "When adamantine resonates, it causes all nearby pieces of adamantine to resonate as well. Adamantine golems use this to broadcast messages to nearby golems."
	actions_types = list(/datum/action/item_action/organ_action/use/adamantine_vocal_cords)
	icon_state = "adamantine_cords"

/datum/action/item_action/organ_action/use/adamantine_vocal_cords/Trigger()
	if(!IsAvailable())
		return
	var/message = input(owner, "Resonate a message to all nearby golems.", "Resonate")
	if(QDELETED(src) || QDELETED(owner) || !message)
		return
	owner.say(".x[message]")

/obj/item/organ/vocal_cords/adamantine/handle_speech(message)
	var/msg = span_resonate("<span class='name'>[owner.real_name]</span> <span class='message'>resonates, \"[message]\"</span>")
	for(var/m in GLOB.player_list)
		if(iscarbon(m))
			var/mob/living/carbon/C = m
			if(C.getorganslot(ORGAN_SLOT_ADAMANTINE_RESONATOR))
				to_chat(C, msg)
		if(isobserver(m))
			var/link = FOLLOW_LINK(m, owner)
			to_chat(m, "[link] [msg]")

//Colossus drop, forces the listeners to obey certain commands
/obj/item/organ/vocal_cords/colossus
	name = "divine vocal cords"
	desc = "They carry the voice of an ancient god."
	icon_state = "voice_of_god"
	actions_types = list(/datum/action/item_action/organ_action/colossus)
	var/next_command = 0
	var/cooldown_mod = 1
	var/base_multiplier = 1
	spans = list("colossus","yell")

/datum/action/item_action/organ_action/colossus
	name = "Voice of God"
	var/obj/item/organ/vocal_cords/colossus/cords = null

/datum/action/item_action/organ_action/colossus/New()
	. = ..()
	cords = target

/datum/action/item_action/organ_action/colossus/IsAvailable()
	if(world.time < cords.next_command)
		return FALSE
	if(!owner)
		return FALSE
	if(isliving(owner))
		var/mob/living/L = owner
		if(!L.can_speak_vocal())
			return FALSE
	if(check_flags & AB_CHECK_CONSCIOUS)
		if(owner.stat)
			return FALSE
	return TRUE

/datum/action/item_action/organ_action/colossus/Trigger()
	. = ..()
	if(!IsAvailable())
		if(world.time < cords.next_command)
			to_chat(owner, span_notice("You must wait [DisplayTimeText(cords.next_command - world.time)] before Speaking again."))
		return
	var/command = input(owner, "Speak with the Voice of God", "Command")
	if(QDELETED(src) || QDELETED(owner))
		return
	if(!command)
		return
	owner.say(".x[command]")

/obj/item/organ/vocal_cords/colossus/can_speak_with()
	if(world.time < next_command)
		to_chat(owner, span_notice("You must wait [DisplayTimeText(next_command - world.time)] before Speaking again."))
		return FALSE
	if(!owner)
		return FALSE
	if(!owner.can_speak_vocal())
		to_chat(owner, span_warning("You are unable to speak!"))
		return FALSE
	return TRUE

/obj/item/organ/vocal_cords/colossus/handle_speech(message)
	playsound(get_turf(owner), 'sound/magic/clockwork/invoke_general.ogg', 300, TRUE, 5)
	return //voice of god speaks for us

/obj/item/organ/vocal_cords/colossus/speak_with(message)
	var/cooldown = voice_of_god(uppertext(message), owner, spans, base_multiplier)
	next_command = world.time + (cooldown * cooldown_mod)

/obj/item/organ/vocal_cords/halber
	maxHealth = 120
	high_threshold = 110
	low_threshold = 100
