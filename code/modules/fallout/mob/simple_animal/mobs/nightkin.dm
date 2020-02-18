//Fallout 13 nightkin directory - Swigs
/mob/living/simple_animal/hostile/nightkin
	name = "nightkin"
	desc = "A nightkin, an elite sub-type of super mutant. Their gray-blue skin is a result of of their use of Stealth Boys."
	icon = 'icons/fallout/mobs/nightkin.dmi'
	icon_state = "nightkin_jailer_s"
	icon_living = "nightkin_jailer_s"
	icon_dead = "nightkin_jailer_s"
	speak_chance = 10
	speak = list("GRRRRRR!", "ARGH!", "NNNNNGH!", "HMPH!", "ARRRRR!", "WANT STEALTH BOYS", "MUST HIDE, CANT BE SEEN ARGGG", "NO LOOK AT ME!!! DIE!!!")
	speak_emote = list("shouts", "yells")
	move_to_delay = 5
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	turns_per_move = 4
	response_help = "touches"
	response_disarm = "tries to disarm and then vanishes"
	response_harm = "hits"
	maxHealth = 305
	health = 305
	force_threshold = 15
	faction = list("hostile", "supermutant")
	melee_damage_lower = 40
	melee_damage_upper = 70
	mob_size = MOB_SIZE_LARGE
	anchored = TRUE //unpullable
	attacktext = "slashes"
	attack_sound = "punch"
	loot = list(/obj/item/stealthboy/malfuctioning)

/mob/living/simple_animal/hostile/nightkin/ListTargets() //when we see enemy, we cloak 
	if(!search_objects)
		. = hearers(vision_range, targets_from) - src
	icon_state = "nightkin_jailer_cloak"

/mob/living/simple_animal/hostile/nightkin/LoseTarget() //When enemy gone, uncloak
	target = null
	walk(src, 0)
	icon_state = "nightkin_jailer_s"

/mob/living/simple_animal/hostile/nightkin/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	if(prob(85) || Proj.damage > 26)
		return ..()
	else
		visible_message("<span class='danger'>\The [Proj] is deflected harmlessly by \the [src]'s thick skin!</span>")
		return FALSE


/mob/living/simple_animal/hostile/nightkin/death(gibbed)// when we die uncloak 
	icon = 'icons/fallout/mobs/nightkin_dead.dmi'
	icon_state = icon_dead
	anchored = FALSE
	..()

/mob/living/simple_animal/pet/dog/nightkin   //This is Dog and God, he is friendly, not an actual dog - swigs 
	name = "Dog and God"
	desc = "Dog is a psychologically disturbed nightkin. Who helps the Town under the guidance and control of His alternate personality, God. Dog is the tool of violence to protect the town, and God is the voice of reason."
	icon = 'icons/fallout/mobs/nightkin.dmi'
	icon_state = "nightkin_dog_s"
	icon_dead = "nightkin_dog_s"
	maxHealth = 280
	health = 280
	speak_chance = 8
	anchored = TRUE
	mob_size = MOB_SIZE_LARGE
	speak = list("Don't like this place. Want to go back, back to the base. Or the Church, miss the Church.", "Shut up Dog!", "Wish I had a Stealth Boy", "Dog hungry, very hungry", "ARGHHHHH HUNGRY", "Good thing Dog wake up and not other voice.", "Hnnnh? Rhnhhhrrrr...", "You look like food, smell like food. Dog - hungry.", "Dog is sorry, sorry, sorry.", "Dog, back in the cage.", "	Can't believe the idiot swallowed his collar at the casino", "Well, this place has seen better days.", "Dog, you're staying in the cage.", "Dog want FREEDUM! NO! DO YOU WANT TO GO BACK? GRRHHHHH.", "Dog is always hungry, greedy idiot", "Just like last time. Come on, Dog, you know the drill.", "Last time I ever deal with human trash...", "")
	speak_emote = list("shouts", "yells")
	emote_hear = list("growls", "mumbles","sighs")
	emote_see = list("dog growls", "god stares", "talks to himself")
	response_help  = "touches"
	response_disarm = "pushes"
	response_harm   = "punches"
//	butcher_results = list(/obj/item/weapon/reagent_containers/food/snacks/bearsteak = 3)

/mob/living/simple_animal/pet/dog/nightkin/death(gibbed)
	icon = 'icons/fallout/mobs/nightkin_dead.dmi'
	icon_state = icon_dead
	anchored = FALSE
	if(!gibbed)
		visible_message("<span class='danger'>\ [src] shouts and growls at each other before dying as one...</span>")
	..()

/mob/living/simple_animal/hostile/nightkin/nightkinmaster
	name = "nightkin master"
	desc = "A nightkin master, an elite sub-type of super mutant, usually the apex nightkin in the pack they travel with. Their gray-blue skin is a result of of their use of Stealth Boys."
	icon = 'icons/fallout/mobs/nightkin.dmi'
	icon_state = "nightkin_master_s"
	icon_living = "nightkin_master_s"
	icon_dead = "nightkin_master_s"
	speak_chance = 10
	speak = list("GRRRRRR!", "ARGH!", "NNNNNGH!", "HMPH!", "ARRRRR!", "WANT STEALTH BOYS WANT THEM NOW", "MUST HIDE, CANT BE SEEN ARGGG", "NO LOOK AT ME!!! DIE!!!")
	speak_emote = list("shouts", "yells")
	move_to_delay = 4
	stat_attack = UNCONSCIOUS
	robust_searching = 1
	environment_smash = ENVIRONMENT_SMASH_RWALLS
	turns_per_move = 3
	response_help = "touches"
	response_disarm = "tries to disarm and then vanishes"
	response_harm = "hits"
	maxHealth = 320
	health = 320
	force_threshold = 15
	faction = list("hostile", "supermutant")
	melee_damage_lower = 45
	melee_damage_upper = 75
	mob_size = MOB_SIZE_LARGE
	anchored = TRUE //unpullable
	attacktext = "Punches with spiked fist"
	attack_sound = "punch"
	loot = list(/obj/item/stealthboy)

/mob/living/simple_animal/hostile/nightkin/nightkinmaster/ListTargets() //when we see enemy, we cloak 
	if(!search_objects)
		. = hearers(vision_range, targets_from) - src
	icon_state = "nightkin_master_cloak"

/mob/living/simple_animal/hostile/nightkin/nightkinmaster/LoseTarget() //When enemy gone, uncloak
	target = null
	walk(src, 0)
	icon_state = "nightkin_master_s"

/mob/living/simple_animal/hostile/nightkin/nightkinmaster/bullet_act(obj/item/projectile/Proj)
	if(!Proj)
		return
	if(prob(85) || Proj.damage > 26)
		return ..()
	else
		visible_message("<span class='danger'>\The [Proj] is deflected harmlessly by \the [src]'s thick skin!</span>")
		return FALSE


/mob/living/simple_animal/hostile/nightkin/nightkinmaster/death(gibbed)// when we die uncloak 
	icon = 'icons/fallout/mobs/nightkin_dead.dmi'
	icon_state = icon_dead
	anchored = FALSE
	..()