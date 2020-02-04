/obj/item/stealthboy
	name = "Steatlh Boy"
	desc = "The RobCo Stealth Boy 3001 is a personal stealth device worn on one's wrist. It generates a modulating field that transmits the reflected light from one side of an object to the other, making a person much harder to notice (but not completely invisible)."
	icon = 'icons/obj/device.dmi'
	icon_state = "stealthboy"
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/obj/effect/temp_visual/stealthboy/stealth = null
	var/saved_appearance = null

/obj/item/stealthboy/New()
	..()	
	var/obj/effect/temp_visual/stealthboy
	saved_appearance = initial(appearance)

/obj/item/stealthboy/dropped()
	..()
	disrupt()

/obj/item/stealthboy/equipped()
	..()
	disrupt()

/obj/item/stealthboy/proc/check_sprite(atom/target)
	if(target.icon_state in icon_states(target.icon))
		return TRUE
	return FALSE

/obj/item/stealthboy/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	if(stealth)
		eject_all()
		stealth = null
		to_chat(user, "<span class='notice'>You deactivate \the [src].</span>")
	else
		C.activate(user, saved_appearance, src)
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")