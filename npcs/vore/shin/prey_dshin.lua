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
	
	myProfile["bribe"][1]		= {	"Umm... can I come out to play? I's got sum pixels for you!"
	}
	myProfile["consumed"][1]	= {	"Eeek! You ish someone new to be eating me.",
									"M-meeep! At least yous shoulda ask first!",
									"Meeep! *squirms*"
	}
	myProfile["death"][1] 		= {	"Nuu, I dun want to- *glorp~!*",
									"P-pwease dun hurt me! *gurgle*"
	}
	myProfile["idle"][1] 		= {	"Ish softer and warmer than I expected.",
									"Heehee, well, it ish not that bad...",
									"*squirms* Hehe, I kinda like it heres~"
	}
	myProfile["interact"][1]	= {	"Are yous someone who wants to eat me?",
									"Hai! My name's Shin! Nice to meetcha!",
									"Hai there person I dun know! Nice to meetcha!"
	}
	myProfile["release"][1] 	= {	"Well, thankies for showing me your tummy.",
									"Meep! *blushes* W-well, dat was fun!"
	}	
	myProfile["bribe"][2]		= {	"I's got some pixels for yous! Umm... I'd give them to yous... but I'd have to come out."
	}
	myProfile["consumed"][2]	= {	"Feel free to eat me as much as you likeys.",
									"M-meep! Heehee, well, I was thinking on asking for a tummy ride!",
									"Heehee, is I really that yummy?"
	}
	myProfile["death"][2] 		= { "C-can me stay for a bit longer-*gurrrgle*",
									"Awww, gurgle time so soon? *gurgle*"
	}
	myProfile["idle"][2] 		= {	"Mmmmfh... I love it in here a lots.",
									"Yous know? I'd not mind staying for a while.",
									"Mrrr... I-it ish actually comfy in heres."
	}
	myProfile["interact"][2]	= {	"Ish take it you's hungry and want me for dinner?",
									"M-meep! Heehee, I-I take it you wanna eat me again?",
									"*blushes* Heehee, looks like someone liked my taste, I take it?"
	}
	myProfile["release"][2] 	= {	"Can I stay for a bit longer, pwease?",
									"Heehee... can we do that again?",
									"W-whenever yous get hungry again, I...I'll be happy to help~!"
	}
	
	myProfile["bribe"][3]		= {	"I can give yous some pixels since you gave me a belly bed!"
	}
	myProfile["consumed"][3]	= {	"Hehehe, thankies for the belly bed again.",
									"Yaay! In I go! *giggles*",
									"Heehee, is it bedtime for me alreadys?"
	}
	myProfile["death"][3] 		= {	"Heehee, hope I look good as your tummy pudge! *gurrrgle*",
	}
	myProfile["idle"][3] 		= {	"Keep me in as long as you wants or even gurgle me up.",
									"Heehee... comfiest bed ever!",
									"*snuggles up inside* I would so move in here if I coulds! <3"
	}
	myProfile["interact"][3]	= {	"Hai! I'm ready to ride in your belly again!",
									"Heehee, I's ready to make your tummy full and happy again!",
									"Hehe, I's ready to go back to my \"room\"!"
	}
	myProfile["release"][3] 	= {	"Awww... I wanna go back in!",
									"Aww, I was about to have some sleepy!",
									"*Giggles* Heehee, let's do it again!",
									"Heehee, dat was a lot of fun~!"
	}	
	initHook()
	
end
