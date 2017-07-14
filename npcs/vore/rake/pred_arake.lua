--[[
OV+AV Rake:
pred_arake.lua
]]--
require "/npcs/vore/rake/pred_rake.lua"
--Because this NPC shares so much code with the default Rake, just use that code and replace what's necessary.

capacity = 2

AnalVoreChance = .5								--Chance of AV triggering versus OV, the higher the number, the more likely AV. This may be changed depending on the fox's mood.
ANAL_VORE_CHANCE_DEFAULT = AnalVoreChance or .5	--Default chance of AV triggering versus OV.

ORALVORE_SPEED_DEFAULT = 1						--Default for ORALVORE_SPEED since "teasy" mood lets him take longer.
ORALVORE_SPEED = ORALVORE_SPEED_DEFAULT			--Global for how many seconds the oral vore animation plays out.
ANALVORE_SPEED = 2								--How long in seconds the AV animation lasts.
							
							
--Below are all of the statuses that Rake can pick from, randomly chosen based on his current mood.	
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
					"*softly sways you in his gut.*"
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
--AVing the player.
playerLines["eatAV"] = {	"*moans, slipping you into his rear.*",
							"Mmm, been too long since anyone slid in that way.",
							"Ahh... It's clean in there, don't worry.",
							"*presses his rumpcheeks right over you, feeling you squirm your way in*",
							"*slides you into his rumpcheeks slowly, squeezing over you*",
							"Mmm, in you go.",
							"Ahh... Squirm and I might clench you in faster."
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
playerLines["talk"] = { "Hello there.",
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
						"Ever just get that urge to just push someone in somewhere pleasant?",
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
	legsav1 = {
		name = "rakelegsav1",
		parameters = {
					colorIndex = index
	}}	
	legsav2 = {
		name = "rakelegsav2",
		parameters = {
					colorIndex = index
	}}
	--Where's 3? AV3 is a single full belly, essentially.
	legsav4 = {
		name = "rakelegsav4",
		parameters = {
					colorIndex = index
	}}
	legsav5 = {
		name = "rakelegsav5",
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

--Unfortunately, I can't just use pred_rake.lua's feedHook() since AV+OV Rake includes a random chance to pick between AV or OV.
function feedHook()
	--This portion handles what Rake says when he successfully eats someone.
	--If he's eating someone to heal them, say something about their health.
	isAV = math.random() < AnalVoreChance	--Randomly picks between AV and OV. Depending on the mood, AV might have a higher chance.
	if (attemptedVore == "heal") then
		if (injuredness < .85) then
			if (injuredness < .3) then
				npc.say( playerLines["eatlowhp"][ math.random( #playerLines["eatlowhp"] )] )
			else
				npc.say( playerLines["eatmedhp"][ math.random( #playerLines["eatmedhp"] )] )
			end
			injuredness = 0
		else
			npc.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )
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
	end
	--Play dialog lines.
	if (attemptedVore == "affection") then
		npc.say( playerLines["eatAffectionate"][ math.random( #playerLines["eatAffectionate"] )] )		
	elseif (attemptedVore == "heal") then
		--Do nothing, dialog for that is handled above.
	elseif (isAV) then
		npc.say( playerLines["eatAV"][ math.random( #playerLines["eatAV"] )] )	
	else
		npc.say( playerLines["eat"][ math.random( #playerLines["eat"] )] )	
	end
	--Handle OV versus AV animation.
	if (isAV) then
		animationdelaytimer = 0
		npc.setItemSlot( "legs", legs[#victim])
		npc.setItemSlot( "head", headdefblink)	
		if (#victim == 1) then	
			npc.setItemSlot( "legs", legsav1)
		else
			npc.setItemSlot( "legs", legsav4)		
		end
		blinking = false
		animating = "analvore"
		animationtimer = ANALVORE_SPEED
	else
		animationdelaytimer = 0		
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
	--Set vore and message timers to their default delay.
	lastmsgtimer = MSG_DELAY
	lastvoretimer = VORE_DELAY	
	attemptedVore = "" --Sets attemptedVore back to nothing.
end

--Necessary to hook into the moods function in pred_rake.lua. When Rake is in a teasy mood, he's 30% more likely to AV the player.
function handleMoodsHook()	
	if (mood == "teasy") then
		AnalVoreChance = ANAL_VORE_CHANCE_DEFAULT + 0.3
	else
		AnalVoreChance = ANAL_VORE_CHANCE_DEFAULT
	end
end

--This is the code needed to end a vore animation.
function endVoreAnim()
	if (animationtimer == 0 and animating == "oralvore") then
		animating = ""
		blinking = true
		--Just good practice to reuse functions that do similar things. See getMoodHeadModel() for details.
		model = getMoodHeadModel(false)
		npc.setItemSlot( "head", model)
		dress()
	elseif (animationtimer == 0 and animating == "analvore") then
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
		elseif (animationtimer <= ORALVORE_SPEED*(2/3)) then
			npc.setItemSlot( "head", headswallow2)			
		end
	elseif (animating == "analvore") then
		mcontroller.clearControls()
		if (animationtimer <= ANALVORE_SPEED * (1/3)) then
			npc.setItemSlot( "legs", legs[#victim+1])
		elseif (animationtimer <= ANALVORE_SPEED * (2/3)) then
			if (#victim == 1) then
				npc.setItemSlot( "legs", legsav2)
			else
				npc.setItemSlot( "legs", legsav5)
			end
		end
	end
end