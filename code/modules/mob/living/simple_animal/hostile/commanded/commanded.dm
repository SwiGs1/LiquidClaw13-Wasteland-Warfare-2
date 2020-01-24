#define HOSTILE_STANCE_IDLE      TRUE
#define HOSTILE_STANCE_ALERT     2
#define HOSTILE_STANCE_ATTACK    3
#define HOSTILE_STANCE_ATTACKING 4
#define HOSTILE_STANCE_TIRED     5
#define COMMANDED_STOP 6
#define COMMANDED_FOLLOW 7
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HARM		"harm"


/mob/living/simple_animal/hostile/commanded
	name = "commanded"
	var/stance = HOSTILE_STANCE_IDLE	//Used to determine behavior
	stance = COMMANDED_STOP
	melee_damage_lower = FALSE
	melee_damage_upper = FALSE
	density = FALSE
	attacktext = "swarmed"
	var/mob/living/target_mob
	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "attack", "follow")
	var/mob/master = null //undisputed master. Their commands hold ultimate sway and ultimate power.
	var/list/allowed_targets = list() //WHO CAN I KILL D:

/mob/living/simple_animal/hostile/commanded/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = FALSE, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if ((speaker in friends) || speaker == master)
//		world.log << "DEBUG: The command was recognized"
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return FALSE

/mob/living/simple_animal/hostile/commanded/Life()
	while (command_buffer.len > 0)
		var/mob/speaker = command_buffer[1]
		var/text = command_buffer[2]
		var/filtered_name = lowertext(html_decode(name))
		if (dd_hasprefix(text,filtered_name))
			var/substring = copytext(text,length(filtered_name)+1) //get rid of the name.
			listen(speaker,substring)
		command_buffer.Remove(command_buffer[1],command_buffer[2])
	. = ..()
	if (.)
		switch(stance)
			if (COMMANDED_FOLLOW)
				follow_target()
			if (COMMANDED_STOP)
				commanded_stop()



/mob/living/simple_animal/hostile/commanded/FindTarget(var/new_stance = HOSTILE_STANCE_ATTACK)
	if (!allowed_targets.len)
		return null
	var/mode = "specific"
	if (allowed_targets[1] == "everyone") //we have been given the golden gift of murdering everything. Except our master, of course. And our friends. So just mostly everyone.
		mode = "everyone"
	for (var/atom/A in ListTargets(7))
		var/mob/M = null
		if (A == src)
			continue
		if (isliving(A))
			M = A
		if (M && M.stat)
			continue
		if (mode == "specific")
			if (!(A in allowed_targets))
				continue
			stance = new_stance
			return A
		else
			if (M == master || (M in friends))
				continue
			stance = new_stance
			return A


/mob/living/simple_animal/hostile/commanded/proc/follow_target()
	stop_automated_movement = TRUE
	if (!target_mob)
		return
	if (target_mob in ListTargets(7))
		walk_to(src,target_mob,1,move_to_delay)

/mob/living/simple_animal/hostile/commanded/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

/mob/living/simple_animal/hostile/commanded/proc/listen(var/mob/speaker, var/text)
	for (var/command in known_commands)
		if (findtext(text,command))
			switch(command)
				if ("stay")
					if (stay_command(speaker,text)) //find a valid command? Stop. Dont try and find more.
						break
				if ("stop")
					if (stop_command(speaker,text))
						break
				if ("attack")
					if (attack_command(speaker,text))
						break
				if ("follow")
					if (follow_command(speaker,text))
						break
				else
					misc_command(speaker,text) //for specific commands

	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/sanitize(var/input, var/max_length = MAX_MESSAGE_LEN, var/encode = TRUE, var/trim = TRUE, var/extra = TRUE)
	if (!input)
		return

	if (max_length)
		input = copytext(input,1,max_length)

	if (extra)
		input = replace_characters(input, list("\n"=" ","\t"=" "))

		input = replace_characters(input, list("<"=" ", ">"=" "))

	if (trim)
		//Maybe, we need trim text twice? Here and before copytext?
		input = trim(input)

	return input

//Run sanitize(), but remove <, >, " first to prevent displaying them as &gt; &lt; &34; in some places, after html_encode().
//Best used for sanitize object names, window titles.
//If you have a problem with sanitize() in chat, when quotes and >, < are displayed as html entites -
//this is a problem of double-encode(when & becomes &amp;), use sanitize() with encode=0, but not the sanitizeSafe()!
/mob/living/simple_animal/hostile/commanded/proc/sanitizeSafe(var/input, var/max_length = MAX_MESSAGE_LEN, var/encode = TRUE, var/trim = TRUE, var/extra = TRUE)
	return sanitize(replace_characters(input, list(">"=" ","<"=" ", "\""="'")), max_length, encode, trim, extra)

//Filters out undesirable characters from names
/mob/living/simple_animal/hostile/commanded/proc/sanitizeName(var/input, var/max_length = MAX_NAME_LEN, var/allow_numbers = FALSE)
	if (!input || length(input) > max_length)
		return //Rejects the input if it is null or if it is longer then the max length allowed

	var/number_of_alphanumeric	= FALSE
	var/last_char_group			= FALSE
	var/output = ""

	for (var/i=1, i<=length(input), i++)
		var/ascii_char = text2ascii(input,i)
		switch(ascii_char)
			// A  .. Z
			if (65 to 90)			//Uppercase Letters
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// a  .. z
			if (97 to 122)			//Lowercase Letters
				if (last_char_group<2)		output += ascii2text(ascii_char-32)	//Force uppercase first character
				else						output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 4

			// FALSE  .. 9
			if (48 to 57)			//Numbers
				if (!last_char_group)		continue	//suppress at start of string
				if (!allow_numbers)			continue
				output += ascii2text(ascii_char)
				number_of_alphanumeric++
				last_char_group = 3

			// '  -  .
			if (39,45,46)			//Common name punctuation
				if (!last_char_group) continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			// ~   |   @  :  #  $  %  &  *  +
			if (126,124,64,58,35,36,37,38,42,43)			//Other symbols that we'll allow (mainly for AI)
				if (!last_char_group)		continue	//suppress at start of string
				if (!allow_numbers)			continue
				output += ascii2text(ascii_char)
				last_char_group = 2

			//Space
			if (32)
				if (last_char_group <= 1)	continue	//suppress double-spaces and spaces at start of string
				output += ascii2text(ascii_char)
				last_char_group = TRUE
			else
				return

	if (number_of_alphanumeric < 2)	return		//protects against tiny names like "A" and also names like "' ' ' ' ' ' ' '"

	if (last_char_group == TRUE)
		output = copytext(output,1,length(output))	//removes the last character (in this case a space)

	for (var/bad_name in list("space","floor","wall","r-wall","monkey","unknown","inactive ai","plating"))	//prevents these common metagamey names
		if (cmptext(output,bad_name))	return	//(not case sensitive)

	return output

//Returns null if there is any bad text in the string
/mob/living/simple_animal/hostile/commanded/proc/reject_bad_text(var/text, var/max_length=512)
	if (length(text) > max_length)	return			//message too long
	var/non_whitespace = FALSE
	for (var/i=1, i<=length(text), i++)
		switch(text2ascii(text,i))
			if (62,60,92,47)	return			//rejects the text if it contains these bad characters: <, >, \ or /
			if (127 to 255)	return			//rejects weird letters like ?
			if (0 to 31)		return			//more weird stuff
			if (32)			continue		//whitespace
			else			non_whitespace = TRUE
	if (non_whitespace)		return text		//only accepts the text if it has some non-spaces


//Old variant. Haven't dared to replace in some places.
/mob/living/simple_animal/hostile/commanded/proc/sanitize_old(var/t,var/list/repl_chars = list("\n"="#","\t"="#"))
	return html_encode(replace_characters(t,repl_chars))

/*
 * Text searches
 */

//Checks the beginning of a string for a specified sub-string
//Returns the position of the substring or FALSE if it was not found
/mob/living/simple_animal/hostile/commanded/proc/dd_hasprefix(text, prefix)
	var/start = TRUE
	var/end = length(prefix) + 1
	return findtext(text, prefix, start, end)

//Checks the beginning of a string for a specified sub-string. This proc is case sensitive
//Returns the position of the substring or FALSE if it was not found
/mob/living/simple_animal/hostile/commanded/proc/dd_hasprefix_case(text, prefix)
	var/start = TRUE
	var/end = length(prefix) + 1
	return findtextEx(text, prefix, start, end)

//Checks the end of a string for a specified substring.
//Returns the position of the substring or FALSE if it was not found
/mob/living/simple_animal/hostile/commanded/proc/dd_hassuffix(text, suffix)
	var/start = length(text) - length(suffix)
	if (start)
		return findtext(text, suffix, start, null)
	return

//Checks the end of a string for a specified substring. This proc is case sensitive
//Returns the position of the substring or FALSE if it was not found
/mob/living/simple_animal/hostile/commanded/proc/dd_hassuffix_case(text, suffix)
	var/start = length(text) - length(suffix)
	if (start)
		return findtextEx(text, suffix, start, null)

/*
 * Text modification
 */


/mob/living/simple_animal/hostile/commanded/proc/replace_characters(var/t,var/list/repl_chars)
	for (var/char in repl_chars)
		t = replacetext(t, char, repl_chars[char])
	return t

/mob/living/simple_animal/hostile/commanded/proc/remove_characters(var/t, var/list/chars)
	var/list/repl_chars = list()
	for (var/val in chars)
		repl_chars[val] = ""
	return replace_characters(t, repl_chars)

//returns a list of everybody we wanna do stuff with.
/mob/living/simple_animal/hostile/commanded/proc/get_targets_by_name(var/text, var/filter_friendlies = FALSE)
	var/list/possible_targets = hearers(src,10)
	. = list()
	for (var/mob/M in possible_targets)
		if (filter_friendlies && ((M in friends) || M.faction == faction || M == master))
			continue
		var/found = FALSE
		if (findtext(text, "[M]"))
			found = TRUE
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("[M]")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big MESS is basically 'turn this into words, no punctuation, lowercase so we can check first name/last name/etc'
			for (var/a in parsed_name)
				if (a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if (findtext(text,"[a]"))
					found = TRUE
					break
		if (found)
			. += M

/mob/living/simple_animal/hostile/commanded/proc/attack_command(var/mob/speaker,var/text)
	target_mob = null //want me to attack something? Well I better forget my old target.
	walk_to(src,0)
	stance = HOSTILE_STANCE_IDLE
	if (text == "attack" || findtext(text,"everyone") || findtext(text,"anybody") || findtext(text, "somebody") || findtext(text, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming non-pickiness.
		allowed_targets = list("everyone")//everyone? EVERYONE
		return TRUE

	var/list/targets = get_targets_by_name(text)
	allowed_targets += targets
	return targets.len != FALSE

/mob/living/simple_animal/hostile/commanded/proc/stay_command(var/mob/speaker,var/text)
	target_mob = null
	stance = COMMANDED_STOP
	walk_to(src,0)
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/stop_command(var/mob/speaker,var/text)
	allowed_targets = list()
	walk_to(src,0)
	target_mob = null //gotta stop SOMETHIN
	stance = HOSTILE_STANCE_IDLE
	stop_automated_movement = FALSE
	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/follow_command(var/mob/speaker,var/text)
	//we can assume 'stop following' is handled by stop_command
	if (findtext(text,"me"))
		stance = COMMANDED_FOLLOW
		target_mob = speaker //this wont bite me in the ass later.
		return TRUE
	var/list/targets = get_targets_by_name(text)
	if (targets.len > 1 || !targets.len) //CONFUSED. WHO DO I FOLLOW?
		return FALSE

	stance = COMMANDED_FOLLOW //GOT SOMEBODY. BETTER FOLLOW EM.
	target_mob = targets[1] //YEAH GOOD IDEA

	return TRUE

/mob/living/simple_animal/hostile/commanded/proc/misc_command(var/mob/speaker,var/text)
	return FALSE


/mob/living/simple_animal/hostile/commanded/mob/living/proc/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)
	//if they attack us, we want to kill them. None of that "you weren't given a command so free kill" bullshit.
	. = ..()
	if (!.)
		stance = HOSTILE_STANCE_ATTACK
		target_mob = user
		allowed_targets += user //fuck this guy in particular.
		if (user in friends) //We were buds :'(
			friends -= user


/mob/living/simple_animal/hostile/commanded/attack_hand(mob/living/carbon/human/M as mob)
	..()
	if (M.a_intent == I_HARM) //assume he wants to hurt us.
		target_mob = M
		allowed_targets += M
		stance = HOSTILE_STANCE_ATTACK
		if (M in friends)
			friends -= M