--[[
CV Rake:
pred_crake.lua
]]--
require "/npcs/vore/rake/pred_rake.lua"
--Because this NPC shares so much code with the default Rake, just use that code and replace what's necessary.

capacity = 1				--CV Rake can only hold one prey. Not a lot of space down there!
COCKVORE_SPEED = 1			--How long in seconds the CV animation lasts.
	

--Below are all of the statuses that Rake can pick from, randomly chosen based on his current mood.	
moodStatuses["pred"] = {
	"On the prowl.",
	"Looking for prey.",
	"Hunting.",
	"Looking for something to fill him.",
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
--One prey
playerLines[1] = {	"*groans softly, rubbing over you*",
					"*glorps around you*",
					"Mmm... Sticky in there?",
					"Comfy in there? I'd hope so, hehe.",
					"You're gonna smell like me for a while, hehe.",
					"How's it hanging? Hehe.",
					"How's it feel in there?",
					"*strokes over you through the wet, sticky walls*",
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
					"*sighs, stroking over his sacs.*",
					"I'm glad you were around to help, hehe.",
					"Maybe I'll just keep you a while.",
					"Ahh, nice and full down there...",
					"Squirm lots, my lovely prey.",
					"Like it in there? I know I like having you.",
					"Mmm, so filling.",
					"Ah...",
					"*groans softly, patting his sac.*",
					"*moans, sac clenching around you.*",
					"*softly sways you in his sac.*"
}
for i=1,#playerLines[1] do
        playerLines[21][#playerLines[21]+1] = playerLines[1][i]	--Iterate through original list and add it all to second list.
end
--One prey, another player presses E once.
playerLines[31] = {
					"Mmm... Yes?",
					"I'm absolutely full, sorry.",
					"*sighs happily, rubbing over his sac* Something you need?",
					"Hello there.",
					"How can I help you?",
					"*strokes over his sac.* What can I do for you?",
					"Anything you need?",
					"Welcome, though I'm a little too busy to entertain, hehe.",
					"*sighs, rubbing his sac.* It's a lovely day, isn't it?",
					"If you want a warm place to rest, you might have to come back later, hehe.",
					"Sorry, Hotel Rake is full, hehe.",
					"Anything I can do for you?",
					"*rubs over his sac* Like what you see?",
					"*strokes over his shaft teasingly.*",
					"Mmm, I'm full.",
					"Don't worry about them, I don't digest, hehe.",
					"Hello.",
					"Don't be worried, my insides are very pleasant. Just ask them, *pats sac*",
					"Oh, I'm stuffed.",
					"I think this is my limit, hehe."
}
--voring
playerLines["eat"] = {	"*softly moans as he presses you in.*",
						"Mmm... You're lucky to be in there.",
						"*soft flesh squeezes you downwards into a sticky space.*",
						"*pulls you in slowly, shaft squeezing around you, before you slip down into his warm, sticky sac.*",
						"Ooh... Gonna be fun having you in there.",
						"Mmm... Squirm lots in there."
}
--voring because medium HP.
playerLines["eatmedhp"] = {	
							"*schlurps you down* Careful, you're bleeding.",
							"*pats his sac* You can't run around injured like that. Carry bandages.",
							"*groans softly* Luckily I was around for you to rest and recover.",
							"Where are you going with wounds like that? Stay and rest.",
							"*presses you down, tender with your injuries.*",
							"Erf... You looked hurt there. Relax until you feel better.",
							"Careful, exploring is dangerous. Let me heal you.",
							"It's just a scratch, but you could use a rest.",
							"*rubs over his sac* I've seen worse, but still.",
							"I hope you've got bandages, I can't help you all the time.",
							"Next time there's a cliff, wait until there's a fox at the bottom of it to catch you.",
							"Don't worry, you'll feel better soon."
}
--Swallowing because near death.
playerLines["eatlowhp"] = { "You could've died. Rest in me until you recover.",
							"*moans, pressing you down* Careful, you're bleeding.",
							"*pats his sac* You can't run around injured like that. Carry bandages.",
							"*groans* Luckily I was around for you to rest and recover.",
							"Where are you going with wounds like that? Stay and rest.",
							"*swallows over you, tender with your injuries.*",
							"Erf... You looked hurt there. Relax until you feel better.",
							"Please don't leave until you're healed.",
							"You're really, really hurt. Stay in me until you're better, okay?",
							"I hate to see folks as injured as you, let me heal you.",
							"Careful, another long fall could have ended you.",
							"Cliff diving is dangerous, you know.",
							"Don't worry, you'll feel better soon."
}
--Swallowing in an "affectionate" mood.
playerLines["eatAffectionate"] = {	
						"*pushes you in slowly and carefully*",
						"Stay as long as you want, my friend.",
						"*hugs close, then presse your feet down into his shaft, pushing you down quickly.",
						"*swallows slowly, letting you enjoy the feel of his shaft squeezing over you.*",
						"*sighs* Love having friends close.",
						"*pats his sac gently* All mine..."
}
--Swallowing in an "teasy" mood.
playerLines["eatTeasy"] = {	
						"Mmm, always a wonderful meal...",
						"*groans softly, slowly and enjoyably pushing you downwards*",
						"*pulls you in slowly, shaft squeezing around you, before you slip down into his warm, wet sac.*",
						"*pounces, grins over you, before slowly feeding you down into his shaft.*",
						"Mmm, be sure to squirm lots in there, you're not leaving for a while...",
						"May not digest, but doesn't mean I won't keep you...",
						"Squirm all you want, but you'll grow to love it in there.",						
						"*softly moans as he presses you in.*",
						"Mmm... You're lucky to be in there.",
						"*soft flesh squeezes you downwards into a sticky space.*",
						"Ooh... Gonna be fun having you in there.",
						"Mmm... Squirm lots in there.",
						"You're gonna smell like me for a while, hehe.",
						"*groans, feeling you sliding down into that shaft, the walls squeezing around you, pre soaking into your form.*"
}

playerLines["exit"] = {	"*presses you up.*",
						"Mmm, you're gonna need to find a bath, I think.",
						"*strokes over himself and lets you out*",
						"Any time.",
						"Come back again, hehe."
}
--Morning with prey.
playerLines["morning"] = {	"*yawns* Good morning, did you sleep well?",
							"Morning, my prey.",
							"Slept well in there?",
							"Mmm... Nothing like waking up to a full sac, hehe."
}
--Dusk with prey.
playerLines["night"] = {	"*pats over his sac* Good night in there.",
							"Rest well, hehe. I know I will.",
							"Sleep well in there, I'll keep you safe.",
							"Mmm... I sleep best with a prey inside."

}
--Player presses E to talk to him normally.
playerLines["talk"] = { "Hello there.",
						"How can I help you?",
						"What can I do for you?",
						"Anything you need?",
						"Hello.",
						"Welcome.",
						"Come back anytime.",
						"It's a lovely day, isn't it?",
						"Let me know whenever you want a warm and sticky place to rest.",
						"Drop by later tonight and I'll give you a pleasant bed, hehe.",
						"Always welcome around here.",
						"Care for a warm and sticky place to rest?",
						"Just let me know if you get tired, have a special place for you.",
						"Anything I can do for you?",
						"Something you'd like?",
						"You look tired.",
						"Careful walking around, I'm quite peckish.",
						"Looks like you could use a rest.",
						"Care for a bed? Might be a bit sticky, I don't digest.",
						"I could probably fit you in a very pleasurable spot.",
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
						"Let me know whenever you want a warm and sticky place to rest.",
						"Drop by later tonight and I'll give you a pleasant bed, hehe.",
						"Always welcome around here.",
						"Care for a warm and sticky place to rest?",
						"Just let me know if you get tired, have a special place for you.",
						"Anything I can do for you?",
						"Something you'd like?",
						"You look tired.",
						"Careful walking around, I'm quite peckish.",
						"Looks like you could use a rest.",
						"Care for a bed? Might be a bit sticky, I don't digest.",
						"I could probably fit you in a very pleasurable spot.",
						"Don't be worried, my insides are very pleasant.",
						"I've got a *very* special place for you, if you'd like it."
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
						"Care to be a filler for a while?",
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
						"Don't be worried, my insides are very pleasant.",
						"Anyone ever tell you that you look delicious?",
						"I could use a filler, don't suppose you'd volunteer?",
						"I can think of somewhere fun to put you...",
						"Care to be a filler for a while?",
						"*grins* I think I know just where I want to put you.",
						"I'd be careful walking around me right now, I'm liable to put you somewhere fun.",
						"Don't worry, I promise I don't bite, hehe.",
						"Would you like a tour of a fox's reproductive system?",
						"I bet you a hundred pixels I could fit you down here. Not a safe bet? Shame.",
						"I'm really quite the fearsome predator. Okay, maybe not *fearsome*.",
						"Care for somewhere to curl up? I promise it's only a little sticky...",
						"Once you've been inside me once, you'll never want to leave."
}
--Player presses E to talk to him at night.
playerLines["nighttalk"] = { "*yawns* Hello there.",
						"What can I do for you?",
						"Anything you need?",
						"It's a lovely night, isn't it?",
						"It's bedtime, let me know if you want a warm place to rest.",
						"Shall I give you a pleasurable bed now then? Hehe.",
						"Always welcome around here.",
						"Care for a warm and sticky place to rest?",
						"You must be getting tired now.",
						"Care to pass the night in a warm, sticky place?",
						"Something you'd like?",
						"You look tired.",
						"It's late, and I'm sure you're tired. Come rest with me.",
						"Looks like you could use a rest.",
						"Care for a bed? I don't digest, even if it is sticky, hehe.",
						"Don't be worried about sleeping inside me, my insides are very pleasant."
}
--Rake's worried lines when he sees player missing health.
playerLines["playerminorhurt"] = {	"You okay? Might want to use a bandage.",
									"If it starts to hurt, let me know.",
									"*pats sac* Want me to patch up those scratches?",
									"I can take care of those bruises easily, if you'd like.",
									"Careful not to get seriously hurt, or I might take it on myself to heal you."
}
--Rake's random dialog to people when he's in a "teasy" mood.
playerLines["tease"] = {
						"You'd look better hanging between my legs, I think.",
						"*grins* I could slurp you right up.",
						"*gives your cheek a slurp, pressing in against you.*",
						"Care for a tight, warm, sticky space?",
						"Careful, or you might wind up walking into a warm, sticky shaft when you're not looking.",
						"Mmm, I bet you feel delicious.",
						"Care for a trip into a fox?"
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
						"*chuckles, patting his sac* Later.",
						"Hehe, no, you're mine for now.",
						"Ask me again in a minute, hehe.",
						"Leaving so soon? Stay for now.",
						"Nah, I like having you in there.",
						"*pats over his sac* Nope, not yet.",
						"You're staying for now, hehe.",
						"But it's dangerous out here. You should stay where it's warm and sticky, hehe.",
						"*groans softly, feeling your motions* Not yet, hehe.",
						"*merely sighs at your motions.",
						"*groans audibly.* Not yet, hehe."
}

--Hook for vore-specific costume pieces.
function initUniqueAnims()	
	cvlegs1 = {
		name = "rakelegsballscv1",
		parameters = {
					colorIndex = index
	}}
	cvlegs2 = {
		name = "rakelegsballscv2",
		parameters = {
					colorIndex = index
	}}
	legs[2] = {
		name = "rakelegsballs",
		parameters = {
					colorIndex = index
	}}
end

--Function for what type of vore to perform.
function feedHookType()
	npc.setItemSlot( "head", headdefblink)		
	npc.setItemSlot( "legs", cvlegs1)
	blinking = false
	animating = "cockvore"
	animationtimer = COCKVORE_SPEED
end

--This is the code needed to end a vore animation.
function endVoreAnim()
	if (animating == "cockvore") then
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
	if (animating == "cockvore") then
		mcontroller.clearControls()
		if (animationtimer <= COCKVORE_SPEED * (1/2)) then
			npc.setItemSlot( "legs", cvlegs2)				
		end
	end
end