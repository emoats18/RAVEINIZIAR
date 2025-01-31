/obj/item/storage/belt/military
	color = null

/obj/item/storage/belt/military/army/pioneer
	name = "pioneer chestrig"
	desc = "A belt used by pioneers to lug their equipment around."

/obj/item/storage/belt/army/pioneer/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 6
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 20
	STR.set_holdable(list(
		/obj/item/crowbar,
		/obj/item/screwdriver,
		/obj/item/weldingtool,
		/obj/item/wirecutters,
		/obj/item/wrench,
		/obj/item/multitool,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/analyzer,
		/obj/item/extinguisher/mini,
		/obj/item/radio,
		/obj/item/clothing/gloves,
		/obj/item/resonator,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/shovel,
		/obj/item/stack/sheet/animalhide,
		/obj/item/stack/sheet/sinew,
		/obj/item/stack/sheet/bone,
		/obj/item/lighter,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/reagent_containers/food/drinks/bottle,
		/obj/item/stack/medical,
		/obj/item/knife,
		/obj/item/reagent_containers/hypospray,
		/obj/item/gps,
		/obj/item/storage/bag/ore,
		/obj/item/survivalcapsule,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/reagent_containers/pill,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/ore,
		/obj/item/reagent_containers/food/drinks,
		/obj/item/organ/regenerative_core,
		/obj/item/wormhole_jaunter,
		/obj/item/stack/marker_beacon,
		))

/obj/item/storage/belt/blackin
	name = "Lockpick Belt"
	desc = "A belt used for lockpicks-holding."
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "lockpick_belt"
	inhand_icon_state = "militarywebbing"
	worn_icon = 'icons/mob/clothing/belt.dmi'
	worn_icon_state = "lockpick_belt"
	var/empty = FALSE
//	pickup_sound = 'modular_septic/sound/armor/equip/backpack_pickup.ogg'
//	drop_sound = 'modular_septic/sound/armor/equip/backpack_drop.ogg'
//	equip_sound = 'modular_septic/sound/armor/equip/backpack_wear.ogg'

/obj/item/storage/belt/blackin/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 20
	STR.set_holdable(list(
		/obj/item/akt/lockpick,
		/obj/item/melee/bita/dark,
		))

/obj/item/storage/belt/blackin/full/PopulateContents()
	if(empty)
		return
	var/static/items_inside = list(
		/obj/item/akt/lockpick/square = 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/belt/keychain
	name = "Keychain"
	desc = "A keychain!"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "keychain"
	inhand_icon_state = "militarywebbing"
	worn_icon = 'icons/mob/clothing/belt.dmi'
	worn_icon_state = "lockpick_belt"
	drop_sound = 'modular_septic/sound/effects/fallsmall.ogg'
	slot_flags = ITEM_SLOT_POCKETS|ITEM_SLOT_ID|ITEM_SLOT_BELT

/obj/item/storage/belt/keychain/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 8
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 20
	STR.set_holdable(list(
		/obj/item/key/podpol,
		/obj/item/keycard/akt,
		))

/obj/item/storage/belt/keychain/update_icon_state()
	switch(contents.len)
		if(1)
			icon_state = "[initial(icon_state)]_1"
		if(2)
			icon_state = "[initial(icon_state)]_2"
		if(3 to INFINITY)
			icon_state = "[initial(icon_state)]_3"
		if(0)
			icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/storage/belt/pouch
	name = "Pouch"
	desc = "What's in it?"
	icon = 'modular_pod/icons/obj/items/otherobjects.dmi'
	icon_state = "bag"
	worn_icon = null
	worn_icon_state = null
	lefthand_file = 'modular_septic/icons/mob/inhands/remis_lefthand.dmi'
	righthand_file = 'modular_septic/icons/mob/inhands/remis_righthand.dmi'
	inhand_icon_state = "darkbag"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_POCKETS | ITEM_SLOT_ID
	storage_flags = NONE
	carry_weight = 1 KILOGRAMS

/obj/item/storage/belt/pouch/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 3
	STR.max_w_class = WEIGHT_CLASS_NORMAL
	STR.max_combined_w_class = 20
	STR.set_holdable(list(
		/obj/item/stack/eviljewel,
		))

/obj/item/storage/belt/pouch/update_icon_state()
	switch(contents.len)
		if(1 to INFINITY)
			icon_state = "[initial(icon_state)]_full"
		else
			icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/storage/belt/pouch/submerc

/obj/item/storage/belt/pouch/venturer

/obj/item/storage/belt/pouch/venturer/noble

/obj/item/storage/belt/pouch/submerc/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/eviljewel = 1,
		/obj/item/stack/eviljewel/max = 2)
	generate_items_inside(items_inside,src)

/obj/item/storage/belt/pouch/venturer/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/eviljewel/twenty = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/belt/pouch/venturer/noble/PopulateContents()
	var/static/items_inside = list(
		/obj/item/stack/eviljewel/max = 1)
	generate_items_inside(items_inside,src)
