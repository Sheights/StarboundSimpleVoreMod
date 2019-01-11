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
	
	myProfile["bribe"][1]		= {	"This is extortion isn't it?! Let me out and I'll pay you anyways!",
									"I'll give plenty of pixels for the Bellybound Store if you let me out!"
	}
	myProfile["consumed"][1]	= {	"Hey! What are you doing?!",
									"I didn't ask to be eaten! Hmph!",
									"E-Eeek! Help!"
	}
	myProfile["death"][1] 		= {	"Please... I don't want to be digested..."
	}
	myProfile["idle"][1] 		= {	"Ack! It's really slimy and squishy in here!",
									"I-I don't like the stickyness right now...",
									"Hmmmph... Come on, let me out."
	}
	myProfile["interact"][1]	= {	"H-Hey! You don't plan on eating me, do you?",
									"I don't like the fact I can hear your stomach growling.",
									"I'm glad you gave me a home away from my home and... What was that noise?"
	}
	myProfile["release"][1] 	= {	"A-Ask next time before you do that.",
									"T-Thanks for letting me out, you scared me for a bit."
	}	
	myProfile["bribe"][2]		= {	"I'm really busy at the moment. I'll pay you to let me out even if for a little bit!",
									"Hmmmmph... I'll pay you once I get out if it means you won't do it for awhile."
	}
	myProfile["consumed"][2]	= {	"W-Woah! Guess I'm going for a ride then.",
									"Guess this changed my plans a little, oh well.",
									"Something tells me this is your personal greeting, huh?"
	}
	myProfile["death"][2] 		= {	"Hmph... I guess I'll be back atleast..."
	}
	myProfile["idle"][2] 		= {	"You know... It's not that bad in here now that I'm not panicking.",
									"I'm actually starting to enjoy this, it's like getting used to a new bed.",
									"This is a safe haven compared to the likes back home."
	}
	myProfile["interact"][2]	= {	"Chances are you came here to eat me. Oh well, why not?",
									"I take it you're hungry for something and that something happens to be me?"
	}
	myProfile["release"][2] 	= {	"Yikes! I wasn't expecting to be let out so soon.",
									"Well. Thanks anyways for letting me in for a bit."
	}
	
	myProfile["bribe"][3]		= {	"Once you let me out, I'll pay you nicely for the belly bed you provided me.",
									"When you let me out of your belly. I'll give some pixels as a thanks."
	}
	myProfile["consumed"][3]	= {	"Heh, you seem to like my taste a lot!",
									"Thanks, I needed a squishy bed anyway!",
									"Bon appetit... I guess."
	}
	myProfile["death"][3] 		= {	"T-Thanks for not making it painful this time..."
	}
	myProfile["idle"][3] 		= {	"I'm loving it a lot in here!",
									"Feel free to keep me in here for awhile.",
									"I wonder if I could use your belly as a gaming spot.",
									"It's like a tight, warm squishy blanket. Hmmmmmm~!"
	}
	myProfile["interact"][3]	= {	"Hello my personal belly bed! Just kidding but hello anyways!",
									"I take it you're hungry and want a big fluffy wolfy to fill that gut?",
									"You poor thing. You look like you could use a big meal to fill up that stomach."
	}
	myProfile["release"][3] 	= {	"Can I stay a little bit longer, please?!",
									"Aww. I was having fun in there.",
									"Thanks for letting me stay in there and I hope I get to do it again!"
	}
	
	initHook()
	
end
