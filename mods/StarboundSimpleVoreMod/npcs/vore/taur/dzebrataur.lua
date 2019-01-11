require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"

legs[2] = "zebrataurlegsbelly"

playerLines = {	"Soon, you'll be a spirit too!",
				"It's always lovely when I don't need to hunt.",
				"The spirits have gifted you to me, surely!",
				"Now you will help fuel a great hunter!",
				"Welcome to my personal tribe!",
				"Another successful hunt!"
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