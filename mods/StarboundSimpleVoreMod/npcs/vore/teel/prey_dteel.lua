require "/scripts/vore/dnpcprey.lua"

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
	
	myProfile["bribe"][1]		= {	"Don't make me call Sath over.",
									"I hate to give away my hard-won treasure, but if you let me out...",
									"I've got a nice shiny necklace with your name on it if you let me out~"
	}
	myProfile["consumed"][1]	= {	"Before Familiar",
									"H-hey! Watch it!",
									"Woah there! That's a little fast, don't you think?",
									"This was NOT part of the conract!",
									"What are you- Ah!"
	}
	myProfile["death"][1] 		= {	"H-how could you do this...",
									"O-one million pixel fee....",
									"Wow... rude..."
	}
	myProfile["idle"][1] 		= {	"H-hey, you're gonna let me out, right?",
									"I don't really hate this, but...",
									"I don't have time for this, I've a bounty to find!",
									"It's a little too warm in here..."
	}
	myProfile["interact"][1]	= {	"I'm looking for a new contract- know any good ones?",
									"I'm Teel, treasure hunter extraodinaire, nice to meet you!",
									"Teel's my name, Treasures my game.",
									"Howdy!"
	}
	myProfile["release"][1] 	= {	"Ask me first next time!!",
									"You owe me for that. Something shiny and gold will do.",
									"Phew, now I can get back to work.",
									"There was NO treasure in there!",
									"That'll be fifty-thousand pixels, please."
	}	
	myProfile["bribe"][2]		= {	"Hasn't it been long enough?",
									"More time's gonna cost you extra.",
									"I'll give you another trinket if you let me out~"
	}
	myProfile["consumed"][2]	= {	"You're lucky I'm okay with this~",
									"I hope there's treasure in here~",
									"You're too kind~",
--									"Gentle please, <player name>~"
	}
	myProfile["death"][2] 		= {	"I-i'll be back...",
									"See you space cowboy...",
									"Lator gator...",
									"No hard feelings..."
	}
	myProfile["idle"][2] 		= {	"You're almost better than treasure~",
									"You're comfier than a pile of gold, that's for sure.",
									"That treasure can wait, I guess~",
--									"Comfey as usual, <player name>~"
	}
	myProfile["interact"][2]	= {	"After Familiar",
									"Heya! Got another contact for me?",
--									"Oh, welcome back <player name>!",
									"Well, hello agian~ Back for more?",
									"Good to see you today!",
									"Can I jump into your maw?"
	}
	myProfile["release"][2] 	= {	"Let's do it agian sometime~",
									"I'll be here, waiting for you~",
									"Thanks for the good time~",
									"No charge this time~",
--									"I'll see you later, <player name>~"
	}
	myProfile["bribe"][3]		= {	"Hasn't it been long enough?",
									"More time's gonna cost you extra.",
									"I'll give you another trinket if you let me out~"
	}
	myProfile["consumed"][3]	= {	"You're lucky I'm okay with this~",
									"I hope there's treasure in here~",
									"You're too kind~",
--									"Gentle please, <player name>~"
	}
	myProfile["death"][3] 		= {	"I-i'll be back...",
									"See you space cowboy...",
									"Lator gator...",
									"No hard feelings..."
	}
	myProfile["idle"][3] 		= {	"You're almost better than treasure~",
									"You're comfier than a pile of gold, that's for sure.",
									"That treasure can wait, I guess~",
--									"Comfey as usual, <player name>~"
	}
	myProfile["interact"][3]	= {	"After Familiar",
									"Heya! Got another contact for me?",
--									"Oh, welcome back <player name>!",
									"Well, hello agian~ Back for more?",
									"Good to see you today!",
									"Can I jump into your maw?"
	}
	myProfile["release"][3] 	= {	"Let's do it agian sometime~",
									"I'll be here, waiting for you~",
									"Thanks for the good time~",
									"No charge this time~",
--									"I'll see you later, <player name>~"
	}

	initHook()
	
end
