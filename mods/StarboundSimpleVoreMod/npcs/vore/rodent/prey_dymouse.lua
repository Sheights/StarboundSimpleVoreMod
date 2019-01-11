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
	
	myProfile["bribe"][1]		= {	"I payed last months rent! Here, let me go and I'll give you an advance!",
									"Need a few for the vending machine? Please take as much as you need and don't digest me!",
									"If you're that hungry, you can use this money more than I can.",
	}
	myProfile["consumed"][1]	= {	"Did you ne-",
									"*MMMMMPHHHH*",
									"Watch the teeth!",
									"Squeaaaak!",
									"Oh my goodne-!"
	}
	myProfile["death"][1] 		= {	"*Squ*...*Squeak*...",
									"Whose bones are these? O-Oh, they are mine...",
									"*Gurgle*",
									"*Blort*",
									"*Bubble*"
	}
	myProfile["idle"][1] 		= {	"It's wet and smells bad in here!",
									"Is this really happening?",
									"I must be dreaming.",
									"My cloak is getting wet.",
									"I have some cheese if you would prefer."
									
	}
	myProfile["interact"][1]	= {	"Oh, my, hello there.",
									"Did you need something? I'm all ears! Ha!",
									"Being an adventurer is pretty fun. Still not used to being devoured though.",
									"The scrolls are consise on this matter. They say... Hello!",
									"I'm really sorry I can't get to all requests, but thank you for making them - Sheights"
									
	}
	myProfile["release"][1] 	= {	"W-where am I?",
									"I shower daily, did I really taste that bad?",
									"Letting me go? I thought I was a goner."
	}	
	myProfile["bribe"][2]		= {	"Spare me my life! I'll pay you with coin!",
									"Life savings has never been more literal! Please take it!",
									"I can't take it with me. You have it!",
									"Well you don't have to take my money, I guess you could pick it out of my... P-p-please take it and let me go!",
									"My money or my life right? Haha... Please take my money.",
									"I don't take commissions, but would you take a bribe?"
	}
	myProfile["consumed"][2]	= {	"AaAaAhHhH!",
									"P-p-please!",
									"I-I-I'm... Uhhh.",
									"I'm food now...",
									"Familiar surroundings."
									
	}
	myProfile["death"][2] 		= {	"I'm fine... Just going to rest my eyes a bit...",
									"Delete my search history... I suppose you ... won't be surprised though...",
									"Well... I don't think I'm a solid anymore...",
									"*Gurgle*",
									"*Blort*",
									"*Bubble*"
	}
	myProfile["idle"][2] 		= {	"I-I-I...",
									"*whimper*",
									"*squeak*",
									"If I close my eyes its not happening...",
									"*churn*"
									
	}
	myProfile["interact"][2]	= {	"Oh um hmm. Err",
									"Y-y-you.",
									"Don't sneak up on me like that!"
	}
	myProfile["release"][2] 	= {	"T-Thank you for your mercy!",
									"You held my life in your gut and you gave it back. I guess that means I belong to you...",
									"I live, no doubt to be eaten again... *whimper*",
									"A-Air!",
									"I thought I would not see the light again!"
	}
	
	myProfile["bribe"][3]		= {	"Please accept this tithe in exchange for my life",
									"I'll see you are rewarded for your kindness"
									
	}
	myProfile["consumed"][3]	= {	"Heh, what kept you?",
									"Am I really that good? I'm glad I guess",
									"Hello to you too, master."
	}
	myProfile["death"][3] 		= {	"Nature sure is cruel",
									"As long as you are happy, I'm... happy...",
									"I hope... You... Enjoyed it.",
									"Make the most... of...",
									"*Gurgle*",
									"*Blort*",
									"*Bubble*"
	}
	myProfile["idle"][3] 		= {	"I-It's the b-best hug I-I've ever had...",
									"Mmmrrrmmm hmmmmm zzzzz...",
									"It's like memory foam, it remembers the spot I've made.",
									"You're heart beat drones out all my concerns",
									"I do enjoy my time with you, master."
	}
	myProfile["interact"][3]	= {	"The fact you are here means I have done good. Thank you so much for playing this mod. - Sheights",
									"Heh, bet you can't swallow me whole.",
									"I may show lapses in my personality. I am a mouse after all.",
									"Mice are pretty much meant to be food anyway. I've come to accept that.",
									"I've set aside my plans for today if you want to grab some lunch.",
									"I eagerly anticipate your warm gastro-embrace again, master."
	}
	myProfile["release"][3] 	= {	"The sun is awefully bright.",
									"Was I not satisfactory?",
									"I'll be waiting for next time!",
									"Out into the cold again."
									
	}
	
	initHook()
	
end
