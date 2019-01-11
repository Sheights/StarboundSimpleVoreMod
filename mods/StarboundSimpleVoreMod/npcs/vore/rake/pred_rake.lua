--[[
OV Rake:
pred_rake.lua
]]--
require "/scripts/vore/npcvore.lua"

capacity = 2

--Due to a bug in multivore.lua, I'm segmenting Rake's swallowing to just this lua file to prevent him "eating" but not actually.
rakePlayerChance = playerChance or 1		--Float from 0.0 to 1.0 affecting how likely the player is to be eaten.
rakeNpcChance = npcChance or 1				--Float from 0.0 to 1.0 affecting how likely an NPC is to be eaten.
playerChancePrevious = playerChance or 1
npcChancePrevious = npcChance or 1
SWALLOWCHANCE = 400  						--Chance of vore triggering is 1 in this number per call. (Default: 400)
--These two are set to zero to prevent feed() from running automatically.
playerChance = 0							
npcChance = 0

--
injuredness = 0.0							--Float from 0.0 to 1.0. Current health / max health. The higher the number, the less injured the player.
VORE_DELAY = 5								--global for default vore delay.
lastvoretimer = VORE_DELAY/4				--Timer that decrements. Number of seconds before Rake can do another vore attempt. Initially VORE_DELAY to prevent him from eating immediately upon loading. Mostly to prevent him from just immediately swallowing someone he just let out.		
lastmsgmorning = false						--Boolean for if Rake's said "good morning" to his prey yet. True if he last said "good morning", false if he last said "good night"
attemptedVore = "" 							--String for the type of vore Rake's attempted. Accepted values: "" "heal" "pred" "teasy" "affection" "normal"
lastmsgtimer = 0							--Timer that decrements. Provides delay between messages.
MSG_DELAY = 15								--global for default message delay.
lastmoodtimer = 2							--Timer that decrements. Provides delay between changing moods. (It starts higher than 0 to account	for world-loading.)
lastmoodtimerupdate = 0						--Timer that increments at 6 times the rate of lastmoodtimer.
MOOD_DELAY = 120							--global for default mood delay.
teasedenytimer = 0							--Timer that decrements. Represents how long Rake's refusing to let his prey out on request.
teasetimer = 0								--When Rake randomly teases a player outside him, there's a small period where it's 8x more likely that he'll vore something afterwards.
lastinteracttimer = 0						--Timer that decrements. If the player presses E twice in that time span, it's safe to assume they're requesting out.
playerRequestedRakeRelease = false
DEFAULT_DURATION = 120						--Default length of time he holds his prey for. Can be changed due to his mood.
duration = DEFAULT_DURATION
talkTimer = 0

--
animating = "" 								--String for current animation. Accepted values: "" "affectionate" "licklips" "oralvore"
animationtimer = 0							--Timer that decrements. Represents each frame, used for timing animations.
animationdelaytimer = 0						--Timer that decrements. Delay between each animation.
blinking = true								--Boolean whether or not Rake is blinking. Typically disabled during animations.
blinktimer = 1								--Timer that decrements. Controls blinking speed.
blinkFor = 0.3								--Integer for how many seconds Rake's blink should last.
BLINK_SPEED = 0.05							--Default amount of time that blink lasts. Adds on some time afterwards.
BLINK_DELAY = 2.5							--Default amount of time between blinks. Adds on some time afterwards.
LICKLIPS_SPEED = 1							--Global for how many seconds Rake's licklips animation should play.
AFFECTION_SPEED = 5							--Global for how many seconds Rake's affectionate animation should play. (where he closes his eyes and enjoys his prey for a bit.)
ORALVORE_SPEED_DEFAULT = 1					--Default for ORALVORE_SPEED since "teasy" mood lets him take longer.
ORALVORE_SPEED = ORALVORE_SPEED_DEFAULT		--Global for how many seconds the oral vore animation plays out.
sleeping = false							--Boolean if the fox is currently asleep.
requestingVore = false

effect = "npchealvore"

mood = ""											--String for the fox's current mood. Accepted values: "" "pred" "predFull" "lazy" "teasy" "affectionate"
moods = {"", "pred","lazy","teasy","affectionate"} 	--Array of strings for fox's moods random moods.
moodStatus = ""										--The status that should display over the fox's head. No way to disable random statuses that I know of.

--Below are all of the statuses that Rake can pick from, randomly chosen based on his current mood.
moodStatuses = { }									
moodStatuses["pred"] = {
	"On the prowl.",
	"Looking for prey.",
	"Hunting.",
	"Looking for something to fill his belly.",
	"Feeling empty.",	
	"Has a predatory look in his eyes.",
	"Licking his lips.",
	"Wondering how many people he could fit."
}
moodStatuses["predFull"] = {
	"Sated.",
	"Enjoying his meal.",
	"Looking full.",
	"Content."
}
moodStatuses["lazy"] = {
	"Not sure what to do.",
	"Wants fun to drop into his lap.",
	"Has a lot to do and doesn't know what.",
	"Feeling lazy.",
	"Feeling uninspired.",
	"Looking for inspiration."
}
moodStatuses["teasy"] = {
	"Has a sly grin.",
	"Looking around.",
	"Feeling playful.",
	"Looking at you teasingly.",
	"Licking his lips.",
	"Playful.",
	"Looking to tease someone."
}
moodStatuses["affectionate"] = {
	"Has a warm smile.",
	"Wants to keep someone safe.",
	"Feeling safe.",
	"Wants a snuggle.",
	"In a good mood.",
	"Caring."
}

--Below are all of the lines that Rake can say aloud, depending on the situation.
playerLines = {}
--One prey, default.
playerLines[1] = {	"*lets out a burp, belly vibrating around you*",
					"*burps, belly squeezing over you*",
					"Ahh... All mine.",
					"Comfy in there?",
					"I'll keep you quite a while.",
					"Just relax and enjoy yourself.",
					"How's it feel in there?",
					"*strokes over you through the warm walls*",
					"Mmm... Always wonderful.",
					"Hehe, keep squirming in there.",
					"Let me know if you want out."
}
--One prey, player presses E inside him.
playerLines[11] = { "Mmm... Something you need?",
					"Just let me know when you want out.",
					"Yes? You feel wonderful in there.",
					"Ahh... Keep squirming.",
					"Happy to keep you as long as you want."
}
for i=1,#playerLines[1] do
        playerLines[11][#playerLines[11]+1] = playerLines[1][i] --Iterate through original list and add it all to second list.
end
--One prey, "predFull" or "teasy" mood.
playerLines[21] = { "In the right place at the right time.",
					"*sighs, stroking over his belly.*",
					"I'm glad you were around to help, hehe.",
					"Maybe I'll just keep you a while.",
					"Ahh, nice and full...",
					"Squirm lots, my lovely prey.",
					"Like it in there? I know I like having you.",
					"Mmm, so filling.",
					"Ah...",
					"*burps softly, patting his belly.*",
					"*burps, belly clenching around you.*",
					"*softly sways you in his gut.*",
					"Mmm, you know you like it in there.",
					"Don't think I won't catch you again, hehe."
}
for i=1,#playerLines[1] do
        playerLines[21][#playerLines[21]+1] = playerLines[1][i]	--Iterate through original list and add it all to second list.
end
--One prey, another player presses E once.
playerLines[31] = {
					"Mmm... Yes?",
					"I've room for another if you want to hang around...",
					"*sighs happily, rubbing over his belly* Something you need?",
					"Hello there.",
					"How can I help you?",
					"*strokes over his gut.* What can I do for you?",
					"Anything you need?",
					"Welcome, though I'm a little too busy to entertain, hehe.",
					"*sighs, rubbing his gut.* It's a lovely day, isn't it?",
					"Let me know whenever you want a warm place to rest, you might have to share it though.",
					"Care to share a room with someone?",
					"Care for a warm place to rest? Might be cramped, hehe.",
					"Just let me know if you get tired, happy to let you bunk.",
					"Anything I can do for you? Still space for another.",
					"*rubs over his belly* Like what you see?",
					"You look tired.",
					"*licks his lips teasingly*",
					"Careful walking around, I'm quite peckish.",
					"Looks like you could use a rest.",
					"Care to share a bed? I don't digest.",
					"I could probably fit you in here too, hehe.",
					"Hello.",
					"Don't be worried, my insides are very pleasant. Just ask them, *pats belly*"
}
--Two prey, default.
playerLines[2] = {	"Oof, can barely keep you two in there.",
					"Hope you two are comfy in there, I know it's a tight fit.",
					"Ahh... Tight, but enjoyable.",
					"*lets out a burp, belly vibrating around you two*",
					"Mmm... All mine.",
					"Let me know if either of you want out."
}
--Two prey, player presses E inside him.
playerLines[12] = {	"Mmm... Something you need?",
					"Just let me know when you want out.",
					"Yes? You feel wonderful in there.",
					"Ahh... Keep squirming.",
					"More than happy to keep you as long as you want."
}
for i=1,#playerLines[2] do
        playerLines[12][#playerLines[12]+1] = playerLines[2][i] --Iterate through original list and add it all to second list.
end
--Two prey, "predFull" or "teasy" mood.
playerLines[22] = { "In the right place at the right time.",
					"*sighs, stroking over his belly.*",
					"I'm glad you two were around to help, hehe.",
					"Maybe I'll just keep you two a while.",
					"Ahh, nice and full...",
					"Squirm lots, my lovely prey.",
					"Like it in there? I know I like having you two.",
					"Mmm, so filling.",
					"Ah...",
					"*burps softly, patting his belly.*",
					"*burps, belly clenching around you.*",
					"*softly sways you in his gut.*"
}
for i=1,#playerLines[1] do
        playerLines[22][#playerLines[22]+1] = playerLines[1][i] --Iterate through original list and add it all to second list.
end
--Two prey, another player presses E.
playerLines[32] = {
					"Mmm... Yes?",
					"I'm absolutely full, sorry.",
					"*sighs happily, rubbing over his belly* Something you need?",
					"Hello there.",
					"How can I help you?",
					"*strokes over his gut.* What can I do for you?",
					"Anything you need?",
					"Welcome, though I'm a little too busy to entertain, hehe.",
					"*sighs, rubbing his gut.* It's a lovely day, isn't it?",
					"If you want a warm place to rest, you might have to come back later, hehe.",
					"Sorry, Hotel Rake is full, hehe.",
					"Anything I can do for you?",
					"*rubs over his belly* Like what you see?",
					"*licks his lips teasingly*",
					"Mmm, I'm full.",
					"Don't worry about these two, I don't digest, hehe.",
					"Hello.",
					"Don't be worried, my insides are very pleasant. Just ask them, *pats belly*",
					"Oh, I'm stuffed.",
					"I think two's my limit, hehe."
}

playerLines["tooFull"] = {	
							"I'm absolutely full, sorry.",
							"*sighs happily, rubbing over his belly* Don't think I can fit you too, unfortunately.",
							"How can I help you? Little too full for a third, hehe.",
							"Welcome, though I'm a little too busy to entertain, hehe.",
							"If you want a warm place to rest, you might have to come back later, hehe.",
							"Sorry, Hotel Rake is full, hehe.",
							"*rubs over his belly* Like what you see?",
							"Mmm, I'm full.",
							"Don't be worried, my insides are very pleasant. Just ask them, *pats belly*",
							"Oh, I'm stuffed.",
							"I think two's my limit, hehe."

}
--Swallowing.
playerLines["eat"] = {	"*gluck*",
						"Mmm, always happy to have you.",
						"*swallows greedily*",
						"*pulls you in slowly, throat squeezing around you, before you slip down into his warm, wet belly.*",
						"Ah, nothing like a full belly.",
						"Mmm, stay a while."
}
--Swallowing because medium HP.
playerLines["eatmedhp"] = {	
							"*glucks you down* Careful, you're bleeding.",
							"*pats his belly* You can't run around injured like that. Carry bandages.",
							"*rumbles* Luckily I was around for you to rest and recover.",
							"Where are you going with wounds like that? Stay and rest.",
							"*swallows over you, tender with your injuries.*",
							"Erf... You looked hurt there. Relax until you feel better.",
							"Careful, exploring is dangerous. Let me heal you.",
							"It's just a scratch, but you could use a rest.",
							"*rubs over his belly* I've seen worse, but still.",
							"I hope you've got bandages, I can't help you all the time.",
							"Next time there's a cliff, wait until there's a fox at the bottom of it to catch you."
}
--Swallowing because near death.
playerLines["eatlowhp"] = { "You could've died. Rest in me until you recover.",
							"*glucks you down* Careful, you're bleeding.",
							"*pats his belly* You can't run around injured like that. Carry bandages.",
							"*rumbles* Luckily I was around for you to rest and recover.",
							"Where are you going with wounds like that? Stay and rest.",
							"*swallows over you, tender with your injuries.*",
							"Erf... You looked hurt there. Relax until you feel better.",
							"Please don't leave until you're healed.",
							"You're really, really hurt. Stay in me until you're better, okay?",
							"I hate to see folks as injured as you, let me heal you.",
							"Careful, another long fall could have ended you.",
							"Cliff diving is dangerous, you know."
}
--Swallowing in an "affectionate" mood.
playerLines["eatAffectionate"] = {	
						"*swallows you down slowly and carefully*",
						"Stay as long as you want, my friend.",
						"*hugs close, then glucks over you warmly.",
						"*swallows slowly, letting you enjoy the feel of his gullet squeezing over you.*",
						"*sighs* Love having friends close.",
						"*pats his belly gently* All mine..."
}
--Swallowing in an "teasy" mood.
playerLines["eatTeasy"] = {	
						"Mmm, always a delicious meal...",
						"*swallows greedily*",
						"*pulls you in slowly, throat squeezing around you, before you slip down into his warm, wet belly.*",
						"*pounces and glucks* Ahh... Much better place for you.",
						"Mmm, be sure to squirm lots in there, you're not leaving for a while...",
						"May not digest, but doesn't mean I won't keep you...",
						"Squirm all you want, but you'll grow to love it in there.",
						"*opens his maw wide in front of you, exhaling warm breath over your face, before swallowing warmly over you.*",
						"*runs his tongue over your face, before opening wide, slipping his maw right over you.*"
}
--Letting player leave.
playerLines["exit"] = {	"Come back anytime.",
						"Going so soon?",
						"*pushes you out the long way*",
						"You were delicious, come back again.",
						"Belly's always open for you."
}
--Morning with prey.
playerLines["morning"] = {	"*yawns* Good morning, did you sleep well?",
							"Morning, my prey.",
							"Slept well in there?",
							"Mmm... Nothing like waking up to a full belly."
}
--Dusk with prey.
playerLines["night"] = {	"*pats over his belly* Good night in there.",
							"Rest well, hehe. I know I will.",
							"Sleep well in there, I'll keep you safe.",
							"Mmm... I sleep best with a full belly."

}

--Player presses E to talk to him normally.
playerLines["talk"] = { 
						"Hello there.",
						"How can I help you?",
						"What can I do for you?",
						"Anything you need?",
						"Welcome.",
						"Come back anytime.",
						"It's a lovely day, isn't it?",
						"Let me know whenever you want a warm place to rest.",
						"Drop by later tonight and I'll give you a personal bed, hehe.",
						"Always welcome around here.",
						"Care for a warm place to rest?",
						"Just let me know if you get tired.",
						"Anything I can do for you?",
						"Something you'd like?",
						"You look tired.",
						"*licks his lips teasingly*",
						"Careful walking around, I'm quite peckish.",
						"Looks like you could use a rest.",
						"Care for a bed? I don't digest.",
						"I could probably fit you and a friend.",
						"Hello.",
						"Don't be worried, my insides are very pleasant."
}
--Player presses E to talk to him in an affectionate mood.
playerLines["talkAffectionate"] = { 
						"Hello there.",
						"How can I help you?",
						"What can I do for you?",
						"Anything you need?",
						"Welcome.",
						"Come back anytime.",
						"It's a lovely day, isn't it?",
						"Let me know whenever you want a warm place to rest.",
						"Always welcome around here.",
						"Care for a warm place to rest?",
						"Just let me know if you get tired.",
						"Anything I can do for you?",
						"Something you'd like?",
						"You look tired.",
						"Looks like you could use a rest.",
						"Care for a bed? I don't digest.",
						"Hello.",
						"Don't be worried, my insides are very pleasant.",
						"I've got a special place for you, if you'd like it."
}
--Player presses E to talk to him in a preddy mood.
playerLines["talkPred"] = { 
						"Hello there.",
						"Hello there, you look delicious.",
						"How can I help you?",
						"What can I do for you?",
						"Anything you need?",
						"Welcome.",
						"Come back anytime.",
						"It's a lovely day, isn't it?",
						"Let me know whenever you want a warm place to rest.",
						"Always welcome around here.",
						"Care for a warm place to rest?",
						"Just let me know if you get tired.",
						"Anything I can do for you?",
						"Something you'd like?",
						"You look tired.",
						"*licks his lips teasingly*",
						"Careful walking around, I'm quite peckish.",
						"Looks like you could use a rest.",
						"Care for a bed? I don't digest.",
						"I could probably fit you and a friend.",
						"Hello.",
						"Don't be worried, my insides are very pleasant.",
						"Anyone ever tell you that you look delicious?",
						"I could use a full belly, don't suppose you'd volunteer?",
						"Ever just get that urge to eat someone your own size?",
						"I could use a snack, hehe.",
						"Care to be a belly filler for a while?",
						"I'm really quite the fearsome predator. Okay, maybe not *fearsome*."
}
--Player presses E to talk to him in a teasy mood.
playerLines["talkTeasy"] = { 
						"Hello there.",
						"Hello there, you look delicious.",
						"How can I help you?",
						"What can I do for you?",
						"Anything you need?",
						"Welcome.",
						"Come back anytime.",
						"It's a lovely day, isn't it?",
						"Let me know whenever you want a warm place to rest.",
						"Always welcome around here.",
						"Care for a warm place to rest?",
						"Just let me know if you get tired.",
						"Anything I can do for you?",
						"Something you'd like?",
						"You look tired.",
						"*licks his lips teasingly*",
						"Careful walking around, I'm quite peckish.",
						"Looks like you could use a rest.",
						"Care for a bed? I don't digest.",
						"I could probably fit you and a friend.",
						"Hello.",
						"Don't be worried, my insides are very pleasant.",
						"Anyone ever tell you that you look delicious?",
						"I could use a full belly, don't suppose you'd volunteer?",
						"I could use a snack, hehe.",
						"Care to be a belly filler for a while?",
						"*grins and gives you a slurp.* Mmm, delicious.",
						"I'd be careful walking around me right now, I'm liable to snap you up.",
						"Don't worry, I promise I don't bite, hehe.",
						"Would you like a tour of a fox's digestive system?",
						"I bet you a hundred pixels I could swallow you whole. Not a safe bet? Shame.",
						"I'm really quite the fearsome predator. Okay, maybe not *fearsome*.",
						"Care for somewhere to curl up? I promise I'll only keep you for a while...",
						"Once you've been inside me once, you'll never want to leave."				
}

--Player presses E to talk to him at night.
playerLines["nighttalk"] = { "*yawns* Hello there.",
						"What can I do for you?",
						"Anything you need?",
						"It's a lovely night, isn't it?",
						"It's bedtime, let me know if you want a warm place to rest.",
						"Shall I give you a personal bed now then? Hehe.",
						"Always welcome around here.",
						"Care for a warm place to rest?",
						"You must be getting tired now.",
						"Care to pass the night in a warm place?",
						"Something you'd like?",
						"You look tired.",
						"*licks his lips teasingly*",
						"It's late, and I'm sure you're tired. Come rest with me.",
						"Looks like you could use a rest.",
						"Care for a bed? I don't digest.",
						"Don't be worried about sleeping inside me, my insides are very pleasant."
}
--Rake's worried lines when he sees player missing health.
playerLines["playerminorhurt"] = {	"You okay? Might want to use a bandage.",
									"If it starts to hurt, let me know.",
									"*pats belly* Want me to patch up those scratches?",
									"I can take care of those bruises easily, if you'd like.",
									"Careful not to get seriously hurt, or I might take it on myself to heal you."
}
--Rake's random dialog to people when he's in a "teasy" mood.
playerLines["tease"] = {
						"You'd look better inside me, I think.",
						"*grins* I could eat you right up.",
						"*gives your cheek a slurp*",
						"Care for a tight, warm space?",
						"Careful, or you might get a faceful of fox maw when you're not looking.",
						"Mmm, I bet you taste delicious.",
						"Care for a trip through a fox?"
}
--Rake's random dialog to people when he's in an "affectionate" mood.
playerLines["affection"] = {
						"*rests an arm around your back*",
						"Always lovely to have you around.",
						"Don't be afraid to ask for a warm place.",
						"I'm here for you.",
						"*nuzzles softly*",
						"*smiles at you*"
}
--What Rake says in his "teasy" mood if he decides not to let them out on request and player requests to be let out.
playerLines["teasedeny"] = {
						"*churrs* No, think I'll keep you longer.",
						"Why should I let you out now, it's comfy, isn't it?",
						"Mmm... Maybe later.",
						"*chuckles, patting his belly* Later.",
						"Hehe, no, you're mine for now.",
						"Ask me again in a minute, hehe.",
						"Leaving so soon? Stay for now.",
						"Nah, I like having you in there.",
						"*pats over his belly* Nope, not yet.",
						"You're staying for now, hehe.",
						"But it's dangerous out here. You should stay where it's warm and snug, hehe.",
						"*rumbles softly, feeling your motions* Not yet, hehe."
}

function digestHook()

end

function initHook()
	index = npc.getItemSlot("legs").parameters.colorIndex --I could probably get rid of this since Rake only has one color, but it doesn't hurt to have in.
	--Lots of head options to choose from. They should be self-explanitory.
	headdef = {
		name = "rakehead",
		parameters = {
					colorIndex = index
	}}	
	headdefblink = {
		name = "rakeheadblink",
		parameters = {
					colorIndex = index
	}}
	headhappy = {
		name = "rakeheadhappy",
		parameters = {
					colorIndex = index
	}}
	headhappyblink = {
		name = "rakeheadhappyblink",
		parameters = {
					colorIndex = index
	}}	
	headpred = {
		name = "rakeheadpred",
		parameters = {
					colorIndex = index
	}}
	headpredblink = {
		name = "rakeheadpredblink",
		parameters = {
					colorIndex = index
	}}
	headpredtongue1 = {
		name = "rakeheadpredtongue1",
		parameters = {
					colorIndex = index
	}}
	headpredtongue2 = {
		name = "rakeheadpredtongue2",
		parameters = {
					colorIndex = index
	}}
	headpredtongue3 = {
		name = "rakeheadpredtongue3",
		parameters = {
					colorIndex = index
	}}	
	headteasy = {
		name = "rakeheadteasy",
		parameters = {
					colorIndex = index
	}}
	headteasyblink = {
		name = "rakeheadteasyblink",
		parameters = {
					colorIndex = index
	}}
	--Because the other types of Rake include pred_rake.lua, this is a hook for their costume pieces.
	initUniqueAnims()
	
	--Basically just so Rake knows what time of day it is once he's loaded. Keeps him from spouting off "good morning" every time he's loaded and eats something.
	if (world.timeOfDay() <= 0.51) then
		lastmsgmorning = true		
	else
		lastmsgmorning = false
	end

end

--Hook for vore-specific costume pieces.
function initUniqueAnims()
	headswallow1 = {
		name = "rakeheadswallow1",
		parameters = {
					colorIndex = index
	}}
	headswallow2 = {
		name = "rakeheadswallow2",
		parameters = {
					colorIndex = index
	}}
	headswallow3 = {
		name = "rakeheadswallow3",
		parameters = {
					colorIndex = index
	}}
	
	--Leg options to choose from.	
	legs[2] = {
		name = "rakelegsbelly1",
		parameters = {
					colorIndex = index
	}}	
	legs[3] = {
		name = "rakelegsbelly2",
		parameters = {
					colorIndex = index
	}}
end

function feedHook()
	--This portion handles what Rake says when he successfully eats someone.
	--If he's eating someone to heal them, say something about their health.
	if (attemptedVore == "heal") then
		if (injuredness < .85) then
			if (injuredness < .3) then
				sayLine( playerLines["eatlowhp"])
			else
				sayLine( playerLines["eatmedhp"])
			end
			injuredness = 0
		else
			sayLine( playerLines["eat"])
		end
	--If he's in a "pred" mood, then switch him to "predFull"
	elseif (attemptedVore == "pred") then
		mood = "predFull"
		moodStatus = moodStatuses[mood][math.random(#moodStatuses[mood])]
		npc.setStatusText(moodStatus)
	--If he's in an "affectionate" mood, then say an affectionate line, and disable him voring a second person.
	elseif (attemptedVore == "affection") then
		rakePlayerChance = 0
		rakeNpcChance = 0	
	--All else fails, just play a generic eat line.
	end		
	--Play dialog lines.
	if (attemptedVore == "affection") then
		sayLine( playerLines["eatAffectionate"])		
	elseif (attemptedVore == "heal") then
		--Do nothing, dialog for that is handled above.
	elseif (attemptedVore == "teasy") then
		sayLine( playerLines["eatTeasy"])	
	else
		sayLine( playerLines["eat"])	
	end	
	animationdelaytimer = 0
	feedHookType()
	
	--Set vore and message timers to their default delay.
	lastmsgtimer = MSG_DELAY
	lastvoretimer = VORE_DELAY	
	attemptedVore = "" --Sets attemptedVore back to nothing.
end

--Function for what type of vore to perform.
function feedHookType()
	npc.setItemSlot( "legs", legs[#victim])
	npc.setItemSlot( "head", headswallow1)		
	blinking = false
	animating = "oralvore"
	if ((mood == "teasy" or mood == "pred") and math.random() < .5) then
		ORALVORE_SPEED = ORALVORE_SPEED * 1.5			
	else
		ORALVORE_SPEED = ORALVORE_SPEED_DEFAULT			
	end
	animationtimer = ORALVORE_SPEED
end

function updateHook(dt)
	--Just in case Rake's affection-prey vanishes. Resets Rake back to being able to eat folks.
	if (#victim == 0 and mood == "affectionate" and rakePlayerChance == 0) then
		rakePlayerChance = playerChancePrevious
		rakeNpcChance = npcChancePrevious
	end
	--Timers! Sets them to decrement.
	lastvoretimer = handleTimer(lastvoretimer, dt)
	lastmsgtimer = handleTimer(lastmsgtimer, dt)
	lastmoodtimer = handleTimer(lastmoodtimer, dt)
	lastmoodtimerupdate = handleTimer(lastmoodtimerupdate, dt)
	teasedenytimer = handleTimer(teasedenytimer, dt)
	teasetimer = handleTimer(teasetimer, dt)
	lastinteracttimer = handleTimer(lastinteracttimer, dt)
	animationtimer = handleTimer(animationtimer, dt)
	animationdelaytimer = handleTimer(animationdelaytimer, dt)
	talkTimer = handleTimer(talkTimer, dt)
	
	--If Rake's able to blink, then decrement the blink timer.
	if (blinking) then
		blinktimer = handleTimer(blinktimer, dt)
	end
	
	--Get all people around Rake, people+eggs around Rake, and people just on top of Rake.
		--people = array of Entity_IDs representing everyone around Rake.
		--eggcheck = array of Entity_IDs representing everyone and all eggs around Rake.
	local people = world.entityQuery( mcontroller.position(), 7, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player"},
		boundMode = "CollisionArea"
	})	
	local eggcheck = world.entityQuery( mcontroller.position(), 7, {
		withoutEntityId = entity.id(),
		includedTypes = {"npc", "player", "projectile"},
		boundMode = "CollisionArea"
	})	
	
	--Handle random voring-------------------------------------
	if (not sleeping and notEaten()) then
		if (#people > #victim and #eggcheck == #people and #victim < capacity) then
			--If Rake is awake, is not full of prey already, and has at least one person in range outside of him, then
			for i=1,#people do
				--For each person, check their health. 
					--If they're between 85% and 100%, then Rake asks if they're okay.
					--If they've less, then the less health they have, the more likely it'll trigger a vore attempt.
				if (not isVictim(people[i])) then
					hp = world.entityHealth(people[i])
					injuredness = hp[1]/hp[2] -- number from 0 (dead) to 1 (uninjured)
					rnd = 400 - injuredness * 400 --Gives you a number between 0 and 400, so at 0 health there's a 50% chance of it triggering each frame.
					if (injuredness >= .85 and injuredness < 1 and math.random(300) == 1 and lastmsgtimer == 0) then
						sayLine( playerLines["playerminorhurt"])
						lastmsgtimer = MSG_DELAY
					elseif (#victim < capacity and math.random(800) <= rnd and lastvoretimer == 0) then
						attemptedVore = "heal"
						attemptFeed()
					end
				end
			end
			--Attempting to swallow in a predatory mood plays a predatory message on success.
			if (mood == "pred") then
				if (math.random(math.ceil(SWALLOWCHANCE/6)) == 1 and lastvoretimer == 0) then
					attemptedVore = "pred"
					attemptFeed()					
				end
			--Attempting to swallow in a teasy mood plays a teasy message on success.
			elseif (mood == "teasy" and teasetimer > 0) then
				if (math.random(math.ceil(SWALLOWCHANCE/8)) == 1 and lastvoretimer == 0) then
					attemptedVore = "teasy"
					attemptFeed()					
				end
			--Attempting to swallow in an affectionate mood plays an affectionate message on success.
			elseif (mood == "affectionate") then
				if (math.random(math.ceil(SWALLOWCHANCE/4)) == 1 and lastvoretimer == 0) then
					attemptedVore = "affection"
					ateSomeone = attemptFeed()
				end
			--Otherwise standard random attempt to swallow folks around him.
			elseif (math.random(SWALLOWCHANCE) == 1 and lastvoretimer == 0) then
				attemptedVore = "normal"
				attemptFeed()
			else
			
			end
		end
	end
	handleRandomVoreHook() --Hook function for branching Rakes.
	--Handle random taunts.------------------------------------------------
	--Only plays while he's awake.
	if (not sleeping) then
		if (#victim > 0) then
			if (containsPlayer()) then
				--Rake says good morning to his prey when it turns morning.
				if (world.timeOfDay() <= 0.51 and lastmsgmorning == false and lastmsgtimer == 0) then
					sayLine( playerLines["morning"])
					lastmsgtimer = MSG_DELAY
					lastmsgmorning = true
				--Rake says good night to his prey when it turns night.
				elseif (world.timeOfDay() >= 0.51 and lastmsgmorning == true and lastmsgtimer == 0) then
					sayLine( playerLines["night"])	
					lastmsgtimer = MSG_DELAY
					lastmsgmorning = false
				end
				--Random teasing and predatory lines when he's in "predFull" or "teasy" mood.
				if (mood == "predFull" or mood == "teasy") then
					if (math.random(700) == 1 and lastmsgtimer == 0) then
						--#victim+20 represents either 21 or 22, depending on how many prey Rake has.
						sayLine( playerLines[ #victim+20 ]) 
						lastmsgtimer = MSG_DELAY
					end
				--Otherwise play normal lines.
				else
					if (math.random(700) == 1 and lastmsgtimer == 0) then
						--#victim represents either 1 or 2, depending on how many prey Rake has.
						sayLine( playerLines[ #victim ])
						lastmsgtimer = MSG_DELAY
					end
				end
			end
		else
			--If there's a single player near him that isn't blocked by blocks...
			if (#people > 0) then
				if (world.entityType(people[1]) == "player" and lineOfSight(people[1])) then
					--If Rake's in a "teasy" mood, play a tease taunt.
					if (mood == "teasy" and math.random(400) == 1 and lastmsgtimer == 0) then
						sayLine( playerLines[ "tease" ])
						lastmsgtimer = MSG_DELAY*2
						teasetimer = 3
					--If Rake's in an "affectionate" mood, play an affectionate message.
					elseif (mood == "affectionate" and math.random(400) == 1 and lastmsgtimer == 0) then
						sayLine( playerLines[ "affection" ])
						lastmsgtimer = MSG_DELAY*2
					end
				end
			end
		end
	end
	handleTauntsHook() --Hook function for branching Rakes.
	--Handle moods------------------------------------------
	--Rake picks from his moods randomly every MOOD_DELAY seconds, which by default is about two minutes, give or take ten seconds.
	if (lastmoodtimer == 0) then
		--Set mood to a random mood, set up the mood timer delay.
		mood = moods[math.random(#moods)]
		lastmoodtimer = math.random(10)+MOOD_DELAY
		lastmoodtimerupdate = MOOD_DELAY/6
		--Handle status texts as long as Rake isn't in a blank mood.
		if (mood ~= "") then
			moodStatus = moodStatuses[mood][math.random(#moodStatuses[mood])]
			npc.setStatusText(moodStatus)
		end		
		--If Rake's in a teasy or affectionate mood, he can hold preys for twice as long.
		if (mood == "teasy" or mood == "affectionate") then
			duration = DEFAULT_DURATION * 2
		else
			duration = DEFAULT_DURATION
		end
		--Sets Rake's mood directly to "predFull" if he has any prey when he changes moods to "pred".
		if (mood == "pred" and #victim > 0) then
			mood = "predFull"
			moodStatus = moodStatuses[mood][math.random(#moodStatuses[mood])]
			npc.setStatusText(moodStatus)			
		end
		--Sets Rake to have a low chance to vore randomly if he's lazy, otherwise normal vore rates as defined at the top of the file.
		if (mood == "lazy") then
			rakePlayerChance = 0.1
			rakeNpcChance = 0.15
		else
			rakePlayerChance = playerChancePrevious
			rakeNpcChance = npcChancePrevious
		end
		--Set the fox's head to the model that represents that mood.
		model = getMoodHeadModel(false)
		npc.setItemSlot( "head", model)
		
	end
	--Rake's mood status changes 6 times per MOOD_DELAY. I've had some problems with it constantly picking the same mood status so I'm not too sure how Starbound's RNG cooperates.
	if (mood ~= "" and lastmoodtimerupdate <= 0) then
		lastmoodtimerupdate = MOOD_DELAY/6
		moodStatus = moodStatuses[mood][math.random(#moodStatuses[mood])]
		npc.setStatusText(moodStatus)
	end
	handleMoodsHook() --Hook function for branching Rakes.
	--Handle animations--------------------------------
	--This checks if Rake's lounging on a piece of furniture, and then checks his rotation to see if he's laying sideways. Closest thing I have to checking if he's asleep.
		--If he is asleep, it turns off blinking and switches his head to the blink varient so his eyes are closed.
	if (npc.isLounging() and math.abs(mcontroller.rotation()) > 0.9) then
		sleeping = true
		blinking = false
		model = getMoodHeadModel(true)
		npc.setItemSlot( "head", model )		
	elseif (sleeping and math.abs(mcontroller.rotation()) <= 0.9) then
		sleeping = false
		blinking = true	
		model = getMoodHeadModel(false)
		npc.setItemSlot( "head", model)
	end
	--If Rake can blink, then blink.
	if (blinking) then
		if (blinktimer == 0) then			
			--Then when the blinktimer hits 0, it sets Rake's head model to the normal varient and picks a random length of time between 2 seconds and 6 seconds before he blinks again.
			model = getMoodHeadModel(false)
			npc.setItemSlot( "head", model)
			blinktimer = (math.random(100)*0.01) + BLINK_DELAY --This is what decides how long until he blinks again.
			blinkFor = (math.random(30)*0.01)+BLINK_SPEED --This is what decides how long to have his eyes closed.
		elseif (blinktimer <= blinkFor) then
			--When the blinktimer hits the length of time to blink, it sets Rake's head model to the blink varient.
			model = getMoodHeadModel(true)
			npc.setItemSlot( "head", model )
		end
	end
	--If Rake's in the middle of his "affectionate" animation and his prey leaves, reset him back to normal state.
	if (animating == "affectionate" and #victim == 0) then
		animating = ""
		blinking = true
		animationdelaytimer = 500
		npc.setItemSlot( "head", headhappy)			
	end
	--Check to make sure no other animations are running.
	if (animationdelaytimer == 0) then
		--Rake's "affectionate" animation. He just closes his eyes for a few seconds.
		if (math.random(400) == 1 and mood == "affectionate" and #victim == 1 and animating == "") then
			animating = "affectionate"
			blinking = false
			animationtimer = AFFECTION_SPEED
			npc.setItemSlot( "head", headhappyblink)
		--Animation ended, reset Rake's headstate back to normal.
		elseif (animationtimer == 0 and animating == "affectionate") then
			animating = ""
			blinking = true
			animationdelaytimer = 500
			--Just good practice to reuse functions that do similar things. See getMoodHeadModel() for details.
			model = getMoodHeadModel(false)
			npc.setItemSlot( "head", model)		
		end
		--Rake's "licklips" animation. What it says on the tin.
		--He'll lick his lips if other people are around him while he's in a "pred" mood.
		if (math.random(400) == 1 and mood == "pred" and #victim == 0 and #people > 0 and animating == "") then
			animationtimer = LICKLIPS_SPEED
			animating = "licklips"
			blinking = false
			npc.setItemSlot( "head", headpredtongue1)	
		--He'll lick his lips if he has a belly full of prey in his "predFull" mood.
		elseif (math.random(200) == 1 and #victim > 0 and mood == "predFull" and animating == "") then
			animationtimer = LICKLIPS_SPEED
			animating = "licklips"
			blinking = false		
			npc.setItemSlot( "head", headpredtongue1)	
		--He'll lick his lips if he has a belly full of prey in his "teasy" mood.
		elseif (math.random(200) == 1 and #victim > 0 and mood == "teasy" and animating == "") then
			animationtimer = LICKLIPS_SPEED
			animating = "licklips"
			blinking = false		
			npc.setItemSlot( "head", headpredtongue1)	
		--He'll lick his lips if he has a belly full of prey at all, though the chance is much less likely.
		elseif (math.random(700) == 1 and #victim > 0 and animating == "") then
			animationtimer = LICKLIPS_SPEED
			animating = "licklips"
			blinking = false		
			npc.setItemSlot( "head", headpredtongue1)	
		--Animation done, reset Rake's head back to normal.
		elseif (animationtimer == 0 and animating == "licklips") then
			animating = ""
			blinking = true
			animationdelaytimer = math.random(500) + 1000
			--Just good practice to reuse functions that do similar things. See getMoodHeadModel() for details.
			model = getMoodHeadModel(false)
			npc.setItemSlot( "head", model)		
		elseif (animationtimer == 0) then
			endVoreAnim() --Ends the animation for the unique vore anim. (oral vore in this case)			
		end
		--The animation "licklips" is playing, so control which head model should be active during which part of the timer.
		if (animating == "licklips") then
			--forgive the messy timer calculation script. It just checks if the timer is 2/3 and 1/3 remaining time and it's messy so all I have to do is change one variable to change the timing.
			if (animationtimer <= LICKLIPS_SPEED * (1/3)) then	
				npc.setItemSlot( "head", headpredtongue3)	
			elseif (animationtimer <= LICKLIPS_SPEED*(2/3)) then	
				npc.setItemSlot( "head", headpredtongue2)		
			end
		end		
		playVoreAnim() --Plays the animation for the unique vore anim. (oral vore in this case)
	end
	handleAnimsHook() --Hook function for branching Rakes.
end

--Runs after all the random vore code.
function handleRandomVoreHook()

end

--Runs after all the mood code. (See AVrake for an example of using this.)
function handleMoodsHook() 
	
end

--Runs after all the taunt code.
function handleTauntsHook()

end

--Runs after all the animation code.
function handleAnimsHook()

end

--This is the code needed to end a vore animation.
function endVoreAnim()
	if (animating == "oralvore") then
		mcontroller.clearControls()
		animating = ""
		blinking = true
		--Just good practice to reuse functions that do similar things. See getMoodHeadModel() for details.
		model = getMoodHeadModel(false)
		npc.setItemSlot( "head", model)
		dress()
	end
end

--This is the code to play a currently running vore animation. It delays each 'frame' a fraction of the total time, so all I have to do is change the total time passed to change how long the animation runs.
function playVoreAnim()
	if (animating == "oralvore") then		
		mcontroller.clearControls()
		if (animationtimer <= ORALVORE_SPEED * (1/3)) then	
			npc.setItemSlot( "head", headswallow3)	
		elseif (animationtimer <= ORALVORE_SPEED * (2/3)) then
			npc.setItemSlot( "head", headswallow2)			
		end
	end
end

function interact(args)
	--talkTimer is a float from 0 to 1.
	if talkTimer > 0 then	
		if isVictim(args.sourceId) then	
			--If source of interaction is a prey, then let that prey out.
			reqRelease(args)	
			forceExit()
		else
			if (playerRequestedRakeRelease) then
				--If player hits E three times on a full Rake, it spits everyone out.
				for i=1, capacity do
					reqRelease(victim[i])
				end	
			elseif (#victim >= capacity) then
				--If player hits E twice on a full Rake, Rake tells them he can't fit them too.
				sayLine( playerLines["tooFull"])
				talkTimer = 0
				playerRequestedRakeRelease = true
				return
			else
				--If player hits E twice on an empty/half-full Rake, Rake eats them.
				requestingVore = true
				attemptFeed(args.sourceID)
			end
		end		
		talkTimer = 0		
	else
		talkTimer = 1
		playerRequestedRakeRelease = false
		speak(args)
	end
	if talkTimer > 0 then	
		--If the player taps E when Rake's in the mood, randomly choose not to let the player out on request.
		if (isVictim(args.sourceId) and mood == "teasy" and math.random (5) == 1 and teasedenytimer == 0) then
			teasedenytimer = 30
			talkTimer = 0
			speak(args)
		end
		if (teasedenytimer > 0) then
			talkTimer = 0			
		end
	end	
	if (lastinteracttimer < 0.7) then
		lastinteracttimer = 0.7 --Set so I can tell if the player's trying to request exit.
	end
	oldInteract(args)

	return nil

end

function forceExit()
	--If the player requests exit, play a line and set the vore delay.
	sayLine( playerLines["exit"])
	dress()
	lastvoretimer = VORE_DELAY/2
end

function attemptFeed()
	attemptFeed(nil)
end

--attemptFeed() overwrites feed()'s normal implementation. Returns true if assumed successful, false if failed.
function attemptFeed(ID)
	if (#victim >= capacity) then
		return false
	end
	--Return an array of everyone nearby.
	if (ID == nil) then
		local people = world.entityQuery( mcontroller.position(), 7, {
			withoutEntityId = entity.id(),
			includedTypes = {"npc", "player"},
			boundMode = "CollisionArea"
		})
		--Figure out what entity_ID is outside Rake.
		temp = nil
		for i=1,#people do
			if (not isVictim(people[i])) then
				temp = people[i]
			end
		end
		if (temp == nil) then
			return false
		end
	else
		temp = ID
	end
	--Attempt vore using relevant chance and discovered entity_ID.
	if (requestingVore) then
		requestingVore = false
		--success
	elseif (world.entityType(temp) == "player" and math.random() <= rakePlayerChance) then
		--success
	elseif (world.entityType(temp) == "npc" and math.random() <= rakeNpcChance) then
		--success
	else
		return false
	end
	--Ensure that the targeted prey is within Rake's sight. (Not through a wall, for example.)
	if (not lineOfSight(temp)) then
		return false
	end
	--Set the variables feed() needs, run the vore script, then set them back before feed() gets uppity.
	if (ID ~= nil) then		
		playerChance = 1
		npcChance = 1
		reqFeed(ID)
		playerChance = 0
		npcChance = 0
		return true
	end
	playerChance = 1
	npcChance = 1
	feed()
	playerChance = 0
	npcChance = 0
	return true
end

--lineOfSight(Entity_ID person)
--Takes an entity ID as a parameter, returns true or false if there's anything solid blocking Rake's line of sight.
function lineOfSight(person)	
	local collisionBlocks = world.collisionBlocksAlongLine(mcontroller.position(), world.entityPosition( person ), {"Null", "Block", "Dynamic"}, 1)
	if #collisionBlocks == 0 then
		return true
	end
	return false
end

--handleTimer(int timer)
--Takes a timer as a parameter, decrements it once, unless it's aleady 0. If it winds up below 0, set it to 0.
function handleTimer(timer, dt)
	if (timer > 0) then
		timer = timer - dt
		if (timer < 0) then
			timer = 0
		end
	end
	return timer
end

--getMoodHeadModel(bool blinking)
--Returns head model representing rake's current mood and the blinking model if blinking is true.
function getMoodHeadModel(blinking)
	--"", "pred","lazy","teasy","affectionate"
	if (mood == "lazy") then
		if (blinking) then
			return headdefblink
		end
		return headdef
	elseif (mood == "pred" or mood == "predFull") then
		if (blinking) then
			return headpredblink
		end
		return headpred
	elseif (mood == "teasy") then
		if (blinking) then
			return headteasyblink
		end
		return headteasy
	elseif (mood == "affectionate") then
		if (blinking) then
			return headhappyblink
		end
		return headhappy
	else
		return headdef
	end
end

--speak(array args)
--Takes args as an input, and depending on who is pressing E on Rake and how many prey he has, plays a different line.
function speak(args)
	--If a player is inside Rake and they press E, display unique dialog.
	if (isVictim(args.sourceId)) then
		--#victim+10 represents either 11 or 12, depending on how many prey Rake has.
		sayLine(playerLines[ #victim+10 ])
	elseif (#victim > 0) then
		--#victim+30 represents either 31 or 32, depending on how many prey Rake has.
		sayLine(playerLines[ #victim+30 ])
	else
		--Depending on the time of day, Rake will either do normal dialog, or night-specific dialog.
		thetime = world.timeOfDay() -- 0 is dawn, 0.5 is dusk, 1 is nearly dawn again.
		if (thetime > .5 and thetime < .95) then
			sayLine( playerLines["nighttalk"])
		else
			if (mood == "affectionate") then
				sayLine( playerLines["talkAffectionate"])
			elseif (mood == "pred") then
				sayLine( playerLines["talkPred"])
			elseif (mood == "teasy") then
				sayLine( playerLines["talkTeasy"])
			else
				sayLine( playerLines["talk"])
			end
		end
	end
	--If Rake's not letting them out on request, check how long it's been since the player pressed E on him and play teasing dialog if recently.
	if (#victim > 0 and teasedenytimer > 0 and mood == "teasy") then
		if (lastinteracttimer > 0) then
			sayLine( playerLines["teasedeny"])
		end
	end
	lastmsgtimer = MSG_DELAY --Reset lastmsgtimer so a random dialog doesn't overwrite the current message.
end

--Rake checks himself to make sure he's not "intents". This also means he won't randomly reach out of a tent or covering furniture to eat people either.
function notEaten()
	effects = status.activeUniqueStatusEffectSummary()	
	--Checks if number of effects is greater than 1 because "rakegrav" is always constant. If you're going to use this yourself, set it to:
	--if (#effects > 0) then
	if (#effects > 1) then
		for i=1, #effects do
			if (effects[i][1] == "intents") then
				return false
			end
		end
	end
	return true
end