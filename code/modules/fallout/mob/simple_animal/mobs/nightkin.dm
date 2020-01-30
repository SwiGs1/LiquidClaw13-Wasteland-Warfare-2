//Fallout 13 nightkin directory - Swigs
/mob/living/simple_animal/hostile/nightkin
	name = "nightkin"
	desc = "A nightkin, an elite sub-type of super mutant. Their gray-blue skin is a result of of their use of Stealth Boys.  "
	icon = 'icons/fallout/mobs/nightkin.dmi'
	icon_state = "nightkin_jailer_s"
	icon_living = "nightkin_jailer_s"
	icon_dead = "nightkin_jailer_s"
	speak_chance = 10
	speak = list("GRRRRRR!", "ARGH!", "NNNNNGH!", "HMPH!", "ARRRRR!")
	speak_emote = list("shouts", "yells")
	move_to_delay = 5
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	turns_per_move = 4
	response_help = "touches"
	response_disarm = "tries to disarm and then vanishes"
	response_harm = "hits"
	maxHealth = 320
	health = 320
	force_threshold = 15
	faction = list("hostile", "supermutant")
	melee_damage_lower = 40
	melee_damage_upper = 70
	mob_size = MOB_SIZE_LARGE
	anchored = TRUE //unpullable
	attacktext = "slashes"
	attack_sound = "punch"

/mob/living/simple_animal/hostile/nightkin/ListTargets() //when we see enemy, we cloak 
	if(!search_objects)
		. = hearers(vision_range, targets_from) - src
	icon_state = "nightkin_jailer_cloak"

/mob/living/simple_animal/hostile/nightkin/LoseTarget() //When enemy gone, uncloak
	target = null
	walk(src, 0)
	icon_state = "nightkin_jailer_s"

/mob/living/simple_animal/hostile/nightkin/death(gibbed)// when we die uncloak 
	icon = 'icons/fallout/mobs/nightkin_dead.dmi'
	icon_state = icon_dead
	anchored = FALSE
	..()