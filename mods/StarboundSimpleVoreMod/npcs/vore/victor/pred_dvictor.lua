require "/scripts/vore/npcvore.lua"

capacity = 4
duration = 12

isDigest = true
effect 	= "npcdigestvore"

legs[2] = "victorlegsbelly1"
legs[3] = "victorlegsbelly2"
legs[4] = "victorlegsbelly3"
legs[5] = "victorlegsbelly4"

playerLines = {}

playerLines[1] = {	"Just wait, you'll be part of me soon~",
					"It feels sooo nice to have prey dying inside of me.",
					"I love when they squirm.",
					"You were delicious",
					"Just let my body do its work with you.",
					"*gurgle*"
}

playerLines["eat"] = {	"*Gulp!*"
}

playerLines["die"] = {	"Urp",
						"Burp",
						"Ahhh~"
}

playerLines["release"] = {	"Bleargh!"
}

playerLines["request"] = {	"If you want to die so much, then be it.",
							"Do you really want to die that much? Okay",
							"Fine by me."
}

playerLines["plea"] = {	"Why would I do that?",
						"No way.",
						"I don't like spitting out.",
						"Definitely not.",
						"Oh come on, I need your vitamins and minerals.",
						"If I release you, I'll have to do it with everyone."
}

function deathHook(input)
	sayLine( playerLines[ "die" ] )
end

function digestHook()
	sayLine( playerLines[ "release" ] )
end

function feedHook()
	sayLine( playerLines[ "eat" ] )
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	sayLine( playerLines[ "request" ] )
	request[#victim] = false
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function reqRelease(input, time)
	sayLine( playerLines[ "plea" ] )
end

function updateHook(dt)
	if math.random(700) == 1 and containsPlayer() then
		sayLine( playerLines[1] )
	end
end