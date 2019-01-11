require "/scripts/vore/npcprey.lua"

maxfam = 2

function init()

	oldInit()
	
	if storage.names == nil then
		storage.names = {}
		storage.freq = {}
	end
	
	myProfile				= {}					
	myProfile["bribe"]		= {}
	myProfile["consumed"]	= {}
	myProfile["death"] 		= {}
	myProfile["idle"] 		= {}
	myProfile["interact"]	= {}
	myProfile["release"]	= {}
	
	myProfile["bribe"][1]		= {	"If I tell you a story, will you let me go? No? What about money..?",
									"As nice as a good belly rub may be, maybe some money could convince you to free me..?",
									"Oh, hey. I found someone's credit card in here. Lemme out and I'll give ya' it?",
									"I've got a handful of quarters, and I'm not afraid to give them to ya'...",
									"So here me out: What if... and this is crazy talk, but... what if I paid you to lemme out?"
	}
	myProfile["consumed"][1]	= {	"H-Hey!!",
									"Hey, what gives??",
									"Kyah! 'Ey, lemme out!",
									"Oh, wellp. Guess I'm in here, now.",
									"Prepare yourself, I'm gunna squirm SO much."
	}
	myProfile["death"][1] 		= {	"Avast, I am slain..!",
									"Kyaaah....."
	}
	myProfile["idle"][1] 		= {	"...I mean, it's not SO terrible in here.",
									"Ok, but, what if I just squirm like... a LOT.",
									"You uh... lotta things come through this way, don't they?",
									"Oh hey, there's lunch. Hi, lunch. Suprised you're still in here.",
									"A bird in the gut is worth two in the bush, or something like that.",
									"I hope we're going on an adventure!... We're not going on an adventure, are we?",
									"They say you have to look inside yourself to find happiness, but this is ridiculous.",
									"Oo! A penny. No, wait, not a penny. My bad."
	}
	myProfile["interact"][1]	= {	"I'm uh... not really likin' the way you're lookin' at me...",
									"Hey, you with the mouth. Don't think I don't know what you're thinking.",
									"Oh, you want to EAT me, huh? Is that it?",
									"Did you know I taste like vanilla? Just tossing that out there."
	}
	myProfile["release"][1] 	= {	"*Plop*",
									"*Plop* Mrf... well, that was fun.",
									"AHA, you have been tricked! Mrrf... still a bit sticky, tho.",
									"SWEET FREEDOM!",
									"Freedom, of the sweet variety!"
	}
	
	myProfile["bribe"][2]		= {	"If I tell you a story, will you let me go? No? What about money..?",
									"As nice as a good belly rub may be, maybe some money could convince you to free me..?",
									"Oh, hey. I found someone's credit card in here. Lemme out and I'll give ya' it?",
									"I've got a handful of quarters, and I'm not afraid to give them to ya'..."
	}
	myProfile["consumed"][2]	= {	"Ggaah! Again!",
									"Oooh here we go again..!",
									"BUT WHY THOUGH??",
									"Birb returns to the gut!"
	}
	myProfile["death"][2] 		= {	"Avast, I am slain..!",
									"Kyaaah....."
	}
	myProfile["idle"][2] 		= {	"Oh hey, found the penny again! Wait, no- still not a penny. Sorry.",
									"A bird in the gut is worth two in the bush, or something like that.",
									"I hope we're going on an adventure!... We're not going on an adventure, are we?",
									"They say you have to look inside yourself to find happiness, but this is ridiculous.",
									"What? I'm not purring, nonono... that's probably just your gut or something.",
									"Didn't get much roomier since last time, did ya'?",
									"You best be careful, or I'mma... do SUCH a squirm!",
									"What a world this is, where birds can be eaten over and over again..."
	}
	myProfile["interact"][2]	= {	"I imagine now that you know of my SWEET VANILLA TASTE you're back for more...",
									"Oh, it's you again! You, with the gut. The squishy, churny gut.",
									"I know that look.",
									"Can't keep your jaws shut, eh?"
	}
	myProfile["release"][2] 	= {	"*Plop*",
									"*Plop* Mrf... well, that was fun.",
									"AHA, you have been tricked once again! Mrrf... still a bit sticky, tho.",
									"SWEET FREEDOM!",
									"Freedom, of the sweet variety!",
									"Ah, the sweet taste of freedome once more..!"
	}
	
	myProfile["bribe"][3]		= {	"If I tell you a story, will you let me go? No? What about money..?",
									"As nice as a good belly rub may be, maybe some money could convince you to free me..?",
									"Oh, hey. I found someone's credit card in here. Lemme out and I'll give ya' it?",
									"I've got a handful of quarters, and I'm not afraid to give them to ya'..."
	}
	myProfile["consumed"][3]	= {	"Ggaah! Again!",
									"Oooh here we go again..!",
									"BUT WHY THOUGH??",
									"Birb returns to the gut!"
	}
	myProfile["death"][3] 		= {	"Avast, I am slain..!",
									"Kyaaah....."
	}
	myProfile["idle"][3] 		= {	"Oh hey, found the penny again! Wait, no- still not a penny. Sorry.",
									"A bird in the gut is worth two in the bush, or something like that.",
									"I hope we're going on an adventure!... We're not going on an adventure, are we?",
									"They say you have to look inside yourself to find happiness, but this is ridiculous.",
									"What? I'm not purring, nonono... that's probably just your gut or something.",
									"Didn't get much roomier since last time, did ya'?",
									"You best be careful, or I'mma... do SUCH a squirm!",
									"What a world this is, where birds can be eaten over and over again..."
	}
	myProfile["interact"][3]	= {	"I imagine now that you know of my SWEET VANILLA TASTE you're back for more...",
									"Oh, it's you again! You, with the gut. The squishy, churny gut.",
									"I know that look.",
									"Can't keep your jaws shut, eh?"
	}
	myProfile["release"][3] 	= {	"*Plop*",
									"*Plop* Mrf... well, that was fun.",
									"AHA, you have been tricked once again! Mrrf... still a bit sticky, tho.",
									"SWEET FREEDOM!",
									"Freedom, of the sweet variety!",
									"Ah, the sweet taste of freedome once more..!"
	}
	initHook()
end

function updateHook()	
	if mcontroller.facingDirection() == 1 then
		npc.setItemSlot( "head", "alsnapzrighthead" )
	else
		npc.setItemSlot( "head", "alsnapzlefthead" )
	end
end