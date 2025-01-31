/obj/item/clothing/suit
	icon = 'icons/obj/clothing/suits.dmi'
	name = "suit"
	var/fire_resist = T0C+100
	allowed = list(/obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman)
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 0, ACID = 0)
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	slot_flags = ITEM_SLOT_OCLOTHING
	var/blood_overlay_type = "suit"
	limb_integrity = 0 // disabled for most exo-suits

/obj/item/clothing/suit/Initialize(mapload)
	. = ..()
	setup_shielding()

/obj/item/clothing/suit/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	/* SEPTIC EDIT REMOVAL
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
	if(HAS_BLOOD_DNA(src))
		. += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")
	*/
	//SEPTIC EDIT BEGIN
	if(damaged_clothes)
		var/mutable_appearance/damage_appearance = mutable_appearance('modular_septic/icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
		damage_appearance.color = "#000000"
		. += damage_appearance
	if(HAS_BLOOD_DNA(src))
		. += mutable_appearance('modular_septic/icons/effects/blood.dmi', "[blood_overlay_type]blood")
	if(HAS_SHIT_DNA(src))
		var/mutable_appearance/shit_appearance = mutable_appearance('modular_septic/icons/effects/shit.dmi', "[blood_overlay_type]shit")
		shit_appearance.color = COLOR_BROWN_SHIT
		. += shit_appearance
	if(HAS_CUM_DNA(src))
		var/mutable_appearance/cummy = mutable_appearance('modular_septic/icons/effects/cum.dmi', "[blood_overlay_type]cum")
		cummy.color = COLOR_WHITE_CUM
		. += cummy
	if(HAS_FEMCUM_DNA(src))
		var/mutable_appearance/femcummy = mutable_appearance('modular_septic/icons/effects/femcum.dmi', "[blood_overlay_type]femcum")
		femcummy.color = COLOR_WHITE_FEMCUM
		. += femcummy
	//SEPTIC EDIT END

	var/mob/living/carbon/human/M = loc
	if(!ishuman(M) || !M.w_uniform)
		return
	var/obj/item/clothing/under/U = M.w_uniform
	if(istype(U) && U.attached_accessory)
		var/obj/item/clothing/accessory/A = U.attached_accessory
		if(A.above_suit)
			. += U.accessory_overlay

/obj/item/clothing/suit/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_wear_suit()

/**
 * Wrapper proc to apply shielding through AddComponent().
 * Called in /obj/item/clothing/Initialize().
 * Override with an AddComponent(/datum/component/shielded, args) call containing the desired shield statistics.
 * See /datum/component/shielded documentation for a description of the arguments
 **/
/obj/item/clothing/suit/proc/setup_shielding()
	return

/obj/item/clothing/pants
	name = "Pants"
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	equip_sound = 'modular_pod/sound/eff/equip_armor.ogg'
	siemens_coefficient = 0.5
	slot_flags = ITEM_SLOT_PANTS
	attack_verb_continuous = list("challenges")
	attack_verb_simple = list("challenge")
//	var/transfer_prints = FALSE
	var/blood_overlay_type = "pants"
	strip_delay = 20
	equip_delay_other = 40
	body_parts_covered = GROIN|LEGS

/obj/item/clothing/pants/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	/* SEPTIC EDIT REMOVAL
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
	if(HAS_BLOOD_DNA(src))
		. += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")
	*/
	//SEPTIC EDIT BEGIN
	if(damaged_clothes)
		var/mutable_appearance/damage_appearance = mutable_appearance('modular_septic/icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
		damage_appearance.color = "#000000"
		. += damage_appearance
	if(HAS_BLOOD_DNA(src))
		. += mutable_appearance('modular_septic/icons/effects/blood.dmi', "[blood_overlay_type]blood")
	if(HAS_SHIT_DNA(src))
		var/mutable_appearance/shit_appearance = mutable_appearance('modular_septic/icons/effects/shit.dmi', "[blood_overlay_type]shit")
		shit_appearance.color = COLOR_BROWN_SHIT
		. += shit_appearance
	if(HAS_CUM_DNA(src))
		var/mutable_appearance/cummy = mutable_appearance('modular_septic/icons/effects/cum.dmi', "[blood_overlay_type]cum")
		cummy.color = COLOR_WHITE_CUM
		. += cummy
	if(HAS_FEMCUM_DNA(src))
		var/mutable_appearance/femcummy = mutable_appearance('modular_septic/icons/effects/femcum.dmi', "[blood_overlay_type]femcum")
		femcummy.color = COLOR_WHITE_FEMCUM
		. += femcummy
	//SEPTIC EDIT END

/obj/item/clothing/pants/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_pants()

/*
/obj/item/clothing/pants/equipped(datum/source, mob/equipper, slot)
	. = ..()

	if(slot != ITEM_SLOT_PANTS)
		return

	if(equipper.get_item_by_slot(ITEM_SLOT_BELT))
		var/obj/item/equipped_item = equipper.get_item_by_slot(ITEM_SLOT_BELT)
		if(istype(equipped_item, /obj/item/storage/belt))
			var/obj/item/storage/belt/belter = equipped_item
			if(belter.realBelt)
				slowdown = 0
		else
			slowdown = 5
*/

/obj/item/clothing/pants/dropped(mob/living/user)
	. = ..()
//	slowdown = 0

	if(user.get_item_by_slot(ITEM_SLOT_BELT))
		var/obj/item/equipped_item = user.get_item_by_slot(ITEM_SLOT_BELT)
		user.dropItemToGround(equipped_item)


/obj/item/clothing/pants/venturer
	name = "Blue Pants"
	desc = "Midnightberry pants!"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "midpants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "midpants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 800 GRAMS
	armor = list(MELEE = 3, BULLET = 3, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 5, ACID = 5, WOUND = 3)

/obj/item/clothing/pants/dark
	name = "Dark Pants"
	desc = "Tight chaotic pants. So cool!"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "darkpants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "darkpants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 800 GRAMS
	armor = list(MELEE = 3, BULLET = 3, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 5, ACID = 5, WOUND = 3)

/obj/item/clothing/pants/aktliver
	name = "Skin Pants"
	desc = "These pants are made from larva leather."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "aktpants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "aktpants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 800 GRAMS
	armor = list(MELEE = 2, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 10, ACID = 10, WOUND = 2)

/obj/item/clothing/pants/pinker
	name = "Pinker Pants"
	desc = "CRAZY!"
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "pinker"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "pinker"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 100
	integrity_failure = 0.1
	limb_integrity = 90
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 800 GRAMS
	armor = list(MELEE = 2, BULLET = 5, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, FIRE = 10, ACID = 10, WOUND = 2)

/obj/item/clothing/pants/leatherpants
	name = "Leather Pants"
	desc = "Its made of brown frog leather."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "leatherpants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "leatherpants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	max_integrity = 400
	integrity_failure = 0.1
	limb_integrity = 350
	repairable_by = /obj/item/stack/ballistic
	carry_weight = 800 GRAMS
	subarmor = list(SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE, \
				EDGE_PROTECTION = 35, \
				CRUSHING = 7, \
				CUTTING = 25, \
				PIERCING = 20, \
				IMPALING = 10, \
				LASER = 7, \
				ENERGY = 0, \
				BOMB = 8, \
				BIO = 0, \
				FIRE = 3, \
				ACID = 3, \
				MAGIC = 0, \
				WOUND = 5, \
				ORGAN = 3)

/obj/item/clothing/pants/steelmailpants
	name = "Chainmail Pants"
	desc = "Steel chainmail pants. A little weird."
	icon = 'modular_pod/icons/obj/clothing/pants.dmi'
	icon_state = "steelmailpants"
	worn_icon = 'modular_pod/icons/mob/clothing/pants.dmi'
	worn_icon_state = "steelmailpants"
	armor_broken_sound = "light"
	armor_damaged_sound = "light"
	carry_weight = 800 GRAMS
	max_integrity = 500
	integrity_failure = 0.1
	limb_integrity = 450
	repairable_by = /obj/item/stack/ballistic
	armor = list(MELEE = 1, \
				BULLET = 0, \
				LASER = 0, \
				ENERGY = 20, \
				BOMB = 20, \
				BIO = 0, \
				FIRE = 50, \
				ACID = 45, \
				WOUND = 10)
	subarmor = list(SUBARMOR_FLAGS = SUBARMOR_FLEXIBLE, \
				EDGE_PROTECTION = 65, \
				CRUSHING = 4, \
				CUTTING = 35, \
				PIERCING = 10, \
				IMPALING = 12, \
				LASER = 1, \
				ENERGY = 0, \
				BOMB = 8, \
				BIO = 0, \
				FIRE = 2, \
				ACID = 2, \
				MAGIC = 0, \
				WOUND = 3, \
				ORGAN = 2)

/obj/item/clothing/pants/steelmailpants/Initialize(mapload)
	. = ..()
	var/datum/component/shuffling/shuffling = GetComponent(/datum/component/shuffling)
	if(shuffling)
		shuffling.override_squeak_sounds = list('modular_septic/sound/armor/chainmail_stereo1.ogg'=1,
												'modular_septic/sound/armor/chainmail_stereo2.ogg'=1,
												'modular_septic/sound/armor/chainmail_stereo3.ogg'=1)
		shuffling.volume = 30
		shuffling.sound_falloff_exponent = 20

/obj/item/clothing/oversuit
	name = "Oversuit"
	gender = PLURAL
	icon = 'modular_pod/icons/obj/clothing/oversuit.dmi'
	worn_icon = 'modular_pod/icons/mob/clothing/oversuit.dmi'
	drop_sound = 'sound/items/handling/cloth_drop.ogg'
	pickup_sound = 'sound/items/handling/cloth_pickup.ogg'
	siemens_coefficient = 0.5
	slot_flags = ITEM_SLOT_OVERSUIT
	attack_verb_continuous = list("challenges")
	attack_verb_simple = list("challenge")
//	var/transfer_prints = FALSE
	var/blood_overlay_type = "suit"
	strip_delay = 20
	equip_delay_other = 40

/obj/item/clothing/oversuit/worn_overlays(mutable_appearance/standing, isinhands = FALSE)
	. = ..()
	if(isinhands)
		return

	/* SEPTIC EDIT REMOVAL
	if(damaged_clothes)
		. += mutable_appearance('icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
	if(HAS_BLOOD_DNA(src))
		. += mutable_appearance('icons/effects/blood.dmi', "[blood_overlay_type]blood")
	*/
	//SEPTIC EDIT BEGIN
	if(damaged_clothes)
		var/mutable_appearance/damage_appearance = mutable_appearance('modular_septic/icons/effects/item_damage.dmi', "damaged[blood_overlay_type]")
		damage_appearance.color = "#000000"
		. += damage_appearance
	if(HAS_BLOOD_DNA(src))
		. += mutable_appearance('modular_septic/icons/effects/blood.dmi', "[blood_overlay_type]blood")
	if(HAS_SHIT_DNA(src))
		var/mutable_appearance/shit_appearance = mutable_appearance('modular_septic/icons/effects/shit.dmi', "[blood_overlay_type]shit")
		shit_appearance.color = COLOR_BROWN_SHIT
		. += shit_appearance
	if(HAS_CUM_DNA(src))
		var/mutable_appearance/cummy = mutable_appearance('modular_septic/icons/effects/cum.dmi', "[blood_overlay_type]cum")
		cummy.color = COLOR_WHITE_CUM
		. += cummy
	if(HAS_FEMCUM_DNA(src))
		var/mutable_appearance/femcummy = mutable_appearance('modular_septic/icons/effects/femcum.dmi', "[blood_overlay_type]femcum")
		femcummy.color = COLOR_WHITE_FEMCUM
		. += femcummy
	//SEPTIC EDIT END

/obj/item/clothing/oversuit/update_clothes_damaged_state(damaged_state = CLOTHING_DAMAGED)
	..()
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_oversuit()