//Fallout 13 wolf directory

/mob/living/simple_animal/hostile/wolf
	name = "feral dog"
	desc = "The dogs that survived the Great War are a larger, and tougher breed, size of a wolf.<br>This one seems to be severely malnourished and its eyes are bloody red."
	icon = 'icons/fallout/mobs/animal.dmi'
	icon_state = "feral_angry"
	icon_living = "feral_angry"
	icon_dead = "fearl_dead"
	icon_gib = "gib"
	turns_per_move = 1
	response_help = "pets"
	response_disarm = "pushes aside"
	response_harm = "kicks"
	maxHealth = 60
	health = 60
//	self_weight = 35

	faction = list("hostile", "wolf")

//	sound_speak_chance = 5
//	sound_speak = list('sound/f13npc/dog_charge1.ogg','sound/f13npc/dog_charge2.ogg','sound/f13npc/dog_charge3.ogg')

//	aggro_sound_chance = 50
//	aggro_sound = list('sound/f13npc/dog_alert1.ogg','sound/f13npc/dog_alert2.ogg','sound/f13npc/dog_alert3.ogg')

	death_sound = 'sound/f13npc/dog_death.ogg'

	environment_smash = 0
	butcher_results = list(/obj/item/stack/sheet/animalhide/wolf = 1, \
	/obj/item/reagent_containers/food/snacks/meat/slab/wolf = 1)
	melee_damage_lower = 20
	melee_damage_upper = 20
	aggro_vision_range = 15
//	idle_vision_range = 7
	attacktext = "bites"
	attack_sound = 'sound/weapons/bite.ogg'
	move_to_delay = 2

/mob/living/simple_animal/hostile/wolf/alpha
	name = "alpha feral dog"
	desc = "The dogs that survived the Great War are a larger, and tougher breed, size of a wolf.<br>Wait... This one's a wolf!"
	icon_state = "wolf_angry"
	icon_living = "wolf_angry"
	icon_dead = "wolf_dead"
	icon_gib = "gib"
	maxHealth = 100
	health = 100
	melee_damage_lower = 25
	melee_damage_upper = 35

/mob/living/simple_animal/hostile/wolf/mongrel 
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
	
/mob/living/simple_animal/hostile/wolf/mongrel/handle_automated_action()
	if(AIStatus == AI_OFF)
		return 0
	var/list/possible_targets = ListTargets("NCR", "BOS") 
	if(AICanContinue(possible_targets))
		if(!QDELETED(target) && !targets_from.Adjacent(target))
			DestroyPathToTarget()
		if(!MoveToTarget(possible_targets))     
			if(AIShouldSleep(possible_targets))	
				toggle_ai(AI_IDLE)			
	return 1

/mob/living/simple_animal/hostile/wolf/mongrel/FindTarget(list/possible_targets, HasTargetsList = 0)
	. = list()
	if(!HasTargetsList)
		possible_targets = ListTargets()
	for(var/pos_targ in possible_targets)
		var/atom/A = pos_targ
		if(Found(A))
			. = list(A)
			break
		if(CanAttack(A))
			. += A
			continue
	var/Target = PickTarget(.)
	GiveTarget(Target)
	return Target 

/mob/living/simple_animal/hostile/wolf/mongrel/PossibleThreats()
	. = list("Town", "Wastelander")
	for(var/pos_targ in ListTargets())
		var/atom/A = pos_targ
		if(Found(A))
			. = list(A)
			break
		if(CanAttack(A))
			. += A
			continue

/mob/living/simple_animal/hostile/wolf/mongrel/PickTarget(list/Targets)
	if(target != null)
		for(var/pos_targ in Targets)
			var/atom/A = pos_targ
			var/target_dist = get_dist(targets_from, target)
			var/possible_target_distance = get_dist(targets_from, A)
			if(target_dist < possible_target_distance)
				Targets -= A
	if(!Targets.len)
		return
	var/chosen_target = pick(Targets)
	return chosen_target

/mob/living/simple_animal/hostile/wolf/mongrel/GiveTarget(new_target)
	target = new_target
	LosePatience()
	if(target != null)
		GainPatience()
		Aggro()
		return 1

/mob/living/simple_animal/hostile/wolf/mongrel/MoveToTarget(list/possible_targets)
	stop_automated_movement = 1
	if(!target || !CanAttack(target))
		LoseTarget()
		return 0
	if(target in possible_targets)
		var/turf/T = get_turf(src)
		if(target.z != T.z)
			LoseTarget()
			return 0
		var/target_distance = get_dist(targets_from,target)
		if(ranged) 
			if(!target.Adjacent(targets_from) && ranged_cooldown <= world.time) 
				OpenFire(target)
		if(!Process_Spacemove()) 
			walk(src,0)
			return 1
		if(retreat_distance != null) 
			if(target_distance <= retreat_distance) 
				walk_away(src,target,retreat_distance,move_to_delay)
			else
				Goto(target,move_to_delay,minimum_distance) 
		else
			Goto(target,move_to_delay,minimum_distance)
		if(target)
			if(targets_from && isturf(targets_from.loc) && target.Adjacent(targets_from)) 
				AttackingTarget()
				GainPatience()
			return 1
		return 0
	if(environment_smash)
		if(target.loc != null && get_dist(targets_from, target.loc) <= vision_range) 
			if(ranged_ignores_vision && ranged_cooldown <= world.time) 
				OpenFire(target)
			if((environment_smash & ENVIRONMENT_SMASH_WALLS) || (environment_smash & ENVIRONMENT_SMASH_RWALLS))
				Goto(target,move_to_delay,minimum_distance)
				FindHidden()
				return 1
			else
				if(FindHidden())
					return 1
	LoseTarget()
	return 0

/mob/living/simple_animal/hostile/wolf/mongrel/Goto(target, delay, minimum_distance)
	walk_to(src, target, minimum_distance, delay)

/mob/living/simple_animal/hostile/wolf/mongrel/AttackingTarget()
	return target.attack_animal(src)

/mob/living/simple_animal/hostile/wolf/mongrel/LoseAggro()
	stop_automated_movement = 0
	vision_range = initial(vision_range)
	taunt_chance = initial(taunt_chance)

/mob/living/simple_animal/hostile/wolf/mongrel/LoseTarget()
	target = null
	walk(src, 0)
	LoseAggro()

/mob/living/simple_animal/hostile/wolf/mongrel/death(gibbed)
	LoseTarget()
	..(gibbed)
/mob/living/simple_animal/hostile/wolf/mongrel/CheckFriendlyFire(atom/A)
	if(check_friendly_fire)
		for(var/turf/T in getline(src,A)) 
			for(var/mob/living/L in T)
				if(L == src || L == A)
					continue
				if(faction_check_mob(L) && !attack_same)
					return TRUE

/mob/living/simple_animal/hostile/wolf/mongrel/AICanContinue(var/list/possible_targets)
	switch(AIStatus)
		if(AI_ON)
			. = 1
		if(AI_IDLE)
			if(FindTarget(possible_targets, 1))
				. = 1
				toggle_ai(AI_ON) 
			else
				. = 0
/mob/living/simple_animal/hostile/wolf/mongrel/AIShouldSleep(var/list/possible_targets)
	return !FindTarget(possible_targets, 1)

/mob/living/simple_animal/hostile/wolf/ncrguarddog 
	name = "NCR guard dog"
	desc = "NCR guard dogs are dogs owned and bred as well as tamed by the NCR. Used for guarding, scouting and sometimes combat."
	icon = 'icons/fallout/mobs/animal.dmi'
	icon_state = "guarddog_ncr"
	icon_living = "guarddog_ncr"
	icon_dead = "guarddog_ncr_dead"
	icon_gib = "gib"
	maxHealth = 80
	health = 80
	faction = list("NCR")
	emote_hear = list("barks", "growls", "howls")
	emote_see = list("bears its teeth", "stares aggressively", "shakes its head", "looks around")
	turns_per_move = 1
	wander = 1
	stop_automated_movement_when_pulled = 1
	response_help   = "pets"
	response_disarm = "shoves aside"
	response_harm   = "kicks"
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
	
/mob/living/simple_animal/hostile/wolf/ncrguardog/handle_automated_action()
	if(AIStatus == AI_OFF)
		return 0
	var/list/possible_targets = ListTargets("Legion", "BOS") 
	if(AICanContinue(possible_targets))
		if(!QDELETED(target) && !targets_from.Adjacent(target))
			DestroyPathToTarget()
		if(!MoveToTarget(possible_targets))     
			if(AIShouldSleep(possible_targets))	
				toggle_ai(AI_IDLE)			
	return 1

/mob/living/simple_animal/hostile/wolf/ncrguardog/FindTarget(list/possible_targets, HasTargetsList = 0)
	. = list()
	if(!HasTargetsList)
		possible_targets = ListTargets()
	for(var/pos_targ in possible_targets)
		var/atom/A = pos_targ
		if(Found(A))
			. = list(A)
			break
		if(CanAttack(A))
			. += A
			continue
	var/Target = PickTarget(.)
	GiveTarget(Target)
	return Target 

/mob/living/simple_animal/hostile/wolf/ncrguardog/PossibleThreats()
	. = list("Town", "Wastelander")
	for(var/pos_targ in ListTargets())
		var/atom/A = pos_targ
		if(Found(A))
			. = list(A)
			break
		if(CanAttack(A))
			. += A
			continue

/mob/living/simple_animal/hostile/wolf/ncrguardog/PickTarget(list/Targets)
	if(target != null)
		for(var/pos_targ in Targets)
			var/atom/A = pos_targ
			var/target_dist = get_dist(targets_from, target)
			var/possible_target_distance = get_dist(targets_from, A)
			if(target_dist < possible_target_distance)
				Targets -= A
	if(!Targets.len)
		return
	var/chosen_target = pick(Targets)
	return chosen_target

/mob/living/simple_animal/hostile/wolf/ncrguardog/GiveTarget(new_target)
	target = new_target
	LosePatience()
	if(target != null)
		GainPatience()
		Aggro()
		return 1

/mob/living/simple_animal/hostile/wolf/ncrguardog/MoveToTarget(list/possible_targets)
	stop_automated_movement = 1
	if(!target || !CanAttack(target))
		LoseTarget()
		return 0
	if(target in possible_targets)
		var/turf/T = get_turf(src)
		if(target.z != T.z)
			LoseTarget()
			return 0
		var/target_distance = get_dist(targets_from,target)
		if(ranged) 
			if(!target.Adjacent(targets_from) && ranged_cooldown <= world.time) 
				OpenFire(target)
		if(!Process_Spacemove()) 
			walk(src,0)
			return 1
		if(retreat_distance != null) 
			if(target_distance <= retreat_distance) 
				walk_away(src,target,retreat_distance,move_to_delay)
			else
				Goto(target,move_to_delay,minimum_distance) 
		else
			Goto(target,move_to_delay,minimum_distance)
		if(target)
			if(targets_from && isturf(targets_from.loc) && target.Adjacent(targets_from)) 
				AttackingTarget()
				GainPatience()
			return 1
		return 0
	if(environment_smash)
		if(target.loc != null && get_dist(targets_from, target.loc) <= vision_range) 
			if(ranged_ignores_vision && ranged_cooldown <= world.time) 
				OpenFire(target)
			if((environment_smash & ENVIRONMENT_SMASH_WALLS) || (environment_smash & ENVIRONMENT_SMASH_RWALLS))
				Goto(target,move_to_delay,minimum_distance)
				FindHidden()
				return 1
			else
				if(FindHidden())
					return 1
	LoseTarget()
	return 0

/mob/living/simple_animal/hostile/wolf/ncrguardog/Goto(target, delay, minimum_distance)
	walk_to(src, target, minimum_distance, delay)

/mob/living/simple_animal/hostile/wolf/ncrguardog/AttackingTarget()
	return target.attack_animal(src)

/mob/living/simple_animal/hostile/wolf/ncrguardog/LoseAggro()
	stop_automated_movement = 0
	vision_range = initial(vision_range)
	taunt_chance = initial(taunt_chance)

/mob/living/simple_animal/hostile/wolf/ncrguardog/LoseTarget()
	target = null
	walk(src, 0)
	LoseAggro()

/mob/living/simple_animal/hostile/wolf/ncrguardog/death(gibbed)
	LoseTarget()
	..(gibbed)
/mob/living/simple_animal/hostile/wolf/ncrguardog/CheckFriendlyFire(atom/A)
	if(check_friendly_fire)
		for(var/turf/T in getline(src,A)) 
			for(var/mob/living/L in T)
				if(L == src || L == A)
					continue
				if(faction_check_mob(L) && !attack_same)
					return TRUE

/mob/living/simple_animal/hostile/wolf/ncrguardog/AICanContinue(var/list/possible_targets)
	switch(AIStatus)
		if(AI_ON)
			. = 1
		if(AI_IDLE)
			if(FindTarget(possible_targets, 1))
				. = 1
				toggle_ai(AI_ON) 
			else
				. = 0
/mob/living/simple_animal/hostile/wolf/ncrguardog/AIShouldSleep(var/list/possible_targets)
	return !FindTarget(possible_targets, 1)