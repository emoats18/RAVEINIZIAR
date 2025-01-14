// gangstalker
/obj/item/ammo_casing/c38
	name = "Bullet .38"
	desc = "A such caliber."
	icon_state = "c38"
	base_icon_state = "c38"
	bounce_sound = list('modular_septic/sound/weapons/guns/pistol/pistol_shell1.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell2.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell3.ogg')
	bounce_volume = 35
	stack_type = /obj/item/ammo_box/magazine/ammo_stack/c38

/obj/item/ammo_casing/c38/pluspee
	name = ".38 suspicious +P bullet casing"
	desc = "A .38 suspicious bullet casing."
	icon_state = "c38"
	base_icon_state = "c38"
	projectile_type = /obj/projectile/bullet/c38/pluspee
	bounce_sound = list('modular_septic/sound/weapons/guns/pistol/pistol_shell1.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell2.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell3.ogg')
	bounce_volume = 35
	stack_type = /obj/item/ammo_box/magazine/ammo_stack/c38/pluspee

/obj/item/ammo_casing/a357
	name = ".357 magnum bullet casing"
	desc = "A .357 magnum bullet casing."
	icon_state = "c357"
	base_icon_state = "c357"
	bounce_sound = list('modular_septic/sound/weapons/guns/pistol/pistol_shell1.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell2.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell3.ogg')
	bounce_volume = 35
	stack_type = /obj/item/ammo_box/magazine/ammo_stack/a357

/obj/item/ammo_casing/a500
	name = ".500 magnum bullet casing"
	desc = "A .500 magnum bullet casing."
	icon_state = "c357"
	base_icon_state = "c357"
	caliber = CALIBER_500
	projectile_type = /obj/projectile/bullet/a500
	bounce_sound = list('modular_septic/sound/weapons/guns/pistol/pistol_shell1.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell2.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell3.ogg')
	bounce_volume = 35
	stack_type = /obj/item/ammo_box/magazine/ammo_stack/a500

/obj/item/ammo_casing/pulser
	name = "paralyzer (pulser) bullet casing"
	desc = "A .paralyzer (pulser) bullet casing."
	icon_state = "pulser"
	base_icon_state = "pulser"
	caliber = CALIBER_PULSER
	projectile_type = /obj/projectile/bullet/pulser
	bounce_sound = list('modular_septic/sound/weapons/guns/pistol/pistol_shell1.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell2.ogg', 'modular_septic/sound/weapons/guns/pistol/pistol_shell3.ogg')
	bounce_volume = 35
	stack_type = /obj/item/ammo_box/magazine/ammo_stack/pulser
