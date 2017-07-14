require "/scripts/vore/npcvore.lua"

eggeffect = "npceggocto"
playerLines = {}

egglock = false

--Player is idle in the belly after forcibly ate
playerLines["forceidle"] = {
	"Don't mind the squeezes, I just love to hug my belly!",
	"I'll only jostle you a little bit~",
	"You're wriggles feel so good and tingly! Keep it up!",
	"I almost wish I could fit another in there!",
	"A~ah, It's delightful to be so round and heavy.",
	"Oof, good thing my tentacles are so strong.",
	"Aaau~ Did you just kick me~? Silly!",
}

--Player is idle in the belly after requesting to be eaten
playerLines["requestidle"] = {
	"Are you relaxed in there? Let me know if you need anything.",
	"If you push any harder, I'm going to burst!",
	"I almost wish I could fit another in there!",
	"How do you feel about having a twin~?",
	"I love being so full! You make me look so good.",
	"I can hardly move with you weighing me down, but that's okay!"
}

--Player is idle in the belly after requesting to be eaten and has been egged
playerLines["requestidleegg"] = {
	"Were you always this heavy?",
	"I think I look even rounder~",
	"My precious child, it's almost time~",
	"Let me hum you a song, little one...",
	"I think I need to sit down, you've become so cumbersome."
}

--Player forcibly to be eaten
playerLines["forceeat"] = {
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

--Player requested to be ate and is now an egg
playerLines["egged"] = {
	"Ah, it's too late. You are my child now~",
	"You're easier to push out as an egg.",
	"Oops, you're an egg now~ Oh well.",
	"Relax, you'll be back to normal eventually~",
	"I just had to add you to the family~"
}

--Player is forcibly ate and released after timeout. Player will be an egg
playerLines["exit"] = {
	"Welcome to the family, my dear!",
	"Just relax, you'll hatch in time~",
	"Oof... Pushing out an egg is much easier~",
	"Eggs slide out so easily.",
	"We can do this agian once you hatch~",
	"Will you call me mother now~?",
	"I will always keep you safe, now that you are mine~"
}

--Player is forcibly ate and released after request. Not an egg
playerLines["escape"] = {
	"A~Ah! You left me too soon, my dear~",
	"My body feels empty without you, come back soon.",
	"Aw, I miss you already.",
	"Oooh... Come back, I need you inside of me...",
	"Uhn... How could you leave me so empty?",
}

--Player requested to be ate and requested release. Not Egged
playerLines["release"] = {
	"I hope you return to me, someday.",
	"Untill next time, my dearest.",
	"Safe travels, my dear.",
	"I will be waiting with open arms, and open tentacles.",
	"I hope you enjoyed our time together, love."
}

--Player requested to be ate and requested release. Egged
playerLines["releaseegg"] = {
	"Thank you for staying with me, my child~",
	"Look how cute you are, my little egg~",
	"So soft and delicate you have become... I will protect you.",
	"Let me cradle you, little egg.",
	"Take your time, you will hatch when you're ready~",
	"Would you like some siblings?"
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
	
	if ci == 3 then ci = 1 end
	if ci == 4 then ci = 0 end
	if ci == 6 then ci = 5 end
	if ci == 8 then ci = 2 end
	if ci == 10 then ci = 9 end
	eggeffect = eggeffect .. tostring(ci)

end

--For some reason, I cannot get the "exit" lines to play, it always defaults to "release". If it can be fixed, let me know.
function digestHook(id, time, dead)
	sayLine( playerLines["exit"] )
	world.sendEntityMessage( id, "applyStatusEffect", eggeffect, 60, entity.id() )
	egglock = false
end

function releaseHook(input, time)
	if egglock then
		sayLine( playerLines["releaseegg"] )
	elseif request[1] then
		sayLine( playerLines["release"] )
	else
		sayLine( playerLines["escape"] )
	end
	
	if time >= 60 then
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", "voreclear", 1, entity.id() )
		world.sendEntityMessage( input.sourceId, "applyStatusEffect", eggeffect, 60, entity.id() )
	end
	egglock = false
end

function feedHook()
	sayLine( playerLines["forceeat"] )
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	sayLine( playerLines["requesteat"] )
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook(input)
	if stopWatch[1] > 60 and egglock == false and request then
		egglock = true
		sayLine( playerLines["egged"] )
	end
	if containsPlayer() and math.random(700) == 1 then
		if request[1] then
			if egglock then
				sayLine( playerLines["requestidleegg"] )
			else
				sayLine( playerLines["requestidle"] )
			end
		else
			sayLine( playerLines["forceidle"] )
		end
	end
end