//comannded directory - sips and swigs 
#define COMMANDED_STOP 0
#define COMMANDED_ATTACK 1
#define COMMANDED_FOLLOW 2 //follows a target
#define COMMANDED_DEFEND 3
#define COMMANDED_PULL 4
#define COMMANDED_MISC 5 //catch all state for misc commands that need one.

/proc/lowertext_uni(text as text)
	var/rep = "�"
	var/index = findtext(text, "�")
	while(index)
		text = copytext(text, 1, index) + rep + copytext(text, index + 1)
		index = findtext(text, "�")
	var/t = ""
	for(var/i = 1, i <= length(text), i++)
		var/a = text2ascii(text, i)
		if (a > 191 && a < 224)
			t += ascii2text(a + 32)
		else if (a == 168)
			t += ascii2text(184)
		else t += ascii2text(a)
	return t
