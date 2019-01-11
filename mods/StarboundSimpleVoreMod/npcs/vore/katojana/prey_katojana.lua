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
	
	myProfile["bribe"][1]		= {	"If you let me go I wont get angry at you.",
									"Release me now or I'm going to call a bigger pred to eat you!",
									"Why did you eat me? Could you let me go, please? If you do, I'll give you something."
	}
	myProfile["consumed"][1]	= {	"Hey, no! I’m not your food!",
									"Stop that! I’m not food!",
									"Ahhhh noooo!",
									"Help! Anyone!",
									"I don’t taste good!",
									"Please spit me out?"
	}
	myProfile["death"][1] 		= {	"..."
	}
	myProfile["idle"][1] 		= {	"Hey let me out!",
									"What will happen to me?",
									"Will you let me out?",
									"Spit me out! Now!",
									"It’s dark in here.",
									"It’s all sticky inside of you!",
									"Ewwww."
	}
	myProfile["interact"][1]	= {	"Hey there.",
									"Are you a pred or prey?",
									"You don't look like a pred",
									"I found a nice vore artist earlier.",
									"Oh crap I spilled some chocolate sauce on my fur."
	}
	myProfile["release"][1] 	= {	"Whew!",
									"That was close.",
									"About time.",
									"Do not do this ever again."
	}	
	myProfile["bribe"][2]		= {	"Oh come on. Is this a way to rob me? Let me go and I'll give you some pixels.",
									"Let me go now and you'll get something. "
	}
	myProfile["consumed"][2]	= {	"Oh no not again!",
									"Do not eat me again!",
									"Stop eating me again!",
									"Don’t eat me! It’s gross inside of you!", 
									"Please spit me out?"
	}
	myProfile["death"][2] 		= {	"..."
	}
	myProfile["interact"][2] 	= {	"I really don't appreciate being eaten",
									"Hey there",
									"I hope you arent planning to eat me again.",
									"Strawberries with cream. <3",
									"Don't you dare to eat me again."
	}
	myProfile["idle"][2]		= {	"Stop eating me all the time!",
									"It gets really annoying to be inside here.",
									"When I’m out I’m going to get revenge.",
									"What is this? A skull?",
									"Hey let me out right now!",
									"Will you let me out?",
									"Spit me out! Now!",
									"It’s dark in here.",
									"It’s all sticky inside of you!",
									"Ewwww."
	}
	myProfile["release"][2] 	= {	"Thanks for not digesting me.",
									"Could’ve been a lot sooner.",
									"What took you so long?",
									"Don’t do this ever again!"
	}
	
	myProfile["bribe"][3]		= {	"ARGH! Please let me go! I'll give you something!",
									"Could you PLEASE let me go? I'll give you something if you do."
	}
	myProfile["consumed"][3]	= {	"Do you know how hard it is to get this stuff out of my fur?",
									"Not this again...",
									"Don’t you get tired of this?",
									"Please spit me out?"
	}
	myProfile["death"][3] 		= {	"..."
	}
	myProfile["idle"][3] 		= {	"Stop eating me all the time!",
									"It gets really annoying to be inside here.",
									"When I’m out I’m going to get revenge.",
									"What is this? A skeleton?",
									"Hey let me out right now!",
									"Spit me out! Now!",
									"It’s super dark in here.",
									"It’s all sticky inside of you!",
									"Ewwww."
	}
	myProfile["interact"][3]	= {	"Get out. I don't want to be eaten.",
									"What are you doing here?",
									"If you eat me I'll get revenge, ok?",
									"DON'T YOU DARE",
									"Aaaaahhhh!"
	}
	myProfile["release"][3] 	= {	"...",
									"Yuck... all this stuff in my fur.",
									"I need a shower."
	}
	
	initHook()
	
end
