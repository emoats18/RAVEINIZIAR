/obj/structure/flora
	resistance_flags = FLAMMABLE
	max_integrity = 150
	anchored = TRUE

//trees
/obj/structure/flora/tree
	name = "tree"
	desc = "A large tree."
	density = TRUE
	pixel_x = -16
	layer = FLY_LAYER
	var/log_amount = 10
	var/randomcolor = FALSE

/obj/structure/flora/tree/attackby(obj/item/W, mob/living/carbon/user, params)
	if(log_amount && (!(flags_1 & NODECONSTRUCT_1)))
		if(W.get_sharpness() && W.force > 5)
			if(W.isAxe)
				if(W.hitsound)
					playsound(get_turf(src), 'modular_septic/sound/weapons/melee/hitree.ogg', 100, FALSE, FALSE)
				user.visible_message(span_notice("[user] begins to cut down [src] with [W]."),span_notice("You begin to cut down [src] with [W]."), span_hear("You hear the sound of sawing."))
				user.changeNext_move(W.attack_delay)
				user.adjustFatigueLoss(W.attack_fatigue_cost)
				W.damageItem("SOFT")
				sound_hint()
				if(do_after(user, 1000/W.force, target = src)) //5 seconds with 20 force, 8 seconds with a hatchet, 20 seconds with a shard.
					user.visible_message(span_notice("[user] fells [src] with the [W]."),span_notice("You fell [src] with the [W]."), span_hear("You hear the sound of a tree falling."))
					user.changeNext_move(W.attack_delay)
					user.adjustFatigueLoss(W.attack_fatigue_cost)
					W.damageItem("HARD")
					playsound(get_turf(src), 'modular_septic/sound/effects/fallheavy.ogg', 100 , FALSE, FALSE)
					sound_hint()
//					user.log_message("cut down [src] at [AREACOORD(src)]", LOG_ATTACK)
					for(var/i=1 to log_amount)
						new /obj/item/grown/log/tree/evil(get_turf(src))
					var/obj/structure/flora/stump/S = new(loc)
					S.name = "[name] stump"
					qdel(src)
	else
		return ..()

/obj/structure/flora/tree/Initialize(mapload)
	. = ..()
	if(randomcolor)
		color = color = pick("#F9F191", "#BBBBF2", "#FF5DAE", "#38FF48", "#81EADC", "")

/obj/structure/flora/stump
	name = "Stump"
	desc = "Another stump..."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "tree_stump"
	density = FALSE
	pixel_x = -16

/obj/structure/flora/tree/pine
	name = "pine tree"
	desc = "A coniferous pine tree."
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	var/list/icon_states = list("pine_1", "pine_2", "pine_3")

/obj/structure/flora/tree/pine/Initialize(mapload)
	. = ..()
	if(islist(icon_states?.len))
		icon_state = pick(icon_states)

/mob/living/var/special_item
/obj/structure/flora/tree/evil/var/list/itemstake = list()

/obj/structure/flora/tree/evil
	name = "Cursed Tree"
	desc = "It has become so evil!"
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "treevil_1"
	log_amount = 3
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	density = 1
	anchored = 1
	opacity = 1
	randomcolor = TRUE
	var/havebranch = TRUE

/obj/structure/flora/tree/evil/Initialize(mapload)
	. = ..()
	icon_state = pick("treevil_1", "treevil_2", "treevil_3", "treevil_4", "treevil_5", "treevil_6", "treevil_7", "treevil_8")

/obj/structure/flora/tree/evil/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent == INTENT_DISARM)
		user.changeNext_move(CLICK_CD_MELEE)
		user.adjustFatigueLoss(5)
		sound_hint()
		if(get_dist(src, user) > 2)
			return
		var/mob/living/carbon/human/H = user
		if(H.mind.has_antag_datum(/datum/antagonist/traitor))
			if(H.special_item)
				var/pickeditem = tgui_input_list(user, "You want something?",, list("LAPTOP"))
				if(!pickeditem)
					return
				if(pickeditem == "LAPTOP")
					new /obj/item/modular_computer/laptop/preset/civilian(get_turf(user))
					H.special_item = null
	if(user.a_intent == INTENT_GRAB)
		if(do_after(user, 1 SECONDS, target = src))
			if(!havebranch)
				to_chat(user, span_notice("I can't tear a branch off this tree."))
				return
			user.visible_message(span_notice("[user] tears a branch from [src]."),span_notice("You tear a branch from [src]."), span_hear("You hear a crunch."))
			user.changeNext_move(CLICK_CD_MELEE)
			user.adjustFatigueLoss(5)
			sound_hint()
			playsound(get_turf(src), 'modular_pod/sound/eff/stick.ogg', 100 , FALSE, FALSE)
			new /obj/item/melee/bita/branch(get_turf(user))
			havebranch = FALSE

/*
				var/pickeditem
				init_items(H)
				pickeditem = tgui_input_list(user, "You want something?",, list(itemstake))
				if(!pickeditem)
					return
				if(get_dist(user, src) > 1)
					return
				if(pickeditem)
					spawn_item(pickeditem, H)
					itemstake = list()
				..()
			else
				to_chat(user, "<i>Hmmm.</i>")
				return

/obj/structure/flora/tree/evil/proc/init_items(var/mob/living/carbon/human/H)
	itemstake = list()
	if(IS_TRAITOR(H))
		if(H.special_item)
			itemstake.Add("Individual")

/obj/structure/flora/tree/evil/proc/spawn_item(var/pickeditem, var/mob/living/carbon/human/receiver)
	var/spawnitem
	switch(pickeditem)
		if("Individual")
			spawnitem = receiver.special_item
			receiver.special_item = null
	new spawnitem(receiver.loc)
	receiver.put_in_active_hand(spawnitem)
//	if(spawnitem == /obj/item/device/cellphone)
//		var/obj/item/device/cellphone/C = W
//		var/obj/item/device/rim_card/R = new()
//		C.rimcard = R
//		R.loc = src
//		R.Phone = src
	to_chat(receiver, "<i>It's my thing.</i>")
*/
/obj/structure/flora/tree/evil/long
	name = "Long Cursed Tree"
	desc = "It has become so evil! By the way, it's long."
	icon = 'modular_pod/icons/obj/32x96.dmi'
	icon_state = "treevillong_1"
	pixel_x = 0
//	pixel_y = -32
	log_amount = 4
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	density = 1
	anchored = 1
	opacity = 1
	randomcolor = TRUE

/obj/structure/flora/tree/evil/long/Initialize(mapload)
	. = ..()
	icon_state = pick("treevillong_1", "treevillong_2", "treevillong_3", "treevillong_4", "treevillong_5", "treevillong_6", "treevillong_7", "treevillong_8")

/obj/structure/flora/tree/veva
	name = "Spirited Tree"
	desc = "Beacon of the Third Creator Veva."
	icon = 'icons/obj/flora/deadtrees.dmi'
	density = TRUE
	opacity = TRUE
	log_amount = 4
	icon_state = "vevatree"

/obj/structure/flora/tree/chungus
	name = "Chungus Tree"
	desc = "I'm starting to remember him..."
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "chungtree_1"
	log_amount = 0
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	density = 1
	anchored = 1
	opacity = 1
//	var/havebranch = TRUE

/obj/structure/flora/tree/chungus/Initialize(mapload)
	. = ..()
	icon_state = pick("chungtree_2", "chungtree_3", "chungtree_4", "chungtree_1")

/obj/structure/flora/tree/chungus/attackby(obj/item/W, mob/living/carbon/user, params)
	user.changeNext_move(CLICK_CD_MELEE)
	user.electrocute_act(30, src, flags = SHOCK_NOGLOVES)

/obj/structure/flora/tree/chungus/on_rammed(mob/living/carbon/rammer)
	rammer.ram_stun()
	var/smash_sound = pick('modular_septic/sound/gore/smash1.ogg',
						'modular_septic/sound/gore/smash2.ogg',
						'modular_septic/sound/gore/smash3.ogg')
	playsound(src, smash_sound, 75)
	rammer.sound_hint()
	sound_hint()
	if(prob(70))
		rammer.electrocute_act(30, src, flags = SHOCK_NOGLOVES)

/obj/structure/flora/tree/chungus/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(.)
		return
	return

/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	desc = "A wondrous decorated Christmas tree."
	icon_state = "pine_c"
	icon_states = null
	flags_1 = NODECONSTRUCT_1 //protected by the christmas spirit

/obj/structure/flora/tree/pine/xmas/presents
	icon_state = "pinepresents"
	desc = "A wondrous decorated Christmas tree. It has presents!"
	var/gift_type = /obj/item/a_gift/anything
	var/unlimited = FALSE
	var/static/list/took_presents //shared between all xmas trees

/obj/structure/flora/tree/pine/xmas/presents/Initialize(mapload)
	. = ..()
	if(!took_presents)
		took_presents = list()

/obj/structure/flora/tree/pine/xmas/presents/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(took_presents[user.ckey] && !unlimited)
		to_chat(user, span_warning("There are no presents with your name on."))
		return
	to_chat(user, span_warning("After a bit of rummaging, you locate a gift with your name on it!"))

	if(!unlimited)
		took_presents[user.ckey] = TRUE

	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)

/obj/structure/flora/tree/pine/xmas/presents/unlimited
	desc = "A wonderous decorated Christmas tree. It has a seemly endless supply of presents!"
	unlimited = TRUE

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	desc = "A dead tree. How it died, you know not."
	icon_state = "tree_1"

/obj/structure/flora/tree/palm
	icon = 'icons/misc/beach2.dmi'
	desc = "A tree straight from the tropics."
	icon_state = "palm1"

/obj/structure/flora/tree/palm/Initialize(mapload)
	. = ..()
	icon_state = pick("palm1","palm2")
	pixel_x = 0

/obj/structure/festivus
	name = "festivus pole"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "festivus_pole"
	desc = "During last year's Feats of Strength the Research Director was able to suplex this passing immobile rod into a planter."

/obj/structure/festivus/anchored
	name = "suplexed rod"
	desc = "A true feat of strength, almost as good as last year."
	icon_state = "anchored_rod"
	anchored = TRUE

/obj/structure/flora/tree/dead/Initialize(mapload)
	. = ..()
	icon_state = "tree_[rand(1, 6)]"

/obj/structure/flora/tree/jungle
	name = "tree"
	icon_state = "tree"
	desc = "It's seriously hampering your view of the jungle."
	icon = 'icons/obj/flora/jungletrees.dmi'
	pixel_x = -48
	pixel_y = -20

/obj/structure/flora/tree/jungle/Initialize(mapload)
	. = ..()
	icon_state = "[icon_state][rand(1, 6)]"

/obj/structure/flora/tree/jungle/small
	pixel_y = 0
	pixel_x = -32
	icon = 'icons/obj/flora/jungletreesmall.dmi'

//grass
/obj/structure/flora/grass
	name = "grass"
	desc = "A patch of overgrown grass."
	icon = 'icons/obj/flora/snowflora.dmi'
	gender = PLURAL //"this is grass" not "this is a grass"

/obj/structure/flora/grass/brown
	icon_state = "snowgrass1bb"

/obj/structure/flora/grass/brown/Initialize(mapload)
	. = ..()
	icon_state = "snowgrass[rand(1, 3)]bb"

/obj/structure/flora/grass/green
	icon_state = "snowgrass1gb"

/obj/structure/flora/grass/green/Initialize(mapload)
	. = ..()
	icon_state = "snowgrass[rand(1, 3)]gb"

/obj/structure/flora/grass/both
	icon_state = "snowgrassall1"

/obj/structure/flora/grass/both/Initialize(mapload)
	. = ..()
	icon_state = "snowgrassall[rand(1, 3)]"


//bushes
/obj/structure/flora/bush
	name = "Bush"
	desc = "Some type of shrub."
	icon = 'icons/obj/flora/snowflora.dmi'
	icon_state = "snowbush1"
	anchored = TRUE

/obj/structure/flora/bush/Initialize(mapload)
	. = ..()
	icon_state = "snowbush[rand(1, 6)]"

//newbushes

/obj/structure/flora/ausbushes
	name = "Bush"
	desc = "Some kind of plant."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "firstbush_1"

/obj/structure/flora/ausbushes/Initialize(mapload)
	. = ..()
	if(icon_state == "firstbush_1")
		icon_state = "firstbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/incrementum
	name = "Goldish Incrementum"
	desc = "Infection of the forest."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "incrementum1"
	plane = FLOOR_PLANE
	layer = LATTICE_LAYER
	obj_flags = NONE
	density = 0
	anchored = 1

/obj/structure/flora/ausbushes/incrementum/Initialize()
	. = ..()
	icon_state = pick("incrementum1", "incrementum2", "incrementum3", "incrementum4")

/obj/structure/flora/ausbushes/incrementum/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shagg,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/ausbushes/incrementum/proc/shagg(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(!isturf(loc) || !isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(loc,'modular_pod/sound/eff/incrementum.ogg', 30, TRUE)

/obj/structure/flora/ausbushes/incrementum/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the [W]."),span_notice("You cut [W]."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			if(istype(src, /obj/structure/flora/ausbushes/incrementum/ygro))
				new /obj/item/food/gelatine/mesopelagic(get_turf(src))
			else
				new /obj/item/stack/medical/nanopaste/xap(loc)
			playsound(loc,'modular_pod/sound/eff/incrementum.ogg', 30, TRUE)
			W.damageItem("SOFT")
			qdel(src)

/obj/structure/flora/ausbushes/incrementum/skunk
	name = "Shit-Skunk"
	desc = "Infection of this forest. It's smelly."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "skunk1"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	density = 0
	anchored = 1

/obj/structure/flora/ausbushes/incrementum/skunk/Initialize()
	. = ..()
	AddElement(/datum/element/pollution_emitter, /datum/pollutant/shit, 30)
	icon_state = pick("skunk1", "skunk2")

/obj/structure/flora/ausbushes/incrementum/deconstruct(disassembled = TRUE)
	new /obj/item/stack/medical/nanopaste/xap(get_turf(src))
	playsound(src,'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/incrementum/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
			else
				playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/incrementum/skunk/deconstruct(disassembled = TRUE)
	new /obj/effect/decal/cleanable/blood/shit(get_turf(src))
	playsound(src,'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/incrementum/skunk/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
			else
				playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)

/obj/structure/flora/remains
	name = "Remains"
	desc = "Broken gelatine."
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "ygro_reflection"
	density = FALSE
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER

/obj/structure/flora/ausbushes/incrementum/ygro
	name = "Ygro Reflection"
	desc = "Aquatic flora."
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "ygro_reflection1"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	density = 1
	anchored = 1

/obj/structure/flora/ausbushes/incrementum/ygro/deconstruct(disassembled = TRUE)
	new /obj/item/food/gelatine/mesopelagic(get_turf(src))
	new /obj/structure/flora/remains(get_turf(src))
	playsound(src,'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/incrementum/ygro/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
			else
				playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)
		if(BURN)
			playsound(src, 'modular_pod/sound/eff/incrementum.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/incrementum/ygro/Initialize()
	. = ..()
	AddElement(/datum/element/climbable)
	icon_state = pick("ygro_reflection1", "ygro_reflection2", "ygro_reflection3", "ygro_reflection4")

/obj/structure/flora/ausbushes/crystal
	name = "Overcrystal Bush"
	desc = "A bush that grows over or near the crystal deposits."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "crystalbush1"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	obj_flags = NONE
	density = 0
	anchored = 1
	var/traps = TRUE

/obj/structure/flora/ausbushes/crystal/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shag,
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	icon_state = pick("crystalbush1", "crystalbush2")

	if(traps)
		if(prob(2))
			new /obj/item/restraints/legcuffs/beartrap(get_turf(src))

/obj/structure/flora/ausbushes/crystal/proc/shag(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(!isturf(loc) || !isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(loc,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/crystal/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the [W]."),span_notice("You cut [W]."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			new /obj/item/craftitem/foliage(get_turf(src))
			playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
			W.damageItem("SOFT")
			qdel(src)

/obj/structure/flora/ausbushes/bushka
	name = "Longrass"
	desc = "So long!"
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "bushka1"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	obj_flags = NONE
	density = 0
	anchored = 1
	var/traps = TRUE

/obj/structure/flora/ausbushes/bushka/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shag,
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	icon_state = pick("bushka1", "bushka2", "bushka3")

	if(traps)
		if(prob(2))
			new /obj/item/restraints/legcuffs/beartrap(get_turf(src))

/obj/structure/flora/ausbushes/bushka/proc/shag(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(!isturf(loc) || !isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(loc,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/bushka/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/craftitem/bladegrass(get_turf(src))
		new /obj/item/craftitem/bladegrass(get_turf(src))
		playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/bushka/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the Longrass."),span_notice("You cut Longrass."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			new /obj/item/craftitem/bladegrass(loc)
			new /obj/item/craftitem/bladegrass(loc)
			playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
			W.damageItem("SOFT")
			qdel(src)

/*
/obj/structure/flora/ausbushes/root
	name = "Tree Root"
	desc = "Root of the tree."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "root_1"
	resistance_flags = FLAMMABLE
	density = 0
	anchored = 1
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/structure/flora/ausbushes/root/Initialize(mapload)
	. = ..()
	update_appearance()
	icon_state = "root_[rand(1, 3)]"

/obj/structure/flora/ausbushes/root/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shag,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/ausbushes/root/proc/shag(datum/source, mob/living/arrived)
	SIGNAL_HANDLER

	if(!isturf(loc) || !istype(arrived))
		return
	if(prob(40))
		arrived.visible_message(span_warning("[arrived] stumbles on the root."), \
								span_warning("I stumble on the root."))
		sound_hint()
		var/diceroll = arrived.diceroll(GET_MOB_ATTRIBUTE_VALUE(arrived, STAT_DEXTERITY), context = DICE_CONTEXT_MENTAL)
		if(diceroll <= DICE_FAILURE)
			arrived.Stumble(3 SECONDS)
*/

/obj/structure/flora/ausbushes/molyakii
	name = "Shrub"
	desc = "These leaves lure me."
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "molyakii"
	plane = FLOOR_PLANE
	layer = LATTICE_LAYER
	resistance_flags = FLAMMABLE
	obj_flags = NONE
	density = 0
	anchored = 1
	var/traps = TRUE

/obj/structure/flora/ausbushes/molyakii/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shag,
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	icon_state = "molyakii[rand(1, 2)]"

	if(traps)
		if(prob(2))
			new /obj/item/restraints/legcuffs/beartrap(get_turf(src))

/obj/structure/flora/ausbushes/molyakii/proc/shag(datum/source, atom/movable/AM)
	SIGNAL_HANDLER

	if(!isturf(loc) || !isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(loc,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/molyakii/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/food/grown/molyak(drop_location(), 2)
		playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/molyakii/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the [src]."),span_notice("You cut [src]."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			new /obj/item/food/grown/molyak(drop_location())
			new /obj/item/food/grown/molyak(drop_location())
			playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
			W.damageItem("SOFT")
			qdel(src)

/obj/structure/flora/ausbushes/molyakii/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			else
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		if(BURN)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/crystal/dark
	name = "Blackness Bush"
	desc = "Bush of blackness. This bush is chaotic."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "blacknessbush1"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	obj_flags = NONE
	density = 0
	anchored = 1
	opacity = 0
	var/berry_type = null
	var/berries = 0

/obj/structure/flora/ausbushes/crystal/dark/Initialize(mapload)
	. = ..()
	icon_state = pick("blacknessbush1", "blacknessbush2", "blacknessbush3", "blacknessbush4")
	berry_type = pick("red", "blue", "redd", "superred", "bluee", "purple", "blueee", "reddd", "purplee", "redddd")
	grow_berries()

/obj/structure/flora/ausbushes/crystal/dark/update_overlays()
	. = ..()
	if((berries > 0) && berry_type)
		. += "[berry_type]_berries"

/obj/structure/flora/ausbushes/crystal/dark/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shaggg,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/ausbushes/crystal/dark/proc/shaggg(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/crystal/dark/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the [src]."),span_notice("You cut [src]."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
			W.damageItem("SOFT")
			qdel(src)

/obj/structure/flora/ausbushes/crystal/dark/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent != INTENT_GRAB)
		return

	user.visible_message(span_notice("<b>[user]</b> begins to search for berries."), \
						span_notice("I begin to search for berries."), \
						span_hear("I hear the sound of shag."))
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc,'sound/effects/shelest.ogg', 30, TRUE)
	if(!do_after(user, 30, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	if(!berries)
		to_chat(user, span_notice("No berries."))
		user.Immobilize(1 SECONDS)
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src,'sound/effects/shelest.ogg', 60, TRUE)
		sound_hint()
		return
	to_chat(user, span_notice("I pick berry."))
	user.changeNext_move(CLICK_CD_MELEE)
	user.Immobilize(1 SECONDS)
	playsound(src,'sound/effects/shelest.ogg', 60, TRUE)
	sound_hint()
	var/obj/item/berry
	switch(berry_type)
		if("red")
			berry = new /obj/item/food/berries/redcherrie(loc)
		if("blue")
			berry = new /obj/item/food/grown/bluecherries(loc)
		if("redd")
			berry = new /obj/item/food/berries/redcherrie/lie(loc)
		if("superred")
			berry = new /obj/item/food/berries/redcherrie/super(loc)
		if("bluee")
			berry = new /obj/item/food/grown/bluecherries/lie(loc)
		if("blueee")
			berry = new /obj/item/food/grown/bluecherries/super(loc)
		if("purple")
			berry = new /obj/item/food/berries/leancherrie(loc)
		if("purplee")
			berry = new /obj/item/food/berries/leancherrie/lie(loc)
		if("reddd")
			berry = new /obj/item/food/grown/lifebloodcherries(loc)
		if("redddd")
			berry = new /obj/item/food/grown/lifebloodcherries/lie(loc)
	user.put_in_active_hand(berry)
	berries--
	update_appearance()
	addtimer(CALLBACK(src, .proc/grow_berries), 130 SECONDS)

/obj/structure/flora/ausbushes/crystal/dark/proc/grow_berries()
	if(QDELETED(src) || !berry_type || (berries > 0))
		return
	berries++
	update_appearance()

/obj/structure/flora/ausbushes/zarosli/sliz
	name = "Slime Thickets"
	desc = "Nature is beautiful."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "zaroslisliz"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	density = 0
	anchored = TRUE
	opacity = TRUE

/obj/structure/flora/ausbushes/zarosli/midnight
	name = "Midnightberry Thickets"
	desc = "Nature is beautiful."
	icon = 'icons/obj/flora/ausflora.dmi'
	icon_state = "zarosliya"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	obj_flags = NONE
	var/time_between_uses = 500
	var/last_process = 0
	density = FALSE
	anchored = TRUE
	opacity = TRUE
	var/traps = TRUE

/obj/structure/flora/ausbushes/zarosli/midnight/Initialize(mapload)
	. = ..()
	dir = rand(0,4)
	update_appearance()

	if(traps)
		if(prob(2))
			new /obj/item/restraints/legcuffs/beartrap(get_turf(src))

/obj/structure/flora/ausbushes/zarosli/midnight/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shag,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/ausbushes/zarosli/proc/shag(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/zarosli/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the [src]."),span_notice("You cut [src]."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
			W.damageItem("SOFT")
			new /obj/item/craftitem/piece(get_turf(src))
			new /obj/item/craftitem/piece(get_turf(src))
			new /obj/item/craftitem/piece(get_turf(src))
			new /obj/item/craftitem/piece(get_turf(src))
			qdel(src)

/obj/structure/flora/ausbushes/zarosli/midnight/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent != INTENT_GRAB)
		return
	user.visible_message(span_notice("<b>[user]</b> begins to search for midnightberries."), \
						span_notice("I begin to search for midnightberries."), \
						span_hear("I hear the sound of shag."))
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc,'sound/effects/shelest.ogg', 30, TRUE)
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	if(last_process + time_between_uses > world.time)
		user.changeNext_move(CLICK_CD_MELEE)
		user.Immobilize(1 SECONDS)
		playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		to_chat(user, span_notice("Looks like there are no more midnightberries left."))
		sound_hint()
		return
	last_process = world.time
	to_chat(user, span_notice("You pick pesky midnightberry."))
	sound_hint()
	user.changeNext_move(CLICK_CD_MELEE)
	user.Immobilize(1 SECONDS)
	playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
	var/result = rand(1, 2)
	switch(result)
		if(1)
			result = new /obj/item/food/grown/bluecherries(loc)
		if(2)
			result = new /obj/item/food/grown/bluecherries/lie(loc)
	user.put_in_active_hand(result)

/obj/structure/flora/ausbushes/zarosli/midnight/good
	name = "Midnightberry Thickets"
	desc = "Oh, this is a great variety of midnightberry thickets."
	var/haveberry = TRUE
	var/stillborn = FALSE
	time_between_uses = null
	last_process = null

/obj/structure/flora/ausbushes/zarosli/midnight/good/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent != INTENT_GRAB)
		return
	user.visible_message(span_notice("<b>[user]</b> begins to search for midnightberries."), \
						span_notice("I begin to search for midnightberries."), \
						span_hear("I hear the sound of shag."))
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc,'sound/effects/shelest.ogg', 30, TRUE)
	if(do_after(user, 10 SECONDS, target = src))
		if(stillborn == TRUE)
			user.changeNext_move(CLICK_CD_MELEE)
			user.Immobilize(1 SECONDS)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			to_chat(user, span_notice("These thickets are stillborn. Why did I touch this at all?"))
			sound_hint()
			return
		if(haveberry == FALSE)
			user.changeNext_move(CLICK_CD_MELEE)
			user.Immobilize(1 SECONDS)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			to_chat(user, span_notice("Looks like there are no more midnightberries will grow."))
			sound_hint()
			return
		haveberry = FALSE
		to_chat(user, span_notice("You pick pesky midnightberry."))
		sound_hint()
		user.changeNext_move(CLICK_CD_MELEE)
		user.Immobilize(1 SECONDS)
		playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		var/result = rand(1, 2)
		switch(result)
			if(1)
				result = new /obj/item/food/grown/bluecherries(loc)
			if(2)
				result = new /obj/item/food/grown/bluecherries/super(loc)
		user.put_in_active_hand(result)
	else
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return

/obj/structure/flora/ausbushes/zarosli/midnight/good/Initialize(mapload)
	. = ..()
	if(prob(20))
		stillborn = TRUE

/obj/structure/flora/ausbushes/zarosli/midnight/good/examine(mob/user)
	. = ..()
	if(stillborn)
		. += "<span class='warning'>Oh, looks like these thickets are stillborn.</span>"

/obj/structure/flora/ausbushes/zarosli/midnight/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/craftitem/piece(get_turf(src))
		new /obj/item/craftitem/piece(get_turf(src))
		new /obj/item/craftitem/piece(get_turf(src))
		new /obj/item/craftitem/piece(get_turf(src))
		if(prob(50))
			new /obj/item/seeding/midnightberryseeds(get_turf(src))
		playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
	qdel(src)

/obj/structure/flora/ausbushes/zarosli/midnight/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			else
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		if(BURN)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/crystal/dark/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			else
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		if(BURN)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/crystal/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			else
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		if(BURN)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/bushka/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			else
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		if(BURN)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/zarosli/aguo
	name = "Aguo Plant"
	desc = "FRUIT!"
	icon = 'modular_pod/icons/obj/things/things.dmi'
	icon_state = "aguo_growing"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	resistance_flags = FLAMMABLE
	obj_flags = NONE
	var/time_between_uses = 500
	var/last_process = 0
	density = FALSE
	anchored = TRUE
	opacity = FALSE
	var/berry = 0
	var/saturated = FALSE

/obj/structure/flora/ausbushes/zarosli/aguo/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/structure/flora/ausbushes/zarosli/aguo/ComponentInitialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = .proc/shago,
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/ausbushes/zarosli/aguo/update_overlays()
	. = ..()
	if(berry > 0)
		. += "[icon_state]1"

/obj/structure/flora/ausbushes/zarosli/aguo/proc/shago(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	if(!isliving(AM))
		return
	var/mob/living/walker = AM
	if(istype(walker))
		if((GET_MOB_ATTRIBUTE_VALUE(walker, STAT_DEXTERITY) >= 14) && walker.combat_mode)
			return
	playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/zarosli/aguo/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.a_intent != INTENT_GRAB)
		return
	user.visible_message(span_notice("<b>[user]</b> begins to picks a fruit."), \
						span_notice("I begin to pick a fruit."), \
						span_hear("I hear the sound of shag."))
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc,'sound/effects/shelest.ogg', 30, TRUE)
	if(!do_after(user, 10 SECONDS, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		user.playsound_local(get_turf(user), 'modular_pod/sound/eff/difficult1.ogg', 15, FALSE)
		return
	if(!berry)
		to_chat(user, span_notice("No fruit."))
		user.Immobilize(1 SECONDS)
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src,'sound/effects/shelest.ogg', 60, TRUE)
		sound_hint()
		return
	to_chat(user, span_notice("You pick nice augo!"))
	sound_hint()
	user.changeNext_move(CLICK_CD_MELEE)
	user.Immobilize(1 SECONDS)
	playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
	new /obj/item/food/grown/aguo(get_turf(user))
	berry--
	saturated = FALSE
	update_appearance()
//	addtimer(CALLBACK(src, .proc/grow_berry), 150 SECONDS)

/obj/structure/flora/ausbushes/zarosli/aguo/attackby(obj/item/W, mob/living/carbon/user, params)
	. = ..()
	if(.)
		return
	if(user.a_intent == INTENT_DISARM)
		if(istype(W, /obj/item/stupidbottles/bluebottle))
			if(!saturated)
				var/obj/item/stupidbottles/bluebottle/B = W
				if(B.empty)
					user.changeNext_move(CLICK_CD_GRABBING)
					sound_hint()
					to_chat(user, span_notice("Bottle is empty..."))
					return
				user.visible_message(span_notice("[user] saturates [src] with the [B]."),span_notice("You saturates [src] with the [B]."), span_hear("You hear the sound of a saturating."))
				user.changeNext_move(CLICK_CD_GRABBING)
				sound_hint()
				saturated = TRUE
				B.empty = TRUE
				playsound(get_turf(src), 'modular_pod/sound/eff/potnpour.ogg', 80 , FALSE, FALSE)
				addtimer(CALLBACK(src, .proc/grow_berry), 50 SECONDS)
			else
				to_chat(user, span_notice("Aguo plant is saturated already."))
				return

	if(W.force >= 5)
		if(W.get_sharpness())
			user.visible_message(span_notice("[user] cuts the [src]."),span_notice("You cut [src]."), span_hear("You hear the sound of cutting."))
			user.changeNext_move(W.attack_delay)
			user.adjustFatigueLoss(5)
			sound_hint()
			playsound(loc,'modular_pod/sound/eff/hitgrass.ogg', 30, TRUE)
			W.damageItem("SOFT")
			qdel(src)

/obj/structure/flora/ausbushes/zarosli/aguo/proc/grow_berry()
	if(QDELETED(src) || (berry > 0))
		return
	berry++
	update_appearance()

/obj/structure/flora/ausbushes/zarosli/aguo/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(damage_amount)
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
			else
				playsound(src,'sound/effects/shelest.ogg', 50, TRUE)
		if(BURN)
			playsound(src,'sound/effects/shelest.ogg', 50, TRUE)

/obj/structure/flora/ausbushes/reedbush
	icon_state = "reedbush_1"

/obj/structure/flora/ausbushes/reedbush/Initialize(mapload)
	. = ..()
	icon_state = "reedbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/leafybush
	icon_state = "leafybush_1"

/obj/structure/flora/ausbushes/leafybush/Initialize(mapload)
	. = ..()
	icon_state = "leafybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/palebush
	icon_state = "palebush_1"

/obj/structure/flora/ausbushes/palebush/Initialize(mapload)
	. = ..()
	icon_state = "palebush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/stalkybush
	icon_state = "stalkybush_1"

/obj/structure/flora/ausbushes/stalkybush/Initialize(mapload)
	. = ..()
	icon_state = "stalkybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/grassybush
	icon_state = "grassybush_1"

/obj/structure/flora/ausbushes/grassybush/Initialize(mapload)
	. = ..()
	icon_state = "grassybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/fernybush
	icon_state = "fernybush_1"

/obj/structure/flora/ausbushes/fernybush/Initialize(mapload)
	. = ..()
	icon_state = "fernybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sunnybush
	icon_state = "sunnybush_1"

/obj/structure/flora/ausbushes/sunnybush/Initialize(mapload)
	. = ..()
	icon_state = "sunnybush_[rand(1, 3)]"

/obj/structure/flora/ausbushes/genericbush
	icon_state = "genericbush_1"

/obj/structure/flora/ausbushes/genericbush/Initialize(mapload)
	. = ..()
	icon_state = "genericbush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/pointybush
	icon_state = "pointybush_1"

/obj/structure/flora/ausbushes/pointybush/Initialize(mapload)
	. = ..()
	icon_state = "pointybush_[rand(1, 4)]"

/obj/structure/flora/ausbushes/lavendergrass
	icon_state = "lavendergrass_1"

/obj/structure/flora/ausbushes/lavendergrass/Initialize(mapload)
	. = ..()
	icon_state = "lavendergrass_[rand(1, 4)]"

/obj/structure/flora/ausbushes/ywflowers
	icon_state = "ywflowers_1"

/obj/structure/flora/ausbushes/ywflowers/Initialize(mapload)
	. = ..()
	icon_state = "ywflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/brflowers
	icon_state = "brflowers_1"

/obj/structure/flora/ausbushes/brflowers/Initialize(mapload)
	. = ..()
	icon_state = "brflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/ppflowers
	icon_state = "ppflowers_1"

/obj/structure/flora/ausbushes/ppflowers/Initialize(mapload)
	. = ..()
	icon_state = "ppflowers_[rand(1, 3)]"

/obj/structure/flora/ausbushes/sparsegrass
	icon_state = "sparsegrass_1"

/obj/structure/flora/ausbushes/sparsegrass/Initialize(mapload)
	. = ..()
	icon_state = "sparsegrass_[rand(1, 3)]"

/obj/structure/flora/ausbushes/fullgrass
	icon_state = "fullgrass_1"

/obj/structure/flora/ausbushes/fullgrass/Initialize(mapload)
	. = ..()
	icon_state = "fullgrass_[rand(1, 3)]"

/obj/item/kirbyplants
	name = "potted plant"
	icon = 'icons/obj/flora/plants.dmi'
	icon_state = "plant-01"
	desc = "A little bit of nature contained in a pot."
	plane = GAME_PLANE_UPPER
	layer = ABOVE_MOB_LAYER
	w_class = WEIGHT_CLASS_HUGE
	force = 10
	throwforce = 13
	throw_speed = 2
	throw_range = 4
	item_flags = NO_PIXEL_RANDOM_DROP

	/// Can this plant be trimmed by someone with TRAIT_BONSAI
	var/trimmable = TRUE
	var/list/static/random_plant_states

/obj/item/kirbyplants/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/tactical)
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_unwielded=10, force_wielded=10)
	AddElement(/datum/element/beauty, 500)

/obj/item/kirbyplants/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(trimmable && HAS_TRAIT(user,TRAIT_BONSAI) && isturf(loc) && I.get_sharpness())
		to_chat(user,span_notice("You start trimming [src]."))
		if(do_after(user,3 SECONDS,target=src))
			to_chat(user,span_notice("You finish trimming [src]."))
			change_visual()

/// Cycle basic plant visuals
/obj/item/kirbyplants/proc/change_visual()
	if(!random_plant_states)
		generate_states()
	var/current = random_plant_states.Find(icon_state)
	var/next = WRAP(current+1,1,length(random_plant_states))
	icon_state = random_plant_states[next]

/obj/item/kirbyplants/random
	icon = 'icons/obj/flora/_flora.dmi'
	icon_state = "random_plant"

/obj/item/kirbyplants/random/Initialize(mapload)
	. = ..()
	icon = 'icons/obj/flora/plants.dmi'
	if(!random_plant_states)
		generate_states()
	icon_state = pick(random_plant_states)

/obj/item/kirbyplants/proc/generate_states()
	random_plant_states = list()
	for(var/i in 1 to 25)
		var/number
		if(i < 10)
			number = "0[i]"
		else
			number = "[i]"
		random_plant_states += "plant-[number]"
	random_plant_states += "applebush"


/obj/item/kirbyplants/dead
	name = "RD's potted plant"
	desc = "A gift from the botanical staff, presented after the RD's reassignment. There's a tag on it that says \"Y'all come back now, y'hear?\"\nIt doesn't look very healthy..."
	icon_state = "plant-25"
	trimmable = FALSE

/obj/item/kirbyplants/photosynthetic
	name = "photosynthetic potted plant"
	desc = "A bioluminescent plant."
	icon_state = "plant-09"
	light_color = COLOR_BRIGHT_BLUE
	light_range = 3

/obj/item/kirbyplants/fullysynthetic
	name = "plastic potted plant"
	desc = "A fake, cheap looking, plastic tree. Perfect for people who kill every plant they touch."
	icon_state = "plant-26"
	custom_materials = (list(/datum/material/plastic = 8000))
	trimmable = FALSE

/obj/item/kirbyplants/fullysynthetic/Initialize(mapload)
	. = ..()
	icon_state = "plant-[rand(26, 29)]"

/obj/item/kirbyplants/potty
	name = "Potty the Potted Plant"
	desc = "A secret agent staffed in the station's bar to protect the mystical cakehat."
	icon_state = "potty"
	trimmable = FALSE

/obj/item/kirbyplants/fern
	name = "neglected fern"
	desc = "An old botanical research sample collected on a long forgotten jungle planet."
	icon_state = "fern"
	trimmable = FALSE

/obj/item/kirbyplants/fern/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_ALGAE, CELL_VIRUS_TABLE_GENERIC, rand(2,4), 5)

//a rock is flora according to where the icon file is
//and now these defines

/obj/structure/flora/rock
	icon_state = "basalt"
	desc = "A volcanic rock. Pioneers used to ride these babies for miles."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	density = TRUE
	/// Itemstack that is dropped when a rock is mined with a pickaxe
	var/obj/item/stack/mineResult = /obj/item/stack/ore/glass/basalt
	/// Amount of the itemstack to drop
	var/mineAmount = 20

/obj/structure/flora/rock/Initialize(mapload)
	. = ..()
	icon_state = "[icon_state][rand(1,3)]"

/obj/structure/flora/rock/attackby(obj/item/W, mob/user, params)
	if(!mineResult || W.tool_behaviour != TOOL_MINING)
		return ..()
	if(flags_1 & NODECONSTRUCT_1)
		return ..()
	to_chat(user, span_notice("You start mining..."))
	if(W.use_tool(src, user, 40, volume=50))
		to_chat(user, span_notice("You finish mining the rock."))
		if(mineResult && mineAmount)
			new mineResult(loc, mineAmount)
		SSblackbox.record_feedback("tally", "pick_used_mining", 1, W.type)
		qdel(src)

/obj/structure/flora/rock/pile
	icon_state = "lavarocks"
	desc = "A pile of rocks."

/obj/structure/barricade/flora/crystal/green
	icon_state = "greencrystal"
	name = "Green Crystal"
	desc = "Green сrystal."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	max_integrity = 50
//	proj_pass_rate = 20
//	pass_flags_self = LETPASSTHROW
	density = TRUE
	anchored = TRUE
	light_range = 2
	light_power = 4
	light_color = "#00dd78"
/*
/obj/structure/barricade/flora/crystal/green/make_debris()
	new /obj/item/shard/crystal/green(get_turf(src), 5)
*/
/obj/structure/barricade/flora/crystal/red
	icon_state = "redcrystal"
	name = "Red Crystal"
	desc = "Red сrystal."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	max_integrity = 50
//	proj_pass_rate = 20
//	pass_flags_self = LETPASSTHROW
	density = TRUE
	anchored = TRUE
	light_range = 2
	light_power = 4
	light_color = "#ff460e"
/*
/obj/structure/barricade/flora/crystal/red/make_debris()
	new /obj/item/shard/crystal/red(get_turf(src), 5)
*/
/obj/structure/barricade/flora/crystal/blue
	icon_state = "bluecrystal"
	name = "Blue Crystal"
	desc = "Blue сrystal."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	max_integrity = 50
//	proj_pass_rate = 20
//	pass_flags_self = LETPASSTHROW
	density = TRUE
	anchored = TRUE
	light_range = 2
	light_power = 4
	light_color = "#008eff"
/*
/obj/structure/barricade/flora/crystal/blue/make_debris()
	new /obj/item/shard/crystal/blue(get_turf(src), 5)
*/
/obj/structure/barricade/flora/crystal/purple
	icon_state = "purplecrystal"
	name = "Pink Crystal"
	desc = "Pink сrystal."
	icon = 'icons/obj/flora/rocks.dmi'
	resistance_flags = FIRE_PROOF
	max_integrity = 50
//	proj_pass_rate = 20
//	pass_flags_self = LETPASSTHROW
	density = TRUE
	anchored = TRUE
	light_range = 2
	light_power = 4
	light_color = "#e252ea"
/*
/obj/structure/barricade/flora/crystal/purple/make_debris()
	new /obj/item/shard/crystal/purple(get_turf(src), 5)
*/
/obj/structure/barricade/flora/crystal/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/climbable)

/obj/structure/barricade/flora/crystal/attack_foot(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	user.visible_message(span_notice("[user] kicks the [src]."),span_notice("You kick the [src]."), span_hear("You hear the sound of kicking."))
	user.changeNext_move(CLICK_CD_MELEE)
	user.adjustFatigueLoss(10)
	playsound(get_turf(src), 'sound/effects/beatfloorhand.ogg', 80 , FALSE, FALSE)
	sound_hint()
	var/damagee = ((GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH)/2) + 5)
	take_damage(damagee, BRUTE, "melee", 1)

/obj/structure/barricade/flora/crystal/purple/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/effect/decal/cleanable/glass/crystal/purple(get_turf(src))
		playsound(src, "shatter", 70, TRUE)
	qdel(src)

/obj/structure/barricade/flora/crystal/green/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/effect/decal/cleanable/glass/crystal/green(get_turf(src))
		playsound(src, "shatter", 70, TRUE)
	qdel(src)

/obj/structure/barricade/flora/crystal/red/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/effect/decal/cleanable/glass/crystal/red(get_turf(src))
		playsound(src, "shatter", 70, TRUE)
	qdel(src)

/obj/structure/barricade/flora/crystal/blue/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/effect/decal/cleanable/glass/crystal/blue(get_turf(src))
		playsound(src, "shatter", 70, TRUE)
	qdel(src)

/*
	if(!(flags_1 & NODECONSTRUCT_1))
		if(!disassembled)
			playsound(src, "shatter", 70, TRUE)
			qdel(src)
			make_debris()
	else
		qdel(src)
		make_debris()
*/

//Jungle grass

/obj/structure/flora/grass/jungle
	name = "jungle grass"
	desc = "Thick alien flora."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "grassa"


/obj/structure/flora/grass/jungle/Initialize(mapload)
	icon_state = "[icon_state][rand(1, 5)]"
	. = ..()

/obj/structure/flora/grass/jungle/b
	icon_state = "grassb"

//Jungle rocks

/obj/structure/flora/rock/jungle
	icon_state = "rock"
	desc = "A pile of rocks."
	icon = 'icons/obj/flora/jungleflora.dmi'
	density = FALSE

/obj/structure/flora/rock/jungle/Initialize(mapload)
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,5)]"


//Jungle bushes

/obj/structure/flora/junglebush
	name = "bush"
	desc = "A wild plant that is found in jungles."
	icon = 'icons/obj/flora/jungleflora.dmi'
	icon_state = "busha"

/obj/structure/flora/junglebush/Initialize(mapload)
	icon_state = "[icon_state][rand(1, 3)]"
	. = ..()

/obj/structure/flora/junglebush/b
	icon_state = "bushb"

/obj/structure/flora/junglebush/c
	icon_state = "bushc"

/obj/structure/flora/junglebush/large
	icon_state = "bush"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	pixel_x = -16
	pixel_y = -12
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE

/obj/structure/flora/rock/pile/largejungle
	name = "rocks"
	icon_state = "rocks"
	icon = 'icons/obj/flora/largejungleflora.dmi'
	density = FALSE
	pixel_x = -16
	pixel_y = -16

/obj/structure/flora/rock/pile/largejungle/Initialize(mapload)
	. = ..()
	icon_state = "[initial(icon_state)][rand(1,3)]"
