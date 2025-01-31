// grenade launcher
/obj/item/gun/ballistic/revolver/grenadelauncher
	pin = /obj/item/firing_pin
	skill_melee = SKILL_IMPACT_WEAPON_TWOHANDED
	skill_ranged = SKILL_GRENADE_LAUNCHER

/obj/item/gun/ballistic/shotgun/grenadelauncher/batata
	name = "40mm Batata Frita explosive fragmentation launcher"
	desc = "A pump-operated grenade launcher that filled the need for yet another firearm instead of an important invention or update."
	icon = 'modular_septic/icons/obj/items/guns/48x32.dmi'
	lefthand_file = 'modular_septic/icons/obj/items/guns/inhands/shotgun_lefthand.dmi'
	righthand_file = 'modular_septic/icons/obj/items/guns/inhands/shotgun_righthand.dmi'
	inhand_icon_state = "chlake"
	icon_state = "chinalake"
	base_icon_state = "chinalake"
	fire_sound = 'modular_septic/sound/weapons/guns/launcher/batata.ogg'
	far_fire_sound = 'mojave/sound/ms13weapons/distant_shots/that_gun.ogg'
	lock_back_sound = 'modular_septic/sound/weapons/guns/launcher/batata_lock_back.ogg'
	bolt_drop_sound = 'modular_septic/sound/weapons/guns/launcher/batata_lockin.ogg'
	rack_sound = 'modular_septic/sound/weapons/guns/launcher/batata_rack.ogg'
	load_sound = list(
		'modular_septic/sound/weapons/guns/launcher/batata_load1.ogg', \
		'modular_septic/sound/weapons/guns/launcher/batata_load2.ogg', \
		'modular_septic/sound/weapons/guns/launcher/batata_load3.ogg', \
	)
	mag_type = /obj/item/ammo_box/magazine/internal/grenadelauncher/batata
	pin = /obj/item/firing_pin
	slot_flags = null
	can_suppress = FALSE
	fire_delay = 3 SECONDS
	w_class = WEIGHT_CLASS_HUGE
	skill_melee = SKILL_IMPACT_WEAPON_TWOHANDED
	skill_ranged = SKILL_GRENADE_LAUNCHER
	bolt_type = BOLT_TYPE_LOCKING
	empty_icon_state = FALSE
