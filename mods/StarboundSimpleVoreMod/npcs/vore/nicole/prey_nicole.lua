require "/scripts/vore/npcprey.lua"

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
	
	myProfile["bribe"][1]		= {	"Ugh. Let me out!",
									"I'll MIGHT just spare you if you let me out.",
									"Want a bribe, huh? Fine. Name your price."
	}
	myProfile["consumed"][1]	= {	"Wha- Oh, come on!",
									"Seriously?!",
									"C'mon, dude!"
	}
	myProfile["death"][1] 		= {	"Welp.",
									"I'll be back.",
									"How would you like it?"
	}
	myProfile["idle"][1] 		= {	"Gah... Come on...",
									"This isn't funny. Let me out.",
									"Just let me gooooo..."
	}
	myProfile["interact"][1]	= {	"Oh. Hey.",
									"Huh? I was doing something.",
									"You need something?"
	}
	myProfile["release"][1] 	= {	"Thank you!",
									"Oh my word... Thanks, I guess.",
									"Don't do that again!"
	}	
	myProfile["bribe"][2]		= {	"Could yah please let me out?",
									"You know the drill, it seems...",
									"You want a snack? I'll get you a meal if you LET ME OUT."
	}
	myProfile["consumed"][2]	= {	"W-well... Come on, dude...",
									"Ugh... I was in the middle of something...",
									"F-fine... Just let me out."
	}
	myProfile["death"][2] 		= {	"Another time...",
									"See yah...",
									"I'll be back. Don't worry."
	}
	myProfile["idle"][2] 		= {	"Nnngh... *mumbles*",
									"M-maybe... *mumbles*",
									"I was doing something..."
	}
	myProfile["interact"][2]	= {	"'Sup, dude?",
									"Oh! Let me pause my game.",
									"Hmm? Got something for me?"
	}
	myProfile["release"][2] 	= {	"A-ah... Another time, I g-guess...",
									"P-perhaps another time...?",
									"Y-yeah... S-see yah..."
	}
	myProfile["bribe"][3]		= {	"C'mon, let me out, dude.",
									"I'll give yah a diamond if you let me out.",
									"Nnngh... J-just let me go!"
	}
	myProfile["consumed"][3]	= {	"O-oh... Okay... F-fine...",
									"C-could yah warn me f-first?",
									"J-just l-let me out... P-please..."
	}
	myProfile["death"][3] 		= {	"W-we m-might do th-this again...",
									"H-heh... Strange...",
									"Unquire, that's for sure..."
	}
	myProfile["idle"][3] 		= {	"A-ah...~",
									"Oooh... This is... nice...",
									"S-so wet and s-slimy..."
	}
	myProfile["interact"][3]	= {	"Oh! Hey, dude! What's up?",
									"Up for a bit of fun?~",
									"I need somewhere to rest. You up for it?"
	}
	myProfile["release"][3] 	= {	"Y-your choice, dude... Some other time.",
									"I'll, uh... See yah later.",
									"Before I would have showered immediately."
	}
	
	initHook()
	
end
