require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"

legs[2] = "centaurwhitelegsbelly"

playerLines = {	"The best way to travel cross country!",
				"Yes, this is what I meant by ride. I'm not wearing a saddle if you didn't notice.",
				"Its easier than you being riding on top.",
				"Try not to go to my flanks…",
				"Cityslickers, slick on the throat, slick in the stomach.",
				"Compliments to yer breeder!",
				"Now that's some prime grub!"
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