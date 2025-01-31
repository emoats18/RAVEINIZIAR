/**
 * # Fluff structure
 *
 * Fluff structures serve no purpose and exist only for enriching the environment. By default, they can be deconstructed with a wrench.
 */
/obj/structure/fluff
	name = "fluff structure"
	desc = "Fluffier than a sheep. This shouldn't exist."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "minibar"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	///If true, the structure can be deconstructed into a metal sheet with a wrench.
	var/deconstructible = TRUE

/obj/structure/fluff/attackby(obj/item/I, mob/living/user, params)
	if(I.tool_behaviour == TOOL_WRENCH && deconstructible)
		user.visible_message(span_notice("[user] starts disassembling [src]..."), span_notice("You start disassembling [src]..."))
		I.play_tool_sound(src)
		if(I.use_tool(src, user, 50))
			user.visible_message(span_notice("[user] disassembles [src]!"), span_notice("You break down [src] into scrap metal."))
			playsound(user, 'sound/items/deconstruct.ogg', 50, TRUE)
//			new/obj/item/stack/sheet/iron(drop_location())
			qdel(src)
		return
	..()
/**
 * Empty terrariums are created when a preserved terrarium in a lavaland seed vault is activated.
 */
/obj/structure/fluff/empty_terrarium
	name = "empty terrarium"
	desc = "An ancient machine that seems to be used for storing plant matter. Its hatch is ajar."
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "terrarium_open"
	density = TRUE
/**
 * Empty sleepers are created by a good few ghost roles in lavaland.
 */
/obj/structure/fluff/empty_sleeper
	name = "empty sleeper"
	desc = "An open sleeper. It looks as though it would be awaiting another patient, were it not broken."
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper-open"

/obj/structure/fluff/empty_sleeper/nanotrasen
	name = "broken hypersleep chamber"
	desc = "A Nanotrasen hypersleep chamber - this one appears broken. \
		There are exposed bolts for easy disassembly using a wrench."
	icon_state = "sleeper-o"

/obj/structure/fluff/empty_sleeper/syndicate
	icon_state = "sleeper_s-open"
/**
 * Empty cryostasis sleepers are created when a malfunctioning cryostasis sleeper in a lavaland shelter is activated.
 */
/obj/structure/fluff/empty_cryostasis_sleeper
	name = "empty cryostasis sleeper"
	desc = "Although comfortable, this sleeper won't function as anything but a bed ever again."
	icon = 'icons/obj/lavaland/spawners.dmi'
	icon_state = "cryostasis_sleeper_open"

/obj/structure/fluff/broken_flooring
	name = "broken tiling"
	desc = "A segment of broken flooring."
	icon = 'icons/obj/brokentiling.dmi'
	icon_state = "corner"
/**
 * Ash drake status spawn on either side of the necropolis gate in lavaland.
 */
/obj/structure/fluff/drake_statue
	name = "drake statue"
	desc = "A towering basalt sculpture of a proud and regal drake. Its eyes are six glowing gemstones."
	icon = 'icons/effects/64x64.dmi'
	icon_state = "drake_statue"
	pixel_x = -16
	density = TRUE
	deconstructible = FALSE
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER

/obj/structure/fluff/totem
	var/time_between_uses = 1000
	var/last_process = 0

/obj/structure/fluff/totem/hadot_totem
	name = "Hadot Totem"
	desc = "You, bitch! PRAY!"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "hadot"
	density = TRUE
	opacity = FALSE
	deconstructible = FALSE
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER

/obj/structure/fluff/totem/hadot_totem/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("The essence of the deity is still recovering from the last conversation."))
		return
	if(user.a_intent == INTENT_HELP)
		if(user.belief == null)
			var/hadot = tgui_alert(user, "Start worshiping Hadot?",, list("Yes", "No"))
			if(hadot != "Yes" || !loc || QDELETED(user))
				return
			user.belief = "Hadot"
			to_chat(user, span_achievementrare("Now you are mine."))
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "hellohadot", /datum/mood_event/belief/hadot)
	if(user.a_intent == INTENT_DISARM)
		if(user.belief == "Hadot")
			to_chat(user, span_notice("You start praying to Hadot."))
			if(do_after(user, 80 SECONDS, target = src))
				to_chat(user, span_notice("You prayed to Hadot!"))
				var/list/verygood_stat_modification = list(STAT_STRENGTH = 2, STAT_ENDURANCE = 2)
				var/list/good_stat_modification = list(STAT_STRENGTH = 1, STAT_ENDURANCE = 1)
				var/list/verybad_stat_modification = list(STAT_STRENGTH = -1, STAT_ENDURANCE = -1)
				var/diceroll = user.diceroll(GET_MOB_ATTRIBUTE_VALUE(user, STAT_WILL), context = DICE_CONTEXT_MENTAL)
				if(diceroll == DICE_CRIT_SUCCESS)
					to_chat(user, span_achievementrare("Meow."))
					user.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/verygood, TRUE, verygood_stat_modification)
				if(diceroll == DICE_SUCCESS)
					to_chat(user, span_achievementrare("Hmmm, meow."))
					user.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/good, TRUE, good_stat_modification)
				if(diceroll == DICE_FAILURE)
					to_chat(user, span_achievementrare("Meaaww..."))
					user.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/verybad, TRUE, verybad_stat_modification)
				if(diceroll == DICE_CRIT_FAILURE)
					to_chat(user, span_achievementrare("AH! MEOW!"))
					var/mob/living/carbon/C = user
					if(C.can_heartattack())
						C.set_heartattack(TRUE)
				last_process = world.time

/obj/structure/fluff/totem/gutted_totem
	name = "Gutted Totem"
	desc = "So beautiful."
	icon = 'icons/effects/32x64.dmi'
	icon_state = "gutted"
	density = TRUE
	opacity = FALSE
	deconstructible = FALSE
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER

/obj/structure/fluff/totem/gutted_totem/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("The essence of the deity is still recovering from the last conversation."))
		return
	if(user.a_intent == INTENT_HELP)
		if(user.belief == null)
			var/hadot = tgui_alert(user, "Start worshiping Gutted?",, list("Yes", "No"))
			if(hadot != "Yes" || !loc || QDELETED(user))
				return
			user.belief = "Gutted"
			to_chat(user, span_achievementrare("Now you are mine."))
			SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, "hellogutted", /datum/mood_event/belief/gutted)
	if(user.a_intent == INTENT_DISARM)
		if(user.belief == "Gutted")
			to_chat(user, span_notice("You start praying to Gutted."))
			if(do_after(user, 80 SECONDS, target = src))
				to_chat(user, span_notice("You prayed to Gutted!"))
				var/list/verygood_gutted_stat_modification = list(STAT_DEXTERITY = 2, STAT_PERCEPTION = 2)
				var/list/good_gutted_stat_modification = list(STAT_DEXTERITY = 1, STAT_PERCEPTION = 1)
				var/list/verybad_gutted_stat_modification = list(STAT_DEXTERITY = -1, STAT_PERCEPTION = -1)
				var/diceroll = user.diceroll(GET_MOB_ATTRIBUTE_VALUE(user, STAT_WILL), context = DICE_CONTEXT_MENTAL)
				if(diceroll == DICE_CRIT_SUCCESS)
					to_chat(user, span_achievementrare("Posa sa."))
					user.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/verygood, TRUE, verygood_gutted_stat_modification)
				if(diceroll == DICE_SUCCESS)
					to_chat(user, span_achievementrare("Sssmoa."))
					user.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/good, TRUE, good_gutted_stat_modification)
				if(diceroll == DICE_FAILURE)
					to_chat(user, span_achievementrare("Sere, mian."))
					user.attributes?.add_or_update_variable_attribute_modifier(/datum/attribute_modifier/verybad, TRUE, verybad_gutted_stat_modification)
				if(diceroll == DICE_CRIT_FAILURE)
					to_chat(user, span_achievementrare("Xaixa."))
					var/mob/living/carbon/C = user
					if(C.can_heartattack())
						C.set_heartattack(TRUE)
				last_process = world.time

/obj/structure/fluff/statuestone
	name = "Stone Statue"
	desc = "So beautiful and historic!"
	icon = 'icons/obj/objects.dmi'
	icon_state = "statueki"
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER
	density = 0
	anchored = 1
	opacity = 0

/obj/structure/fluff/statuestone/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)
	icon_state = pick("statueki", "statueli", "statuesi", "statuelimba", "statuelimbo", "statueslo", "statuemi", "statueslobo", "statuekil",  "statuereb", "statuebakir", "statuelyba", "statuepizd")

/obj/structure/fluff/statuestone/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/stone(get_turf(src))
		new /obj/item/stone(get_turf(src))
		new /obj/item/stone(get_turf(src))
		new /obj/item/stone(get_turf(src))
		new /obj/item/stone(get_turf(src))
		playsound(src, 'sound/effects/break_stone.ogg', 80, TRUE)
	qdel(src)

/obj/structure/fluff/narrator
	name = "Narrator"
	desc = "A wooden pole, there's a sign that says..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "narrator"
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER
	density = 1
	anchored = 1
	opacity = 0
	obj_flags = UNIQUE_RENAME

/obj/structure/fluff/narrator/akt/hello
	desc = "A wooden pole, there's a sign that says... Welcome, this is Akt village. Be polite, don't kill, don't steal or swear. We hope that this place will become your home and just a safe environment."

/obj/structure/fluff/narrator/akt/barroom
	desc = "A wooden pole, there's a sign that says... Here you can have a nice rest with great music and great alcohol!"

/obj/structure/fluff/narrator/akt/farm
	desc = "A wooden pole, there's a sign that says... Berries grow here. Don't steal them!"

/obj/structure/fluff/narrator/akt/infirmary
	desc = "A wooden pole, there's a sign that says... Infirmary. Here you can be healed."

/obj/structure/fluff/narrator/akt/controller
	desc = "A wooden pole, there's a sign that says... Palace of the controller - the owner of this village. Listen to him! "

/obj/structure/fluff/narrator/akt/hut
	desc = "A wooden pole, there's a sign that says... Hut. House for assertors."

/obj/structure/fluff/narrator/akt/pinker
	desc = "A wooden pole, there's a sign that says... PINKER Platform. The PINKER is coming soon and it will pick us up!"

/obj/structure/fluff/narrator/forest
	desc = "A stone deformity, the words are engraved here that says..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "narrator_stone"

/obj/structure/fluff/narrator/forest/carehouse
	desc = "A stone deformity, the words are engraved here that says... Carehouse - your forest-shelter."

/obj/structure/fluff/statueiron/first
	name = "Iron Statue"
	desc = "So beautiful and historic!"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "badorza_1"
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER
	density = 1
	anchored = 1
	opacity = 0

/obj/structure/fluff/statueiron/seond
	name = "Iron Statue"
	desc = "So beautiful and historic!"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "badorza_2"
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER
	density = 1
	anchored = 1
	opacity = 0

/obj/structure/fluff/statueiron/third
	name = "Iron Statue"
	desc = "So beautiful and historic!"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "badorza_3"
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER
	density = 1
	anchored = 1
	opacity = 0

/obj/structure/fluff/statueiron/random
	name = "Iron Statue"
	desc = "So beautiful and historic!"
	icon = 'icons/effects/32x64.dmi'
	icon_state = "badorza_1"
	plane = GAME_PLANE_UPPER
	layer = EDGED_TURF_LAYER
	density = 1
	anchored = 1
	opacity = 0

/obj/structure/fluff/statueiron/random/Initialize(mapload)
	. = ..()
	icon_state = pick("badorza_1", "badorza_2", "badorza_3")

/**
 * A variety of statue in disrepair; parts are broken off and a gemstone is missing
 */
/obj/structure/fluff/drake_statue/falling
	desc = "A towering basalt sculpture of a drake. Cracks run down its surface and parts of it have fallen off."
	icon_state = "drake_statue_falling"


/obj/structure/fluff/bus
	name = "bus"
	desc = "GO TO SCHOOL. READ A BOOK."
	icon = 'icons/obj/bus.dmi'
	density = TRUE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/bus/dense
	name = "bus"
	icon_state = "backwall"

/obj/structure/fluff/bus/passable
	name = "bus"
	icon_state = "frontwalltop"
	density = FALSE
	plane = ABOVE_GAME_PLANE
	layer = ABOVE_ALL_MOB_LAYER //except for the stairs tile, which should be set to OBJ_LAYER aka 3.

/obj/structure/fluff/bus/passable/seat
	name = "seat"
	desc = "Buckle up! ...What do you mean, there's no seatbelts?!"
	icon_state = "backseat"
	pixel_y = 17
	plane = GAME_PLANE
	layer = OBJ_LAYER

/obj/structure/fluff/bus/passable/seat/driver
	name = "driver's seat"
	desc = "Space Jesus is my copilot."
	icon_state = "driverseat"

/obj/structure/fluff/bus/passable/seat/driver/attack_hand(mob/user, list/modifiers)
	playsound(src, 'sound/items/carhorn.ogg', 50, TRUE)
	. = ..()

/obj/structure/fluff/paper
	name = "dense lining of papers"
	desc = "A lining of paper scattered across the bottom of a wall."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "paper"
	deconstructible = FALSE

/obj/structure/fluff/paper/corner
	icon_state = "papercorner"

/obj/structure/fluff/paper/stack
	name = "dense stack of papers"
	desc = "A stack of various papers, childish scribbles scattered across each page."
	icon_state = "paperstack"


/obj/structure/fluff/divine
	name = "Miracle"
	icon = 'icons/obj/hand_of_god_structures.dmi'
	anchored = TRUE
	density = TRUE

/obj/structure/fluff/divine/nexus
	name = "nexus"
	desc = "It anchors a deity to this world. It radiates an unusual aura. It looks well protected from explosive shock."
	icon_state = "nexus"

/obj/structure/fluff/divine/conduit
	name = "conduit"
	desc = "It allows a deity to extend their reach.  Their powers are just as potent near a conduit as a nexus."
	icon_state = "conduit"

/obj/structure/fluff/divine/convertaltar
	name = "conversion altar"
	desc = "An altar dedicated to a deity."
	icon_state = "convertaltar"
	density = FALSE
	can_buckle = 1

/obj/structure/fluff/divine/powerpylon
	name = "power pylon"
	desc = "A pylon which increases the deity's rate it can influence the world."
	icon_state = "powerpylon"
	can_buckle = 1

/obj/structure/fluff/divine/defensepylon
	name = "defense pylon"
	desc = "A pylon which is blessed to withstand many blows, and fire strong bolts at nonbelievers. A god can toggle it."
	icon_state = "defensepylon"

/obj/structure/fluff/divine/shrine
	name = "shrine"
	desc = "A shrine dedicated to a deity."
	icon_state = "shrine"

/obj/structure/fluff/fokoff_sign
	name = "crude sign"
	desc = "A crudely-made sign with the words 'fok of' written in some sort of red paint."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "fokof"

/obj/structure/fluff/big_chain
	name = "giant chain"
	desc = "A towering link of chains leading up to the ceiling."
	icon = 'icons/effects/32x96.dmi'
	icon_state = "chain"
	layer = ABOVE_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_towel
	name = "beach towel"
	desc = "A towel decorated in various beach-themed designs."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "railing"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_umbrella
	name = "beach umbrella"
	desc = "A fancy umbrella designed to keep the sun off beach-goers."
	icon = 'icons/obj/fluff.dmi'
	icon_state = "brella"
	density = FALSE
	anchored = TRUE
	deconstructible = FALSE

/obj/structure/fluff/beach_umbrella/security
	icon_state = "hos_brella"

/obj/structure/fluff/beach_umbrella/science
	icon_state = "rd_brella"

/obj/structure/fluff/beach_umbrella/engine
	icon_state = "ce_brella"

/obj/structure/fluff/beach_umbrella/cap
	icon_state = "cap_brella"

/obj/structure/fluff/beach_umbrella/syndi
	icon_state = "syndi_brella"

/obj/structure/fluff/clockwork
	name = "Clockwork Fluff"
	icon = 'icons/obj/clockwork_objects.dmi'
	deconstructible = FALSE

/obj/structure/fluff/clockwork/alloy_shards
	name = "replicant alloy shards"
	desc = "Broken shards of some oddly malleable metal. They occasionally move and seem to glow."
	icon_state = "alloy_shards"

/obj/structure/fluff/clockwork/alloy_shards/small
	icon_state = "shard_small1"

/obj/structure/fluff/clockwork/alloy_shards/medium
	icon_state = "shard_medium1"

/obj/structure/fluff/clockwork/alloy_shards/medium_gearbit
	icon_state = "gear_bit1"

/obj/structure/fluff/clockwork/alloy_shards/large
	icon_state = "shard_large1"

/obj/structure/fluff/clockwork/blind_eye
	name = "blind eye"
	desc = "A heavy brass eye, its red iris fallen dark."
	icon_state = "blind_eye"

/obj/structure/fluff/clockwork/fallen_armor
	name = "fallen armor"
	desc = "Lifeless chunks of armor. They're designed in a strange way and won't fit on you."
	icon_state = "fallen_armor"

/obj/structure/fluff/clockwork/clockgolem_remains
	name = "clockwork golem scrap"
	desc = "A pile of scrap metal. It seems damaged beyond repair."
	icon_state = "clockgolem_dead"

/obj/structure/fluff/tram_rail
	name = "tram rail"
	desc = "Great for trams, not so great for skating."
	icon = 'icons/obj/tram_rails.dmi'
	icon_state = "rail"
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	deconstructible = TRUE

/obj/structure/fluff/tram_rail/floor
	icon_state = "rail_floor"

/obj/structure/fluff/tram_rail/end
	icon_state = "railend"

/obj/structure/fluff/tram_rail/anchor
	name = "tram rail anchor"
	icon_state = "anchor"
