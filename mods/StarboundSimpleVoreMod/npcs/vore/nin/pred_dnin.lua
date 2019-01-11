require "/scripts/vore/npcvore.lua"

capacity	= 2
effect		= "npcdigestvore"
isDigest	= true
playerLines = {}

legs[2]	= "ninlegsbelly1"
legs[3]	= "ninlegsbelly2"

playerLines[1] = {	"I can feel you getting softer in there.",
					"Soon you'll just be another layer of pudge.",
					"I wonder how much your bones will sell for this time?",
					"I hope you had something valuable on you.",
					"Mmm, I could still go for more :9",
					"Every moment you're in there, more and more of you becomes mine~",
					"I hope the others taste even better than you.",
}

playerLines["eat"] = {	"Ahh, down you go.",
						"Mmm, that's it, get in there.",
						"Mmm, down you go, food.",
						"Such a lovely bulge~",
						"Delicious...",
						"Mmm, squirm all the way down."
}

playerLines["die"] = {	"Ahh...just as you should be.",
						"Another layer of pudge, another set of bones to sell.",
						"*URP* Ahh, delicious~",
						"There's a good meal, churn away in a belly like you were designed.",
						"Mmm, and now you're all mine."
}
playerLines["request"] = {	"Well I certainly won't say no to free food.",
							"You better not try to get out before you're done.",
							"Free pudge? Well okay, down you go, food~"
}

playerLines["release"] = {	"Meh, I should have guessed.",
							"COMPLIANCE",
							"Fine, fine, make room for someone else.",
							"Well don't go in there if you're just going to jump right back out I:"
}

playerLines["exit"] = {	"Bah, I shouldn't be letting you go.",
						"This feels so wrong.",
						"Meh, I'm sure I'll find something even better."
}

function deathHook(input)
	sayLine( playerLines["die"] )
end

function digestHook(id, time, dead)
	if not dead then
		sayLine( playerLines["release"] )
	end
end

function feedHook()
	sayLine( playerLines["eat"] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook()
	sayLine( playerLines["request"] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function releaseHook(input, time)
	sayLine( playerLines["exit"] )
end

function updateHook(dt)
	if math.random(700) == 1 and containsPlayer() then
		sayLine( playerLines[1] )
	end
end