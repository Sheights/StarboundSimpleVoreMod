require "/scripts/vore/npcvore.lua"

isDigest	= true
effect 		= "npcdigestvore"

playerLines = {	"You're about to become one with nature sweetie. Quite the honour.",
				"Elves taste better, but you'll do.",
				"You'll help the plants grow, and importantly, me~",
				"Time to give back to nature.",
				"I won't be hopping, skipping, or jumping anytime soon."
}

function initHook()
	if storage.legs == null then
		legs[1] = npc.getItemSlot("legs").name
		legs[2] = legs[1] .. "belly"
		storage.legs = legs[1]
	else
		legs[1] = storage.legs
		legs[2] = legs[1] .. "belly"
	end
end

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