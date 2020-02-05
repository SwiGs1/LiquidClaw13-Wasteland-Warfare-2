//Legion Mongrel Directory - Swigs

/mob/living/simple_animal/hostile/commanded/mongrel
	name = "Legion mongrel"
	desc = "Legion mongrels are dogs owned and bred by the Houndmasters of Caesar's Legion. Mongrels are mainly used in combat and scouting missions by the Legion"

	icon = 'icons/fallout/mobs/animal.dmi'
	icon_state = "mongrel"
	icon_living = "mongrel"
	icon_dead = "mongrel_dead"
	icon_gib = "gib"
	health = 125
	maxHealth = 125
	move_to_delay = 1
	density = 1
	response_help  = "pets"
	response_disarm = "shoves"
	response_harm   = "kicks"
	speak = list("Grrr", "Woof!", "Bark!", "Hooow!")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks!", "woofs!", "yaps.","pants.", "growls.", "growls.")
	emote_see = list("shakes its head.", "chases its tail.","shivers.", "bears it's teeth.", "stares aggressively.")
	wander = 1
	stop_automated_movement_when_pulled = 1
	faction = list("Legion")
	faction_enemy = list("hostile","NCR","BOS")
	see_in_dark = 5
	speak_chance = 1
	turns_per_move = 10
	attacktext = "bites"
	melee_damage_lower = 20
	melee_damage_upper = 35
	attack_sound = 'sound/weapons/bite.ogg'
	death_sound = 'sound/f13npc/dog_death.ogg'
	butcher_results = list(/obj/item/stack/sheet/animalhide/wolf = 1, \
	/obj/item/reagent_containers/food/snacks/meat/slab/wolf = 1)
	known_commands = list("stay", "stop", "attack", "follow", "defend", "enemy", "friend", "pull")

/mob/living/simple_animal/hostile/commanded/mongrel/listen(var/mob/speaker, var/text)
	..()
	if(stance == COMMANDED_DEFEND || stance == COMMANDED_ATTACK)
		icon_state = "[initial(icon_state)]_angry"
	else
		icon_state = "[initial(icon_state)]"

/mob/living/simple_animal/hostile/commanded/mongrel/accepted()
	playsound(src, pick('sound/f13npc/dog_bark1.ogg', 'sound/f13npc/dog_bark2.ogg', 'sound/f13npc/dog_bark3.ogg'), 50, 0)

/mob/living/simple_animal/hostile/commanded/mongrel/unacsessable()
	emote("me",1,"whines")

/mob/living/simple_animal/hostile/commanded/mongrel/GiveTarget(new_target)
	..()
	if((stance == COMMANDED_DEFEND || stance == COMMANDED_ATTACK) && is_enemy(new_target))
		playsound(src, pick('sound/f13npc/dog_charge1.ogg', 'sound/f13npc/dog_charge2.ogg', 'sound/f13npc/dog_charge3.ogg'), 50, 0)

/mob/living/simple_animal/hostile/commanded/mongrel/handle_automated_speech(var/override)
	if(stance == COMMANDED_DEFEND || stance == COMMANDED_ATTACK)
		if(prob(5))
			playsound(src, pick('sound/f13npc/dog_alert1.ogg', 'sound/f13npc/dog_alert2.ogg', 'sound/f13npc/dog_alert3.ogg'), 50, 0)
	else
		if(prob(5))
			emote("me",1,pick(emote_see))