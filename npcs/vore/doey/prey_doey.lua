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
	
	myProfile["bribe"][1]		= {	"Uhm, can you let me out? I have to water my plants...",
									"Hey, <playername>, if you let me out, I'll let you taste one of my watermelons!",
									"If you let me out, I can show you how to make a great straw hat by hand! ...Is that no?"
	}
	myProfile["consumed"][1]	= {	"H-hold on a sec, I still have work to do!",
									"Hang on! Can't you at least be a little more gentle?!",
									"O-oh dear! I really should be more used to this by now!"
	}
	myProfile["death"][1] 		= {	"A-ah, jeez. This is just embarrassing...",
									"Agh, I can't beleive this...",
									"*Sigh* I just hope I reform faster this time...",
									"Wow, you really seem to, ah, like me a lot..."
	}
	myProfile["idle"][1] 		= {	"*Cleans up insides... somehow*",
									"Hey, could you do me a favor and swallow my phone? Please?",
									"You know, if you put a few pillows and some blankets in here, this place could be really comfy! ...No?"
	}
	myProfile["interact"][1]	= {	"Remember to take a break sometimes! No need to push yourself to limits all the time.",
									"Fun fact! Watermelons are one of my favorite foods! ...Okay, that wasn't very fun.",
									"Nice to meet you, my name's Doey. I know I've said that about a hundred times, I just don't want you to forget.",
									"You're lucky, I wish I could explore the planets too. Ah, so many farms to be made.",
									"What a lovely day!"
	}
	myProfile["release"][1] 	= {	"Oh, I wasn't actually expecting for you to let me out! ...That's not a request to put me back in, by the way.",
									"Ah, fresh air! Now what should I do now...",
									"There we are! Next time you decide to do that, at least you're stomach will be clean",
									"As tight as it was, I have to admit, it was fun sloshing around inside of you. For a while."
	}	
	myProfile["bribe"][2]		= {	"Hey, did you know that slimes are hard to digest, kinda like gum! ...What do you mean that's just a myth?",
									"You know, if you were to swallow a watermelon, that would be pretty much be the same thing? ...other than the seeds, that's not very fun.",
									"Mind letting me out soon? I kinda have some crops to water..."
	}
	myProfile["consumed"][2]	= {	"Ah, time to get eaten... again.",
									"<playername>? You really need to take better care of yourself, I can't always clean up your insides.",
									"J-jeez! You really enjoy this, don't you?"
	}
	myProfile["death"][2] 		= {	"O-oh, wow, getting kind of sleepy...",
									"*Sigh* T-this, again...",
									"Ah... I should have... taken better care of my melons..."
	}
	myProfile["interact"][2] 	= {	"G-gah! Ah, sorry, reflex...",
									"Fun fact! ...Being a prey sucks if you're not a voreaphile.",
									"Hm? Need me to clean your insides again?",
									"Hey, if you see a straw hat around here, can you give it back to me? Please?"
	}
	myProfile["idle"][2]		= {	"*Sloshes about, while still trying to clean up... no real reason why though.",
									"T-take it easy! You got a slime on board!",
									"After a while, you kind of just get used to this feeling."
	}
	myProfile["release"][2] 	= {	"Whew, thought you were never going to let me out.",
									"Next time, I'm bringing a pillow. ...What? Your insides are comfy to me now.",
									"Jeez, now I'm like, 25% digestive fluids now...",
									"Since I'm out now, I think you should... uhm... never mind. I mean, constipation isn't that bad."
	}

	myProfile["bribe"][3]		= {	"If you spit me out, I'll let you have my straw hat! ...If I could even find it.",
									"Huh, your insides are really vieny."
	}
	myProfile["consumed"][3]	= {	"*Hums a little ditty*",
									"Is this how watermelons feel? Do watermelons even have feelings? ...God I'm bored.",
									"Huh, I think your stomach is all clean now.",
									"Mind eating some watermelon? I mean, you don't want me to starve do you?",
									"How many people have you eaten already? Just curious, cause it seems like everyone is eating everyone now.",
									"Do I at least taste good? Kind of a pain of mean to just eat me for no reason.",
									"Could you make a farm inside of someone's stomach? I mean, then they would never have to eat then."
	}
	myProfile["death"][3] 		= {	"Mea vita tua. Caro mea tua erunt . Sed ego vos nasci denuo eosdem. Gah! Sorry, just a prayer some Crazy Lady taught me...",
									"Ah, jeez, getting... really sleepy...",
									"...",
									"Zzz....",
									"Agh, just... remember to reform me..."
	}
	myProfile["idle"][3] 		= {	"This place could use some more fluff.",
									"*Smushes some more tough food*",
									"Man, this place is like a cave...",
									"Uhm, just how long have I been stuck inside of you?",
									"*Attempts to get comfortable*",
									"Despite this being a stomach, I have to say, you're a real softie on the inside!",
									"I hope no one is eating my watermelons while I'm gone, I'm going to enter this year's fair."
	}
	myProfile["interact"][3]	= {	"Gah! Why do I always freak out around you?!",
									"We should realy hang out sometime... and with me not in your stomach.",
									"Just because I look like I'm made of jello, I'm not.",
									"*Yawns* Ah, sorry, just been thinking about junk. Like, how do watermelons feel about being eaten? ...No, I don't want to find out.",
							        "You've ever seen the inside of a stoamch? I have... a lot.",
									"Wanna cuddle first??"
	}
	myProfile["release"][3] 	= {	"Whew, how long was I in there for?",
									"Please, keep your insides clean for next time, okay?",
									"There, I hope you enjoyed me inside of you. I... was okay with it.",
									"Next time, you should certainly eat more watermelon.",
									"Alright then, glad to see you didn't forget about me."
	}
	
	initHook()
	
end
