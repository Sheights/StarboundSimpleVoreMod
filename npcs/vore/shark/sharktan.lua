require "/scripts/vore/npcvore.lua"

legs[2] = "sharktanlegsbelly"

playerLines = {	"Mmm you're fishfood now~",
				"Sorry meat, you needed a bigger boat...",
				"This is how Jaws was meant to end.",
				"I'll be picking you out of my teeth tonight.",
				"How do you like seafood?",
				"If you find anything interesting in there, bring it back would you?"
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