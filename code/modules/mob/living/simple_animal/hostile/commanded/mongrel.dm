/mob/living/simple_animal/hostile/commanded/mongrel
	name = "Legion mongrel"
	desc = "Legion mongrels are dogs owned and bred by the Houndmasters of Caesar's Legion. Mongrels are mainly used in combat and scouting missions by the Legion"
	icon = 'icons/fallout/mobs/animal.dmi'
	icon_state = "mongrel"
	icon_living = "mongrel"
	icon_dead = "mongrel_dead"
	icon_gib = "gib"
	maxHealth = 90
	health = 90
	faction = list("Legion")
	emote_hear = list("barks", "growls", "howls")
	emote_see = list("bears its teeth", "stares aggressively", "shakes its head", "looks around")
	turns_per_move = 1
	wander = 1
	stop_automated_movement_when_pulled = 1
	response_help   = "pets"
	response_disarm = "shoves aside"
	response_harm   = "kicks"
	known_commands = list("stay", "stop", "attack", "follow")
	healable = 1
	stat_attack = UNCONSCIOUS
	melee_damage_lower = 30
	melee_damage_upper = 40
	aggro_vision_range = 15
 //   idle_vision_range = 7
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	move_to_delay = 2
	speed = 1
	//sound_speak_chance = 5
	//sound_speak = list('sound/f13npc/dog_charge1.ogg','sound/f13npc/dog_charge2.ogg','sound/f13npc/dog_charge3.ogg')
	//aggro_sound_chance = 50
	//aggro_sound = list('sound/f13npc/dog_alert1.ogg','sound/f13npc/dog_alert2.ogg','sound/f13npc/dog_alert3.ogg')
	death_sound = 'sound/f13npc/dog_death.ogg'
	butcher_results = list(/obj/item/stack/sheet/animalhide/wolf = 1, \
	/obj/item/reagent_containers/food/snacks/meat/slab/wolf = 1)

/mob/living/simple_animal/hostile/commanded/mongrel/proc/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	. = ..()
	if (!.)
		emote("barks and shows its teeth!")

/mob/living/simple_animal/hostile/commanded/mongrel/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if (M.a_intent == I_HARM)
		emote("barks and shows its teeth!")
