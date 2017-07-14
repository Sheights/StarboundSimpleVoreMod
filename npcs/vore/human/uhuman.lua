require "/scripts/vore/npcvore.lua"

audio 	= false
legs[2]	= "humannakedlegsbelly"

function feedHook()
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( tempTarget ), entity.id(), {0, 0}, false)
end

function requestHook(args)
	world.spawnProjectile( "swallowprojectile" , world.entityPosition( victim[#victim] ), entity.id(), {0, 0}, false)
end