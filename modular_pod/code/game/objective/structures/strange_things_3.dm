/obj/structure/wayto/podpol
	name = "Подпол"
	desc = "Что там?"
	icon = 'modular_pod/icons/obj/things/things_4.dmi'
	icon_state = "podpol"
	anchored = TRUE
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN
	var/up = FALSE
	var/down = TRUE

/obj/structure/wayto/podpol/attack_hand(mob/living/carbon/human/user, list/modifiers)
	. = ..()
	if(.)
		return
	use(user, TRUE)

/obj/structure/wayto/podpol/proc/use(mob/living/carbon/human/user, going_up = TRUE, is_ghost = FALSE)
	if(user.truerole != "Капнобатай")
		to_chat(user, span_notice("Меня там пацаны не примут."))
		return
	if(!in_range(src, user) || user.incapacitated())
		return
	if(user.loc != loc)
		return
	if(!do_after(user, 5, target = src))
		to_chat(user, span_danger(xbox_rage_msg()))
		return
	if(up)
		var/turf/above_turf = SSmapping.get_turf_above(get_turf(src))
		user.forceMove(above_turf)
	if(down)
		var/turf/below_turf = SSmapping.get_turf_below(get_turf(src))
		user.forceMove(below_turf)

/obj/structure/wayto/podpol/up
	icon_state = "podpol2"
	up = TRUE
	down = FALSE

/obj/structure/table/goody
	name = "Стол"
	desc = "Хорошо. Славно. Классно."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "tablera"
	smoothing_flags = NONE
	smoothing_groups = null
	canSmoothWith = null
	frame = null

/obj/structure/bed/mattress
	name = "Матрас"
	desc = "Главное отоспаться."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "mattress"

/obj/structure/closet/crate/freezer/podozl
	name = "Холодильник"
	desc = "В таком состоянии... Каким-то образом охлаждает."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "holodos"
	open_sound = 'modular_pod/sound/eff/open_holodos.ogg'
	close_sound = 'modular_pod/sound/eff/close_holodos.ogg'
	door_anim_time = 0

/particles/fire
	icon = 'icons/effects/particles/bonfire.dmi'
	icon_state = "bonfire"
	width = 64
	height = 128
	count = 100
	spawning = 7
	lifespan = 2 SECONDS
	fade = 1 SECONDS
	color = 0
	color_change = 0.1
	gradient = list("#FBDB28", "#FCE6B6", "#FF532B")
	position = generator("box", list(-16,-12,-32), list(16,32,32), NORMAL_RAND)
	drift = generator("vector", list(-0.1,0), list(0.1,0.2), UNIFORM_RAND)
	scale = generator("vector", list(0.5,0.5), list(2,2), NORMAL_RAND)
	spin = generator("num", list(-30,30), NORMAL_RAND)

/particles/fog
	icon = 'icons/effects/particles/smoke.dmi'
	icon_state = list("chill_1" = 2, "chill_2" = 2, "chill_3" = 1)

/particles/fog/breath
	count = 1
	spawning = 1
	lifespan = 1 SECONDS
	fade = 0.5 SECONDS
	grow = 0.05
	spin = 2
	color = "#fcffff77"

/obj/structure/lighterfire
	name = "Бочка"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "barrel"
	desc = "Завораживающе."
	density = 1
	anchored = 1
	light_range = 4
	light_power = 1
	light_color = "#e19644"

/obj/structure/lighterfire/New()
	..()
	add_particle_holder("embers", /atom/movable/particle_holder/fire)
	add_particle_holder("smoke", /atom/movable/particle_holder/fire_smoke)

/datum/looping_sound/musicloop
	mid_sounds = list('modular_pod/sound/mus/boombox.ogg' = 1)
	mid_length = 161 SECONDS
	volume = 70
	falloff_exponent = 10
	falloff_distance = 3

/obj/item/musicshit/boombox
	name = "Бумбокс"
	desc = "А это уже другое дело."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "boombox"
	var/datum/looping_sound/musicloop/soundloop
	var/playc = FALSE

/obj/item/musicshit/boombox/Initialize(mapload)
	. = ..()
	soundloop = new(src,  FALSE)

/obj/item/musicshit/boombox/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/item/musicshit/boombox/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(playc)
		playc = FALSE
		soundloop.stop()
//		STOP_PROCESSING(SSobj, src)
	else
		playc = TRUE
		soundloop.start()
	user.changeNext_move(CLICK_CD_MELEE)
//		START_PROCESSING(SSobj, src)

/*
/obj/item/musicshit/boombox/process()
	if(playc)
		for(var/mob/M in range(10, src))
			if(!M || !M.client)
				continue
			playsound(get_turf(src), 'modular_pod/sound/mus/boombox.ogg', volume = 60, falloff_exponent = 11, falloff_distance = 3, channel = CHANNEL_JUKEBOX, use_reverb = TRUE)
			playc = TRUE
	else
		for(var/mob/L in range(10, src))
			if(!L || !L.client)
				continue
			L.stop_sound_channel(CHANNEL_JUKEBOX)
*/

/obj/structure/chair/podpolsit
	name = "Трон"
	desc = "Пора узнать, что такое сила."
	icon = 'modular_pod/icons/obj/things/things_5.dmi'
	icon_state = "sit"
	max_integrity = 10000

/obj/structure/chair/podpolsit/deconstruct()
	new /obj/item/podpol_weapon/sword/steel(get_turf(src))

/obj/structure/chair/podpolsit/post_buckle_mob(mob/living/M)
	. = ..()
	if(iscarbon(M))
		M.pixel_y += 5
		M.visible_message(span_notice("[M] усаживается на [src]."),span_notice("Я усаживаюсь на [src]."), span_hear("Я слышу чё-то."))
		if(do_after(M, 3 SECONDS, target=src))
			if(!M.buckled)
				to_chat(M, span_meatymeat("Надо на трон сесть!"))
				return
			to_chat(M, span_meatymeat("Я ощущаю какой-то пиздец!"))
			M.fully_heal(TRUE)

/obj/structure/chair/podpolsit/post_unbuckle_mob(mob/living/M)
	if(iscarbon(M))
		M.pixel_y -= 5

/obj/structure/column/power
	name = "Статуя"
	desc = "То, что внушает страх."
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "power"
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER
	anchored = 1
	density = 1
	obj_flags = NONE
	max_integrity = 1000

/obj/effect/turf_decal/tile/metalpodpol
	name = "Плитка"
	icon = 'modular_pod/icons/obj/things/things_3.dmi'
	icon_state = "metal1"
	layer = TURF_PLATING_DECAL_LAYER
	alpha = 255

/obj/effect/turf_decal/tile/metalpodpol/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "metal2"
