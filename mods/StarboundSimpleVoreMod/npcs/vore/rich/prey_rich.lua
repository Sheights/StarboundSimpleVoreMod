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
	
	myProfile["bribe"][1]		= {	"I'll give you whatever you want, just let me go!",
									"Please let me out!   I'll give you some of my secret snacks if you do!"
	}
	myProfile["consumed"][1]	= {	"NO NO NO NO NO!",
									"WHAT THE HECK ARE YOU DOING?!",
									"Somebody help me!" ,
									"This is one cave I don't want to explore!"
	}
	myProfile["death"][1] 		= {	"Squeak!",
									"Aieeee!",
									"I failed!",
									"x.x"
	}
	myProfile["idle"][1] 		= {	"Please let me out, I don't want to be in here!",
									"It's so dark and disgusting in here!",
									"Ugh.. it's so gross in here.",
									"What the heck is wrong with you? I demand you let me out now!",
									"Let me out of here you jerk!",
									"It's kind of hard to breathe in here!",
									"This is probably the worst day of my life.",
									"Please.. no more.  Just spit me out already!"
	}
	myProfile["interact"][1]	= {	"Hi...",
									"I don't want you coming too close to me ...",
									"Let's just forget about what happened.",
									"I don't like you looking at me like that ..."
	}
	myProfile["release"][1] 	= {	"Oh thank god!",
									"Eugh, I'm gonna need a really long shower. ",
									"Oh thank goodness, some fresh air!",
									"Let's just forget this ever happened."
	}	
	myProfile["bribe"][2]		= {	"Not again! D-Do you want more of my money?!"
	}
	myProfile["consumed"][2]	= {	"NOT AGAIN!",
									"Please no, not again!",
									"I just took a bath already!",
									"I'm not food gosh darn it!",
									"Please no! Saliva is hard to wash off a fox tail!",
									"Why do  I even put up with you?!"
	}
	myProfile["death"][2] 		= {	"Help m-!",
									"Oh n-",
									"Why?",
									"Squeaak!"
	}
	myProfile["idle"][2] 		= {	"Wanted to do something else right now but here I am stuck inside of you again.",
									"Do you think this is funny?  I have the angriest pout on my face right about now.",
									"I think the worst part of this situation is how the saliva really gets into my fur and clothing.",
									"Blegh! It's so noisy in here, seriously that gurgling is getting on my nerves. ",
									"You're kind of a jerk, ya know that?" ,
									"This is not how I wanted to spend  my leisure time, but whatever. ",
									"So again.. why couldn't you have bugged someone else today?",
									"You know I'm adding this to your tab right?",
									"Maaaaan.. I hate the feeling of your saliva  all over me.",
									"Seriously, it's so disgusting inside of ya!",
									">:C"
	}
	myProfile["interact"][2]	= {	"Oh .. hello. ",
									"You're not thinking about eating me again you? ",
									"Ehhh.. can you not eat me again? I'm running low on detergent already .",
									"I'm not sure what's more dangerous, you or the wildlife on this planet. ",
									"So you're gonna reimburse me for my laundry right?"
	}
	myProfile["release"][2] 	= {	"Welp!  I guess it's another extra bath day.",
									"Ugh! Gotta give the tail a good scrubbing again.",
									"Okay for real, please don't do this ever again."
	}
	
	myProfile["bribe"][3]		= {	"... can I pay you so I can stay in here longer?",
	}
	myProfile["consumed"][3]	= {	"Eek! You snuck up on me.",
									"Hey!  .. maybe ask me next time?",
									"Oh!  Err hi again.",
									"Wasn't expecting stomach hugs from ya so soon!"
	}
	myProfile["death"][3] 		= {	"I trusted you!",
									"No!",
									"Why?",
									"Squeaaak!"
	}
	myProfile["idle"][3] 		= {	"I'm doing okay in here, thank you for asking.",
									"It's not so bad in here once you get used to it. Actually it's quite nice.",
									"I kinda like how warm and squishy it feels in here.",
									"So aside from having me as a snack,  did you have a nice day, buddy?",
									"It's nice to relax inside of a friend after a rough day.",
									"You're such a big ol lug, heheh.",
									"I honestly don't mind it in here, really!",
									"Was having some rough luck adventuring today, but you made me feel better.",
									"So.. ya come here often? Heheh.",
									"So be honest with me, am I like your favorite food since ya like to be a repeat customer?",
									"What time is it anyway?",
									"Try to drop me off at my shower when you're done with me, it makes it a lot easier for me.",
									"Kinda smells like Floran in here.  Good to know you're eating your veggies I guess.",
									"Lighten up on the squishing will ya? It's getting just a bit too cramped in here.",
									"How much longer are ya gonna keep me in here?"
	}
	myProfile["interact"][3]	= {	"Hello!",
									"Welcome back my friend.",
									"So uhh.. you in the mood to eat me again?",
									"If you promise to help clean my tail afterward,  maybe we can have another go at me being your snack.",
									"You have that hungry look again... in the mood for some fun eh?",
									"Hello again ya big lug.",
									"How's it going big guy?",
									"You should really lay off eating people, you're kinda packing the pounds.",
									"Hey buddy! Eat anything interesting lately?",
									"So have you tried eating the bird people? I'd imagine they taste like chicken.",
									"So does it count as being vegetarian if you only eat Florans?",
									"Truth be told, being eaten is quite nice when the weather starts getting older."
	}
	myProfile["release"][3] 	= {	"Aww...",
									"I was actually getting comfortable in there.",
									"Can I have a few more minutes inside of you, pleaaaaase?",
									"Hey! It was nice and warm in there, put me back!",
									"Aww~  I liked our bonding moments."
	}
	
	initHook()
	
end
