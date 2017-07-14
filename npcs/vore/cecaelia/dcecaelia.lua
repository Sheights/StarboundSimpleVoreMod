require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"
playerLines = {}

--Player is idle in the belly after forcibly ate
playerLines["forceidle"] = {
	"Mmmhm... You feel so marvelous, wriggling around like that.",
	"How does it feel, being squished by my belly and my tentacles?",
	"Fufufu...",
	"Are you soft yet? I wouldn't come back out if you're that far along.",
	"If you sleep, you won't notice a thing~",
	"I'll be putting on more weight than I thought...",
	"A treat fit for a queen~"
}

--Player is idle in the belly after requesting to be eaten
playerLines["requestidle"] = {
	"Fufufu... Take a nice, long rest in there...",
	"Oof. You wriggle around more than my tentacles.",
	"I can't beleive you fit in there!",
	"Now I have to lug you around all day. Hmph.",
	"Oh, I love fealing so heavy!",
	"My sisters prefer their 'prey' enter a different way. I like this way just fine!",
	"Your willingness makes this wonderful in its own way~",
	"You were almost a little too easy~"
}

--Player forcibly to be eaten
playerLines["forceeat"] = {
	"Nnnh... You're a lot bigger than I expected...",
	"Ah-ha, there you are, my mid-day snack.",
	"Afufu, you just looked too good to resist!",
	"How far in will you go~?",
	"Stay in there for a while, kay?",
	"I can't stand another bite of fish, so you'll do~",
	"Did my tentacles wander? Oh well~ You're mine now."
}

--Player requests to be eaten
playerLines["requesteat"] = {
	"Oh? Well, it's not every day my lunch comes to me~",
	"I hope you know it's a one way trip~",
	"You're much tastier than fish!",
	"Just be gentle on your way in, don't damage the royal throat.",
	"Oof! Well well, you're quite the eager meal~",
	"Who am I to deny a loyal fan's request~?",
	"Fufufu, you slipped inside so easily~",
	"You're lucky you looked delicious enough for this~"
}

--Player is forcibly ate and released after timeout
playerLines["exit"] = {
	"Hmph. You were a bit too much, even for me.",
	"I'm just saving you for next time~",
	"I'm releaseing you with the garuntee you will return~",
	"You're so cute, wobbling like this made you dizzy~",
	"Don't forget to come back for dessert~",
	"Go ahead. Catch your breath... Then come back to me~"
}

--Player is forcibly ate and released after request
playerLines["escape"] = {
	"You won't be away for long, I know it.",
	"It won't be long before you return to my embrace~",
	"Ah, just a little longer and you would have... Mmmmmh~",
	"Once you've been with me once, you're fated to always return~",
	"I could have kept you, if I had wanted."
}

--Player requested to be ate and requested release
playerLines["release"] = {
	"Oh well, I wish you would have stayed just a little longer~",
	"Afufufu, come back soon~",
	"Oh I do hope you come back, sweet one~",
	"Tch... Well, perhapse you'll stay longer next time~",
	"I thought you wanted to be a part of me?",
	"Too hot for you to handle in there~?"
}

--Player dies in stomach, but is still digesting
playerLines["death"] = {
	"Oops, stayed a little too long didn't you?",
	"What a shame, you're lovely wriggling has stopped.",
	"Hehe, you feel so lovely sloshing around in there~",
	"Aaah, finally the tension in by belly has eased~",
	"I feel so much lighter already!",
	"I think I have room for seconds now."
}

--Player dies in stomach and is finished digesting
playerLines["expelled"] = {
	"How satisfying a meal you were!",
	"Hmm, how can I already be hungry agian?",
	"My lovely hips will look so wonderful soon.",
	"I already miss being so full... Time to find another~",
	"Uurp... Oof, excuse me. That wasn't very ladylike~",
	"Now to go look for a little dessert~"
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

function deathHook()
	sayLine( playerLines["death"] )
end

--For some reason, I cannot get the "exit" lines to play, it always defaults to "release". If it can be fixed, let me know.
function digestHook(id, time, dead)
	if dead then
		sayLine( playerLines["expelled"] )
	else
		sayLine( playerLines["exit"] )
	end
end

function releaseHook(input, time)
	if dead[1] then
		sayLine( playerLines["expelled"] )
	elseif request[1] then
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