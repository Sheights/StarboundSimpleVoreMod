require "/scripts/vore/npcvore.lua"

playerLines = {}

--Player is idle in the belly after forcibly ate
playerLines["forceidle"] = {
	"Don't mind the squeezes, I just love to hug my belly!",
	"I'll only jostle you a little bit~",
	"I love being so full! You make me look so good.",
	"I can hardly move with you weighing me down, but that's okay!",
	"Aaau~ Did you just kick me~? Silly!",
	"You're wriggles feel so good and tingly! Keep it up!",
	"If you push any harder, I'm going to burst!",
	"I almost wish I could fit another in there!",
	"A~ah, It's delightful to be so round and heavy.",
}

--Player is idle in the belly after requesting to be eaten
playerLines["requestidle"] = {
	"Are you relaxed in there? Let me know if you need anything.",
	"I almost wish I could fit another in there!",
	"Oof, good thing my tentacles are so strong.",
	"I hope you're comfortable!",
	"Oooow, You sure are straining my belly.",
	"Are you wiggling in there? That tickles!",
	"Want me to rock you back and forth?",
	"I can hum a little song for you, if you want."
	
}

--Player forcibly to be eaten
playerLines["forceeat"] = {
		"Suprise~ A tentacle hug, and a ride inside!",
		"Hehe, I hope you don't mind...",
		"Don't worry, this doesnt hurt at all!",
		"Relax, I wont digest you!",
		"In you go! Oof, you're a big one!",
		"You're a bit big, but I'll manage... There, you're all inside now!",
		"Look how well you slid in! Wasn't that fun?",
		"I promise you'll be so relaxed once you're inside!",
		"You looked like you would fit so perfectly inside my belly!",
		"Oops, I didn't think you'd go in so easily! Hehe."
}

--Player requests to be eaten
playerLines["requesteat"] = {
	"Of course, in you go!",
	"Of course I'd love to cuddle! Come on in!",
	"Oooh, I sure love tummy cuddles!",
	"Just be gentle on your way in!",
	"I'd never turn down the chance to feel so full!",
	"Uurp, did you gain a little weight~?",
	"Mmmhm, you slide in so perfectly!"
}

--Player is forcibly ate and released after timeout
playerLines["exit"] = {
	"Mmm, that was fun~",
	"You got a little too heavy, I need a break~",
	"There there, I'll just clean you up a little...",
	"Hehe, are you all dizzy after that~?",
	"Mwah! Come back soon!"
}

--Player is forcibly ate and released after request
playerLines["escape"] = {
	"Aww... I feel so empty...",
	"Hey, wait! Didn't you wan't to stay longer?",
	"Oh! Wait, at least let me clean you up first!",
	"Oh my! So eager to leave me, that makes me sad...",
	"But I wanted to cuddle longer...",
	"Nooo, come back!"
}

--Player requested to be ate and requested release
playerLines["release"] = {
	"Come back next time you want to cuddle!",
	"I'll see you next time!",
	"I hope you had as much fun as I did!",
	"Mhm-mm! You we're fantastic! Come back anytime!",
	"I will be waiting with open arms, and open tentacles.",
	"Did you enjoyed our time together~?"
}

function initHook()

	if storage.ci == nil then
		ci = npc.getItemSlot("legs").parameters.colorIndex
		storage.ci = ci
	else
		ci = storage.ci
	end
	
	if storage.de == nil then
		de = npc.getItemSlot("chest").parameters.colorIndex
		storage.de = de
	else
		de = storage.de
	end
	
	chest[2] = {
		name = "cecaeliafullchest",
		parameters = {
					colorIndex = de
	}}
	
	legs[2] = {
		name = "cecaeliafulllegs",
		parameters = {
					colorIndex = ci
	}}

end

--For some reason, I cannot get the "exit" lines to play, it always defaults to "release". If it can be fixed, let me know.
function digestHook(id, time, dead)
	sayLine( playerLines["exit"] )
end

function releaseHook(input, time)
	if request[1] then
		sayLine( playerLines["release"] )
	else
		sayLine( playerLines["escape"] )
	end
end

function feedHook()
	sayLine( playerLines["forceeat"] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)

end

function requestHook(args)
	sayLine( playerLines["requesteat"] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook(input)
	if containsPlayer() and math.random(700) == 1 then
		if request[1] then
			sayLine( playerLines["requestidle"] )
		else
			sayLine( playerLines["forceidle"] )
		end
	end
end