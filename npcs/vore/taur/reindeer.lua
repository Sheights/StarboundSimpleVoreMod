require "/scripts/vore/npcvore.lua"

legs[2] = "reindeerlegsbelly"

playerLines = {	"You're about to become one with nature sweetie. Quite the honour.",
				"Elves taste better, but you'll do.",
				"You'll help the plants grow, and importantly, me~",
				"Time to give back to nature.",
				"I won't be hopping, skipping, or jumping anytime soon."
}

function feedHook()
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "npcanimchomp" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end

function updateHook()
	if containsPlayer() and math.random(700) == 1 then
		sayLine( playerLines )
	end
end