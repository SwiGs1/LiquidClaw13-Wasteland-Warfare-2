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
	var/stealth = FALSE

/obj/item/stealthboy/proc/stealth()
    var/mob/living/carbon/human/U = affecting
		if(!U)
		return
		if(stealth)
		cancel_stealth()
		else
	stealth = !stealth
	animate(U, alpha = 50,time = 15)
	U.visible_message("<span class='warning'>[U.name] vanishes into thin air!</span>", \
						"<span class='notice'>You are now mostly invisible to normal detection.</span>")


/obj/item/stealthboy/proc/cancel_stealth()
	var/mob/living/carbon/human/U = affecting
	if(!U)
		return 0
	if(stealth)
		stealth = !stealth
		animate(U, alpha = 255, time = 15)
		U.visible_message("<span class='warning'>[U.name] appears from thin air!</span>", \
						"<span class='notice'>You are now visible.</span>")
		return 1
	return 0
