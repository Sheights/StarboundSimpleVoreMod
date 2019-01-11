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
	
	myProfile["bribe"][1]		= {	"h-hey could u let me out i can give ya something ",
									"oh myh l-let me out and i'l have a gift ",
									"n-no more i want to go , ya can have myh money"
	}
	myProfile["consumed"][1]	= {	"u-u could have ask ",
									"seem i didnt have a choise",
									"oh myh you could have a light in there a least"
	}
	myProfile["death"][1] 		= {	""
	}
	myProfile["idle"][1] 		= {	"that is new",
									"oh myh such guts",
									"soo~ soft ",
									"its kinda sticky",
									"oh it slipy in here",
									"hope ya take care of my ",
									"oh i hope i dont make u to heavy",
									"so wet",
									"thats moist ",
									"kinda dark in here ",
									"dont move to much ",
									"oooh~ its jiggle",
									"what are ya doing ",
									"hey that new",
									"o-oh myh"
	}
	myProfile["interact"][1]	= {	"oh yeah how are ya",
									"oh its nice to see ya",
									"what a nice day isnt it ",
									"oh hi stranger ",
									"ehehe u seems nice",
									"u-u seems hugry"
	}
	myProfile["release"][1] 	= {	"Ouf thats a reliefe ",
									"berf i'm all sticky ",
									"thank kia"
	}	
	myProfile["bribe"][2]		= {	"its been good but i feel cramped maybe i should go out ",
									"i-i can give u something if you spit me ",
									"o-oh myh the time have past i need to go"
	}
	myProfile["consumed"][2]	= {	"Here again ",
									"y-your mouth feeled pretty nice",
									"i'l start to think u love me in there"
	}
	myProfile["death"][2] 		= {	""
	}
	myProfile["idle"][2] 		= {	"hey its funny ",
									"ooooh~ soft under the paw ",
									"hehe it fell good inside ",
									"kinda love it in here ",
									"*rubs the stomach *",
									"i-i love your tummy ",
									"thats really comfortable ",
									"hehe that tickle's",
									"oh myh its wiggle's a lot",
									"myh myh so soft ",
									"its lovely in there"
	}
	myProfile["interact"][2]	= {	"oh u seems lovely today ",
									"hey its good to see u ",
									"oh hi deary",
									"u look heavenly ",
									"nice look"
	}
	myProfile["release"][2] 	= {	"oh myh that wasnt where i was",
									"happy to be out ",
									"well i guess cya later ?"
	}
	
	myProfile["bribe"][3]		= {	"hey lovely its good in there but i have things to do maybe u could let me out.",
									"hey i got a gift for u ",
									"i think its time i come back out "
	}
	myProfile["consumed"][3]	= {	"Oh thats my nice bed ",
									"What a nice gut's ",
									"Hehehe on another trip i see"
	}
	myProfile["death"][3] 		= {	""
	}
	myProfile["idle"][3] 		= {	"hehehe its really comfortable",
									"such lovely guts",
									"i luve u ",
									"i could stay here for ever ",
									"*kneads the gut's *",
									"*smooch your inside *",
									"*tail wags *",
									"soo~ comfortable ",
									"*blush*",
									"its some good belly growl's",
									"hehe i hope i dosent make u to big ",
									"hehe thats smoe nice wiggle",
									"make that rear wiggle",
									"can u make gut jiggle ?",
									"i love your softness ",
									"i hope u can eat me more often ",
									"can u keep me longuer ",
									"can i take a nap ",
									"better than a pillow",
									"what a nice bed ",
									"better than a mattress",
									"can u massage's me ",
									"some carress could be good ",
									"those nice rubs are heavenly ",
									"better than i could ask ",
									"i'm unlucky , i can watch at ur beatifull cure in here",
									"maybe next time u could be in my belly ",
									"hehe be carefull with me inside ",
									"*poke your inside*"
	}
	myProfile["interact"][3]	= {	"oh myh i love ya sweety",
									"oh you look lovely today ",
									"yar so kind ",
									"what about we do something ",
									"is that u belly that growls"
	}
	myProfile["release"][3] 	= {	"oh already ?",
									"i was pretty comfortable inside",
									"Nuuuo~ i wanna stay in "
	}
	
	initHook()
	
end
