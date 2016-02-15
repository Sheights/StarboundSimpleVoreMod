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
	
	myProfile["bribe"][1]		= {	"Hey I'm busy today, Could you let me go now?",
									"Here, I've got something for you if you let me out. You ate me before i could give you it!",
--									"Hey <playername>. I've got to excersise today, or i'll miss out on something later! I'll give you money for dinner."
	}
	myProfile["consumed"][1]	= {	"Hey! You know you could'a just asked to do that.. I don't mind.. <3",
									"What are you doing? Oh.. mm... go ahead.. swallow me please~  *wiggles in your grip*",
									"Mmnpphh!"
	}
	myProfile["death"][1] 		= {	"Mmm.. thanks for making me part of you for a while~ <3",
									"Mmmmnph.. <3 *gurgle*",
									"The best predator to have eaten me~",
									"Nnnngh, Yes.. yours.. <3 *gurgle*"
	}
	myProfile["idle"][1] 		= {	"I can tell you love me wiggling nside you~ I love it too!",
									"*Wiggles inside that tight, hot churning belly, flesh kneading about her*",
									"You're really lovely inside.. I almost don't want to leave your tummy."
	}
	myProfile["interact"][1]	= {	--"Oh? Hey there <playername> Are you hungry? I'd like to get eaten.",
									"Say, Is your stomach growling? It's sounds really sexy.. Can you put me inside your tummy~?",
--									"You know, I'd really really like to be eaten today~ Can you help me out <playername>?."
									"Hello there~ I'm Christy~ I like to be eaten sometimes.. I don't mind though for now!~",
									"What a lovely day!"
	}
	myProfile["release"][1] 	= {	"Aw, Letting me out already? That's noooo fuuuun. Hee~",
									"Awww, I don't wanna come out~! It's nice inside you!",
									"That was great fun, thanks for having me inside. I loved the warm, squeezing flesh around me! Especially the noises!",
									"Aw, your tight squeezing warm belly was so comfortable. It's a shame to get let out!"
	}	
	myProfile["bribe"][2]		= {	"It's fun in here and all.. but I gotta get to a movie! I'll pay for you after you let me out.",
									"I have money, you can go buy something from Inifinty Express with it to make up for me having to go",
									"Oof, I need to get out and do a few things today, would you mind? I'll make you some dinner in return!"
	}
	myProfile["consumed"][2]	= {	"Yay, Time to get gobbled~ This is always fun for me.",
									"It's good to be in here again! I hope you let me stay longer this time!"
--									"This is fun, I loooove being inside you <playername>!"
	}
	myProfile["death"][2] 		= {	"Guess I'll just get some rest inside here. mmm..",
									"Thank you...so much.. <3",
									"Zzzz...."
	}
	myProfile["idle"][2] 		= {	"I can tell you love me wiggling nside you~ I love it too!",
									"*Wiggles inside that tight, hot churning belly, flesh kneading about her*",
									"You're really lovely inside.. I almost don't want to leave.."
	}
	myProfile["interact"][2]	= {	--"Hey there <player name>! Is it nomnom time again?",
									"Theres been someone going around eating others. *giggles, mutters to herself* I hope I can be next...",
									"I want to visit your stomach again!",
									"Can I jump into your maw?"
	}
	myProfile["release"][2] 	= {	"Aw, I wanted to stay a little longer.",
									"Can we have more fun later?",
									"I can't wait to go back!",
									"Aw, it was so warm and comfortable inside."
	}
	
	myProfile["bribe"][3]		= {	"Hey, I've got something to do today.. could you let me out? I'll give you some money, or food to make up for it!",
									"I'm getting a bit all trussed up in here.. I need to get groomed today.. could you let me out now?"
	}
	myProfile["consumed"][3]	= {	"I love being this close to you.",
									"This is my favorite part of the day, well.. dinner time that is~.",
									"Thank you! Eee!",
									"Yay! Tehe <3",
									"Hehe, you like this, just as much as i do, don't you?",
									"I'm happy to be your meal! I do enjoy it.",
									"I taste good, don't I? Well, I figured i did atleast!"
	}
	myProfile["death"][3] 		= {	"Mmmm.. <3",
									"I am glad to satisfy you...",
									"Good night...",
									"Zzz....",
									"I can't wait to do this again... Goodnight..."
	}
	myProfile["idle"][3] 		= {	"It's so nice in here~",
									"*Rubs belly walls*",
									"It's so warm and tight..",
									"Can I spend the night inside of you?",
									"*Wiggles about, blushing*",
									"You're so tight and comfortable...",
									"*pushes out on the slick, soft walls, making shapes show on your belly*"
	}
	myProfile["interact"][3]	= {	"Oh uh, hello.",
									"Are you hungry again?",
									"*Rubs belly* Can we have some more nom fun soon?",
									"*stretches and yawns* Hey, can I take a nap in your belly? Somewhere warm and cosy~",
--									"Hey <player name>! Let's Do that again sometime!",
									"Wanna cuddle first??"
	}
	myProfile["release"][3] 	= {	"Aw, I was enjoying it.",
									"Can't wait to be eaten again!",
									"I'll keep myself brushed and clean for the next time you're hungry!",
									"Could you let me stay longer next time?",
									"Aw...already? Dang.."
	}
	
	initHook()
	
end
