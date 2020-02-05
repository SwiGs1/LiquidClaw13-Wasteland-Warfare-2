var/list/translit_symbols = list("à" = "a", "á" = "b", "â" = "v", "ã" = "g", "ä" = "d", "å" = "e", "¸" = "yo", "æ"= "j", "ç" = "z", "è" = "i", \
 "é" = "y", "ê" = "k", "ë" = "l", "ì" = "m", "í" = "n", "î" = "o", "ï" = "p", "ð" = "r", "ñ" = "c", "ò" = "t", "ó" = "y", \
 "ô" = "f", "õ" = "h", "ö" = "tc", "÷" = "ch", "ø" = "sh", "ù" = "sh", "û" = "i", "ý" = "e", "þ" = "yu", "ÿ" = "ya", \
 "ü" = "", "ú" = "")
var/static/list/phrases_storage = list("attack" = "assault,sic,strike,rush,charge,bit,target,open,fuck,ôàñ,ìî÷è,âàëè,êóñ,öàï,áåé,àòàê,åáàø,øòóðì,óåá,õîï", "follow" = "come,to me,after,with,escort,convoy,chase,ïèçäóé,èäè,ñþäà,êî ìíå,ê íîãå,ðÿäîì,çà ìíîé,ïðîâ,êîíâ,ñëåä,âïåðåä", \
"stop" = "quit,leave,drop,freeze,pause,cease,layoff,õâàòèò,ñòîï,îñòàíîâèñü,õàðå,ïåðåñòàíü,ïðåêðàò,ôó,íåò,íåëüçÿ,áðîñ,âîëüíî,ñâîáîä", "stay" = "wait,hold,still,idle,ñòîÿòü,ñòîé,ìåñò,íå äâèãàéñÿ", \
"randy" = "rand,ðýíä,ðåíä", "bear" = "grizzly,ìèø,ìåäâåä,êîñîëàï", "brahmin" = "cow,áðàìèí,êîðîâ,ìó", \
"me" = "my,mine,ìåíÿ,ìíîé,ÿ,ìíå", "anybody" = "every,each,all,âñå,êàæä", "dance" = "òàíö,ïëÿøè", "defend" = "guard,protect,secur,enforce,watch,çàùèù,çàùèò,áåðåã,õðàí,ñòîðîæ", \
"none" = "neutral,wasteland,settler,farm,íåéòðàë,ïóñòîø,ïîñåëåí,äåðåâ,ôåðì,áîìæ", "city" = "citiz,mayor,sherif,ãîðîä,ìåð,ìýð,øåðèô,øýðèô", "raiders" = "bandit,criminal,raid,gang,psych,insane,maniac,sadist,ðåéä,õóëèã,áàíä,ïàõàí,ïñèõ,øèç,ìàíè,ñàäèñò,ñîäîì", "vault" = "bunker,óáåæèù,áóíêåð", "bs" = "bro,steel,knight,paladin,elder,áðàò,ñòàë,ðûöàð,ïàëàäèí,ñòàðåéøèí", "enclave" = "usa,ñøà,àíêëàâ", "ahs" = "hubolog,adept,õàáîëîã,àäåïò", "ncr" = "california,republic,íêð,êàëèôîðíè,ðåñïóáëèê", "legion" = "caesar,ëåãèîí,öåçàðü", "followers" = "follower,apocalypse,ñëåäîâàòå,àïîêàëèïñèñ", "acolytes" = "acolyt,atom,ghoul,àêîëèò,àòîì,ãóë", \
"enemy" = "foe,bad,bully,evil,danger,threat,monster,asshole,fag,traitor,villain,dick,douche,prick,spy,agent,âðàã,÷óæ,ïëîõ,çëî,îïàñ,óãð,ïðåä,øïè,âðàæ,ñâîëî÷,ìóä,ïèäîð", \
"friend" = "buddy,master,good,kind,ally,partner,äðóã,äðóç,äîáð,ïîâåë,õîç,õîð,ñîþç,ïàð", "pull" = "grab,bring,get,drag,fetch,take,haul,tow,deliver,rescue,save,help,àïîðò,òàùè,íåñè,íåñò,õâàò,âîçüìè,âçÿ,çàëîæè,ñïàñ,áóêñ", \
"doge" = "dog,pup,hound,mongrel,pooch,bowwow,ïñèí,ï¸ñ,ñîáàê,êîáåë,ùåí,ïñà,øàâê,âîëê", \
"smeagol" = "gollum,hobbit,ñìåãîë,ëûñûé,ãîë,ãîð,óðîä,õîáèò,ïó÷åãëàç")


proc/translit(text)
	return sanitize_simple(text, translit_symbols)

proc/parse_phrase(text, name)
	if(findtext(text,name))
		return 1
	if(name in phrases_storage)
		var/names = phrases_storage[name]
		names = splittext(names,",")
		for(var/N in names)
			if(findtext(text,"[N]"))
				return 1
	var/translit = translit(text)
	if(findtext(translit,name))
		if(phrases_storage[name])
			phrases_storage[name] += ",[translit]"
		else
			phrases_storage[name] = translit
		return 1
	return 0