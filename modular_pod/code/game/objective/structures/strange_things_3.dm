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
	count = 150
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
